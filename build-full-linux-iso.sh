#!/bin/bash

# ModernOS Full Linux Bootable ISO Builder
# Uses Docker to build a complete Linux-based bootable OS

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ModernOS Full Linux ISO Builder v1.0.0                  ║"
echo "║   Building complete bootable Linux system...              ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_VERSION="1.0.0"
DIST_DIR="dist"

echo -e "${BLUE}[1/5]${NC} Checking Docker..."
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}✗ Docker not running${NC}"
    echo "Please start Docker Desktop and try again"
    exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

echo -e "${BLUE}[2/5]${NC} Building ModernOS JAR..."
export JAVA_HOME="/opt/homebrew/opt/java"
export PATH="$JAVA_HOME/bin:$PATH"
[ -f "generate_vector_icons.py" ] && python3 generate_vector_icons.py > /dev/null 2>&1
mvn clean package -DskipTests -q
echo -e "${GREEN}✓ ModernOS JAR built${NC}"
echo ""

echo -e "${BLUE}[3/5]${NC} Creating Dockerfile..."
cat > Dockerfile.fulllinux << 'DOCKERFILE'
FROM --platform=linux/amd64 debian:bookworm-slim

# Install build tools
RUN apt-get update && apt-get install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-common \
    grub2-common \
    grub-efi-ia32-bin \
    mtools \
    wget \
    curl \
    openjdk-17-jre-headless \
    xorg \
    openbox \
    xterm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Copy ModernOS
COPY target/modern-os-1.0.0.jar /build/ModernOS.jar

# Build script
RUN cat > /build/build-iso.sh << 'EOF'
#!/bin/bash
set -e

echo "Building Full Linux ISO for ModernOS..."

# Create directory structure
mkdir -p iso/{live,boot/grub,EFI/BOOT}
mkdir -p rootfs

# Create minimal Debian root filesystem
echo "Creating root filesystem..."
debootstrap --variant=minbase --include=linux-image-amd64,live-boot,systemd-sysv,openjdk-17-jre-headless,xorg,openbox,xterm bookworm rootfs http://deb.debian.org/debian

# Copy ModernOS into rootfs
mkdir -p rootfs/opt/modernos
cp /build/ModernOS.jar rootfs/opt/modernos/

# Create startup script
cat > rootfs/opt/modernos/start.sh << 'STARTEOF'
#!/bin/bash
export DISPLAY=:0
cd /opt/modernos
java -Xmx2G -jar ModernOS.jar
STARTEOF
chmod +x rootfs/opt/modernos/start.sh

# Create autostart for Openbox
mkdir -p rootfs/etc/xdg/openbox
cat > rootfs/etc/xdg/openbox/autostart << 'AUTOSTARTEOF'
# Start ModernOS automatically
/opt/modernos/start.sh &
AUTOSTARTEOF

# Create systemd service to start X and ModernOS
cat > rootfs/etc/systemd/system/modernos.service << 'SERVICEEOF'
[Unit]
Description=ModernOS Desktop
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/startx /usr/bin/openbox-session
Restart=always
User=root

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Enable the service
chroot rootfs systemctl enable modernos.service

# Create squashfs
echo "Creating squashfs..."
mksquashfs rootfs iso/live/filesystem.squashfs -comp xz

# Copy kernel and initrd
cp rootfs/boot/vmlinuz-* iso/boot/vmlinuz
cp rootfs/boot/initrd.img-* iso/boot/initrd.img

# Create GRUB config
cat > iso/boot/grub/grub.cfg << 'GRUBEOF'
set timeout=5
set default=0

menuentry "ModernOS v1.0.0" {
    linux /boot/vmlinuz boot=live quiet splash
    initrd /boot/initrd.img
}

menuentry "ModernOS v1.0.0 (Safe Mode)" {
    linux /boot/vmlinuz boot=live nomodeset
    initrd /boot/initrd.img
}
GRUBEOF

# Create ISOLINUX config
cp /usr/lib/ISOLINUX/isolinux.bin iso/boot/
cp /usr/lib/syslinux/modules/bios/ldlinux.c32 iso/boot/
cp /usr/lib/syslinux/modules/bios/menu.c32 iso/boot/
cp /usr/lib/syslinux/modules/bios/libcom32.c32 iso/boot/
cp /usr/lib/syslinux/modules/bios/libutil.c32 iso/boot/

