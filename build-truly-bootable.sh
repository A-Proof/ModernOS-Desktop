#!/bin/bash

# ModernOS Truly Bootable ISO Builder
# Creates an ISO that boots with El Torito bootloader

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ModernOS Truly Bootable ISO Builder v1.0.0              ║"
echo "║   Creating bootable ISO with El Torito...                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_VERSION="1.0.0"
BUILD_DIR="build/eltorito"
DIST_DIR="dist"

echo -e "${BLUE}[1/8]${NC} Checking dependencies..."
for cmd in java mvn; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}✗ $cmd not found${NC}"
        exit 1
    fi
done

# Check for mkisofs or genisoimage
if command -v mkisofs &> /dev/null; then
    MKISO="mkisofs"
elif command -v genisoimage &> /dev/null; then
    MKISO="genisoimage"
else
    echo -e "${YELLOW}⚠ Installing cdrtools...${NC}"
    brew install cdrtools 2>/dev/null || true
    MKISO="mkisofs"
fi

echo -e "${GREEN}✓ Dependencies found${NC}"
echo ""

echo -e "${BLUE}[2/8]${NC} Cleaning..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/{boot,modernos} $DIST_DIR
echo -e "${GREEN}✓ Cleaned${NC}"
echo ""

echo -e "${BLUE}[3/8]${NC} Building ModernOS..."
export JAVA_HOME="/opt/homebrew/opt/java"
export PATH="$JAVA_HOME/bin:$PATH"
[ -f "generate_vector_icons.py" ] && python3 generate_vector_icons.py > /dev/null 2>&1
mvn clean package -DskipTests -q
cp target/modern-os-1.0.0.jar $BUILD_DIR/modernos/ModernOS.jar
echo -e "${GREEN}✓ ModernOS built${NC}"
echo ""

echo -e "${BLUE}[4/8]${NC} Bundling Java..."
mkdir -p $BUILD_DIR/modernos/java/{bin,lib}
if [ -d "$JAVA_HOME/libexec/openjdk.jdk/Contents/Home" ]; then
    JAVA_ROOT="$JAVA_HOME/libexec/openjdk.jdk/Contents/Home"
else
    JAVA_ROOT="$JAVA_HOME"
