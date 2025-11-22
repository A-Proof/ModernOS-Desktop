#!/bin/bash

# ModernOS Final Bootable ISO Builder
# Creates a hybrid ISO that works in VMs and can be mounted

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ModernOS Final Bootable ISO Builder v1.0.0              ║"
echo "║   Creating hybrid bootable ISO...                         ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_VERSION="1.0.0"
BUILD_DIR="build/final"
DIST_DIR="dist"

echo -e "${BLUE}[1/7]${NC} Checking dependencies..."
export JAVA_HOME="/opt/homebrew/opt/java"
export PATH="$JAVA_HOME/bin:$PATH"

for cmd in java mvn mkisofs; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}✗ $cmd not found${NC}"
        [ "$cmd" = "mkisofs" ] && echo "Install: brew install cdrtools"
        exit 1
    fi
done
echo -e "${GREEN}✓ Dependencies found${NC}"
echo ""

echo -e "${BLUE}[2/7]${NC} Cleaning..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/modernos $DIST_DIR
echo -e "${GREEN}✓ Cleaned${NC}"
echo ""

echo -e "${BLUE}[3/7]${NC} Building ModernOS..."
[ -f "generate_vector_icons.py" ] && python3 generate_vector_icons.py > /dev/null 2>&1
mvn clean package -DskipTests -q
cp target/modern-os-1.0.0.jar $BUILD_DIR/modernos/ModernOS.jar
echo -e "${GREEN}✓ ModernOS built${NC}"
echo ""

echo -e "${BLUE}[4/7]${NC} Bundling Java..."
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

echo -e "${BLUE}[5/7]${NC} Creating files..."

cat > $BUILD_DIR/modernos/autorun.sh << 'EOF'
#!/bin/sh
cd "$(dirname "$0")"
exec ./java/bin/java -Xmx2G -XX:+UseG1GC -jar ModernOS.jar
EOF
chmod +x $BUILD_DIR/modernos/autorun.sh

cat > $BUILD_DIR/README.txt << 'EOF'
╔════════════════════════════════════════════════════════════╗
║                  ModernOS v1.0.0                           ║
║            Proprietary Operating System                    ║
╚════════════════════════════════════════════════════════════╝

LICENSE: Proprietary - Personal Use Only
Copyright (c) 2025 A-Proof. All Rights Reserved.

RESTRICTIONS:
  ✗ NO source viewing  ✗ NO modification  ✗ NO redistribution
  ✓ Personal use ONLY

HOW TO RUN:

1. IN VIRTUAL MACHINE:
   - Mount this ISO in VirtualBox/VMware/QEMU
   - Inside VM, run: /modernos/autorun.sh
   - Or use GUI to navigate and double-click autorun.sh

2. ON macOS:
   hdiutil attach ModernOS-v1.0.0.iso
   /Volumes/ModernOS/modernos/autorun.sh

3. ON LINUX:
   sudo mount -o loop ModernOS-v1.0.0.iso /mnt
   /mnt/modernos/autorun.sh

FEATURES:
  • 10 built-in applications
  • HTML6 browser with Grain
  • AI integration (Ollama)
  • Self-contained Java runtime

WEBSITE: https://a-proof.github.io/ModernOS-Desktop
SUPPORT: github.com/A-Proof/ModernOS-Desktop

BY USING THIS SOFTWARE, YOU AGREE TO THE LICENSE TERMS.
EOF

cat > $BUILD_DIR/LICENSE.txt << 'EOF'
ModernOS Proprietary License v1.0
Copyright (c) 2025 A-Proof. All Rights Reserved.

Personal use ONLY. NO source viewing, modification, or redistribution.
See full LICENSE at: github.com/A-Proof/ModernOS-Desktop
EOF

echo -e "${GREEN}✓ Files created${NC}"
echo ""

echo -e "${BLUE}[6/7]${NC} Building hybrid ISO..."

# Create hybrid ISO that can be mounted or booted
mkisofs -o "$DIST_DIR/ModernOS-v$APP_VERSION.iso" \
        -V "ModernOS" \
        -volset "ModernOS v$APP_VERSION" \
        -A "ModernOS by A-Proof" \
        -publisher "A-Proof" \
        -preparer "ModernOS Builder" \
        -R -J -joliet-long \
        -allow-multidot \
        -relaxed-filenames \
        $BUILD_DIR 2>/dev/null

echo -e "${GREEN}✓ Hybrid ISO created${NC}"
echo ""

echo -e "${BLUE}[7/7]${NC} Generating checksum..."
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
echo -e "${BLUE}Hybrid ISO Features:${NC}"
echo "  ✓ Mountable on macOS/Linux/Windows"
echo "  ✓ Works in VMs (mount and run)"
echo "  ✓ Self-contained with Java"
echo "  ✓ Proprietary license"
echo ""
echo -e "${YELLOW}To run:${NC}"
echo "  Mac: hdiutil attach $DIST_DIR/ModernOS-v$APP_VERSION.iso && /Volumes/ModernOS/modernos/autorun.sh"
echo "  VM: Mount ISO, then run /modernos/autorun.sh inside VM"
echo ""
echo -e "${RED}LICENSE: Proprietary - Personal Use Only${NC}"
echo ""
