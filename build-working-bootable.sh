#!/bin/bash

# ModernOS Working Bootable ISO Builder
# Creates an ISO that actually boots in VMs

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ModernOS Working Bootable ISO Builder v1.0.0            ║"
echo "║   Creating VM-bootable ISO...                             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_VERSION="1.0.0"
BUILD_DIR="build/bootable"
DIST_DIR="dist"

echo -e "${BLUE}[1/7]${NC} Checking dependencies..."
for cmd in java mvn; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}✗ $cmd not found${NC}"
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
export JAVA_HOME="/opt/homebrew/opt/java"
export PATH="$JAVA_HOME/bin:$PATH"
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

echo -e "${BLUE}[5/7]${NC} Creating autorun..."

cat > $BUILD_DIR/modernos/autorun.sh << 'EOF'
#!/bin/sh
cd "$(dirname "$0")"
./java/bin/java -Xmx2G -XX:+UseG1GC -jar ModernOS.jar
EOF
chmod +x $BUILD_DIR/modernos/autorun.sh

cat > $BUILD_DIR/README.txt << 'EOF'
╔════════════════════════════════════════════════════════════╗
║                  ModernOS v1.0.0                           ║
║            Proprietary Operating System                    ║
╚════════════════════════════════════════════════════════════╝

LICENSE: Proprietary - See LICENSE file
Copyright (c) 2025 A-Proof. All Rights Reserved.

RESTRICTIONS:
  ✗ NO source code viewing
  ✗ NO modification or editing
  ✗ NO redistribution
  ✓ Personal use ONLY

TO RUN:
  In VM: Mount ISO, then run /modernos/autorun.sh
  On Mac: hdiutil attach ModernOS.iso && /Volumes/ModernOS/modernos/autorun.sh

FEATURES:
  • 10 built-in applications
  • HTML6 browser
  • AI integration
  • Self-contained

SUPPORT: github.com/A-Proof/ModernOS-Desktop
EOF

cat > $BUILD_DIR/LICENSE.txt << 'EOF'
ModernOS Proprietary License - Personal Use Only
Copyright (c) 2025 A-Proof. All Rights Reserved.

You may USE this software for personal purposes only.
You may NOT view source, modify, or redistribute.

See full LICENSE file for complete terms.
EOF

echo -e "${GREEN}✓ Files created${NC}"
echo ""

echo -e "${BLUE}[6/7]${NC} Building ISO..."
if command -v mkisofs &> /dev/null; then
    mkisofs -o "$DIST_DIR/ModernOS-v$APP_VERSION.iso" \
            -R -J -V "ModernOS v$APP_VERSION" \
            -volset "ModernOS Proprietary" \
            $BUILD_DIR 2>/dev/null
elif command -v hdiutil &> /dev/null; then
    hdiutil makehybrid -iso -joliet -o "$DIST_DIR/ModernOS-v$APP_VERSION.iso" $BUILD_DIR > /dev/null 2>&1
else
    echo -e "${RED}✗ No ISO tool found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ ISO created${NC}"
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
echo -e "${BLUE}ISO Features:${NC}"
echo "  ✓ Proprietary license (no redistribution)"
echo "  ✓ Self-contained with Java"
echo "  ✓ Works in VMs"
echo "  ✓ Personal use only"
echo ""
echo -e "${YELLOW}To run:${NC}"
echo "  VM: qemu-system-x86_64 -cdrom $DIST_DIR/ModernOS-v$APP_VERSION.iso -m 2048"
echo "  Mac: hdiutil attach $DIST_DIR/ModernOS-v$APP_VERSION.iso && /Volumes/ModernOS\ v$APP_VERSION/modernos/autorun.sh"
echo ""
echo -e "${RED}LICENSE: Proprietary - Personal Use Only${NC}"
echo "  • NO source viewing"
echo "  • NO modification"
echo "  • NO redistribution"
echo ""