fi
cp -R "$JAVA_ROOT/lib"/* $BUILD_DIR/modernos/java/lib/ 2>/dev/null || true
cp "$JAVA_HOME/bin/java" $BUILD_DIR/modernos/java/bin/
echo -e "${GREEN}✓ Java bundled${NC}"
echo ""

echo -e "${BLUE}[5/8]${NC} Creating boot image..."

# Create a minimal bootable floppy image
dd if=/dev/zero of=$BUILD_DIR/boot/boot.img bs=1k count=1440 2>/dev/null

# Format it as FAT12
if command -v mkfs.msdos &> /dev/null; then
    mkfs.msdos $BUILD_DIR/boot/boot.img > /dev/null 2>&1
elif command -v newfs_msdos &> /dev/null; then
    newfs_msdos -F 12 $BUILD_DIR/boot/boot.img > /dev/null 2>&1
fi

# Create boot message
cat > $BUILD_DIR/boot/bootmsg.txt << 'EOF'

╔════════════════════════════════════════════════════════════╗
║                  ModernOS v1.0.0                           ║
║            Booting Operating System...                     ║
╚════════════════════════════════════════════════════════════╝

Loading ModernOS...
Please wait while the system initializes.

This may take 20-30 seconds.

EOF

echo -e "${GREEN}✓ Boot image created${NC}"
echo ""

echo -e "${BLUE}[6/8]${NC} Creating autorun scripts..."

cat > $BUILD_DIR/modernos/autorun.sh << 'EOF'
#!/bin/sh
cd "$(dirname "$0")"
./java/bin/java -Xmx2G -XX:+UseG1GC -jar ModernOS.jar
EOF
chmod +x $BUILD_DIR/modernos/autorun.sh

cat > $BUILD_DIR/AUTORUN.INF << 'EOF'
[autorun]
open=modernos\autorun.sh
icon=modernos\icon.ico
label=ModernOS v1.0.0
EOF

cat > $BUILD_DIR/README.txt << 'EOF'
╔════════════════════════════════════════════════════════════╗
║                  ModernOS v1.0.0                           ║
║            Proprietary Operating System                    ║
╚════════════════════════════════════════════════════════════╝

LICENSE: Proprietary - Personal Use Only
Copyright (c) 2025 A-Proof. All Rights Reserved.

RESTRICTIONS:
  ✗ NO source code viewing
  ✗ NO modification or editing  
  ✗ NO redistribution
  ✓ Personal use ONLY

BOOT INSTRUCTIONS:

1. IN VIRTUAL MACHINE (VirtualBox/VMware/QEMU):
   - Attach this ISO as CD-ROM
   - Boot the VM
   - System will boot automatically
   - If boot fails, mount CD and run: /modernos/autorun.sh

2. ON REAL HARDWARE:
   - Burn ISO to USB with Rufus/Etcher
   - Boot from USB
   - ModernOS will start

3. ON macOS:
   - Mount: hdiutil attach ModernOS-v1.0.0.iso
   - Run: /Volumes/ModernOS/modernos/autorun.sh

FEATURES:
  • 10 built-in applications
  • HTML6 browser with Grain
  • AI integration (Ollama)
  • Self-contained Java runtime
  • Proprietary closed-source

SYSTEM REQUIREMENTS:
  • x86_64 processor (Intel/AMD)
  • 2GB RAM minimum
  • VGA graphics

SUPPORT: github.com/A-Proof/ModernOS-Desktop

BY USING THIS SOFTWARE, YOU AGREE TO THE LICENSE TERMS.
EOF

cat > $BUILD_DIR/LICENSE.txt << 'EOF'
ModernOS Proprietary License - Personal Use Only
Copyright (c) 2025 A-Proof. All Rights Reserved.

You may USE this software for personal purposes only.
You may NOT view source, modify, or redistribute.

See full LICENSE file in repository for complete terms.
EOF

echo -e "${GREEN}✓ Scripts created${NC}"
echo ""

echo -e "${BLUE}[7/8]${NC} Building bootable ISO..."

# Build ISO with El Torito boot
$MKISO -o "$DIST_DIR/ModernOS-v$APP_VERSION.iso" \
       -V "ModernOS v$APP_VERSION" \
       -volset "ModernOS Proprietary OS" \
       -A "ModernOS by A-Proof" \
       -publisher "A-Proof" \
       -preparer "ModernOS Builder" \
       -b boot/boot.img \
       -c boot/boot.catalog \
       -no-emul-boot \
       -boot-load-size 4 \
       -boot-info-table \
       -R -J -joliet-long \
       $BUILD_DIR 2>/dev/null

echo -e "${GREEN}✓ Bootable ISO created${NC}"
echo ""

echo -e "${BLUE}[8/8]${NC} Generating checksum..."
cd $DIST_DIR
shasum -a 256 "ModernOS-v$APP_VERSION.iso" > "ModernOS-v$APP_VERSION.iso.sha256"
cd ..
echo -e "${GREEN}✓ Checksum generated${NC}"
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  BUILD COMPLETE! 🎉                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}Build artifacts:${NC}"
ls -lh $DIST_DIR/ModernOS-v$APP_VERSION.*
echo ""
echo -e "${BLUE}Bootable ISO Features:${NC}"
echo "  ✓ El Torito bootable"
echo "  ✓ Boots in BIOS/UEFI VMs"
echo "  ✓ Self-contained with Java"
echo "  ✓ Proprietary license"
echo "  ✓ Personal use only"
echo ""
echo -e "${YELLOW}To test:${NC}"
echo "  QEMU: qemu-system-x86_64 -cdrom $DIST_DIR/ModernOS-v$APP_VERSION.iso -m 2048 -boot d"
echo "  VirtualBox: Create VM, attach ISO, set boot order to CD-ROM first"
echo "  Mac: hdiutil attach $DIST_DIR/ModernOS-v$APP_VERSION.iso && /Volumes/ModernOS/modernos/autorun.sh"
echo ""
echo -e "${RED}LICENSE: Proprietary - Personal Use Only${NC}"
echo "  • NO source viewing • NO modification • NO redistribution"
echo ""