cat > iso/boot/isolinux.cfg << 'ISOLINUXEOF'
DEFAULT menu.c32
PROMPT 0
TIMEOUT 50

MENU TITLE ModernOS v1.0.0

LABEL modernos
    MENU LABEL Start ModernOS
    MENU DEFAULT
    KERNEL /boot/vmlinuz
    APPEND initrd=/boot/initrd.img boot=live quiet splash

LABEL safe
    MENU LABEL ModernOS (Safe Mode)
    KERNEL /boot/vmlinuz
    APPEND initrd=/boot/initrd.img boot=live nomodeset
ISOLINUXEOF

# Create README
cat > iso/README.txt << 'READMEEOF'
╔════════════════════════════════════════════════════════════╗
║                  ModernOS v1.0.0                           ║
║         Full Linux Bootable Operating System              ║
╚════════════════════════════════════════════════════════════╝

This is a COMPLETE Linux-based operating system with ModernOS.

BOOT:
  - Burn to USB with Rufus/Etcher/dd
  - Boot from USB
  - ModernOS starts automatically in X11

FEATURES:
  ✓ Full Debian Linux base
  ✓ Real Linux kernel
  ✓ X11 graphics
  ✓ Openbox window manager
  ✓ ModernOS desktop
  ✓ Java 17 included

LICENSE: Proprietary - Personal Use Only
Copyright (c) 2025 A-Proof. All Rights Reserved.
READMEEOF

# Build ISO with GRUB and ISOLINUX
echo "Building ISO..."
grub-mkrescue -o /output/ModernOS-v1.0.0.iso iso \
    -- \
    -volid "ModernOS" \
    -b boot/isolinux.bin \
    -c boot/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table

echo "ISO built successfully!"
ls -lh /output/ModernOS-v1.0.0.iso
EOF

RUN chmod +x /build/build-iso.sh

CMD ["/build/build-iso.sh"]
DOCKERFILE

echo -e "${GREEN}✓ Dockerfile created${NC}"
echo ""

echo -e "${BLUE}[4/5]${NC} Building Docker image and ISO..."
echo -e "${YELLOW}This will take 10-15 minutes (downloading Linux packages)...${NC}"
echo ""

# Build Docker image
docker build -f Dockerfile.fulllinux -t modernos-fulllinux-builder .

# Run container to build ISO
mkdir -p $DIST_DIR
docker run --rm \
    -v "$(pwd)/$DIST_DIR:/output" \
    modernos-fulllinux-builder

echo -e "${GREEN}✓ Full Linux ISO built!${NC}"
echo ""

echo -e "${BLUE}[5/5]${NC} Generating checksum..."
cd $DIST_DIR
shasum -a 256 "ModernOS-v$APP_VERSION.iso" > "ModernOS-v$APP_VERSION.iso.sha256"
cd ..
echo -e "${GREEN}✓ Checksum generated${NC}"
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              FULL LINUX ISO COMPLETE! 🎉🎉🎉               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}Build artifacts:${NC}"
ls -lh $DIST_DIR/ModernOS-v$APP_VERSION.*
echo ""
echo -e "${BLUE}Full Linux ISO Features:${NC}"
echo "  ✓ Complete Debian Linux system"
echo "  ✓ Real Linux kernel (boots anywhere)"
echo "  ✓ X11 graphics system"
echo "  ✓ Openbox window manager"
echo "  ✓ ModernOS auto-starts"
echo "  ✓ Java 17 included"
echo "  ✓ GRUB + ISOLINUX bootloaders"
echo ""
echo -e "${YELLOW}Test:${NC}"
echo "  qemu-system-x86_64 -cdrom $DIST_DIR/ModernOS-v$APP_VERSION.iso -m 2048 -boot d"
echo ""
echo -e "${YELLOW}Burn to USB:${NC}"
echo "  sudo dd if=$DIST_DIR/ModernOS-v$APP_VERSION.iso of=/dev/sdX bs=4M status=progress"
echo ""
echo -e "${GREEN}This ISO has a FULL LINUX SYSTEM and will boot ModernOS!${NC}"
echo ""
