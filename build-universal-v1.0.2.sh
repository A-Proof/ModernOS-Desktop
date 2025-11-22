#!/bin/bash

# ModernOS Universal ISO v1.0.2
# Works on both ARM and x86_64 Macs

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ModernOS Universal ISO Builder v1.0.2                   ║"
echo "║   Works on ARM and x86_64 Macs                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_VERSION="1.0.2"
BUILD_DIR="build/universal"
DIST_DIR="dist"

echo -e "${BLUE}[1/5]${NC} Building ModernOS..."
export JAVA_HOME="/opt/homebrew/opt/java"
export PATH="$JAVA_HOME/bin:$PATH"
[ -f "generate_vector_icons.py" ] && python3 generate_vector_icons.py > /dev/null 2>&1
mvn clean package -DskipTests -q
echo -e "${GREEN}✓ Built${NC}"
echo ""

echo -e "${BLUE}[2/5]${NC} Creating structure..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/modernos $DIST_DIR
cp target/modern-os-1.0.0.jar $BUILD_DIR/modernos/ModernOS.jar
echo -e "${GREEN}✓ Structure created${NC}"
echo ""

echo -e "${BLUE}[3/5]${NC} Creating smart launcher..."

# Smart launcher that uses system Java
cat > $BUILD_DIR/modernos/run.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"

# Find Java
if [ -n "$JAVA_HOME" ]; then
    JAVA="$JAVA_HOME/bin/java"
elif command -v java &> /dev/null; then
    JAVA="java"
elif [ -f "/opt/homebrew/opt/java/bin/java" ]; then
    JAVA="/opt/homebrew/opt/java/bin/java"
elif [ -f "/usr/local/opt/java/bin/java" ]; then
    JAVA="/usr/local/opt/java/bin/java"
elif [ -f "/usr/bin/java" ]; then
    JAVA="/usr/bin/java"
else
    echo "ERROR: Java not found!"
    echo ""
    echo "Please install Java:"
    echo "  macOS: brew install openjdk"
    echo "  Linux: sudo apt install openjdk-17-jre"
    echo ""
    exit 1
fi

echo "Starting ModernOS..."
echo "Using Java: $JAVA"
exec "$JAVA" -Xmx2G -XX:+UseG1GC -jar ModernOS.jar
EOF
chmod +x $BUILD_DIR/modernos/run.sh

# Mac launcher
cat > $BUILD_DIR/modernos/ModernOS.command << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
exec ./run.sh
EOF
chmod +x $BUILD_DIR/modernos/ModernOS.command

# README
cat > $BUILD_DIR/README.txt << 'EOF'
╔════════════════════════════════════════════════════════════╗
║                  ModernOS v1.0.2                           ║
║              Universal Operating System                    ║
╚════════════════════════════════════════════════════════════╝

LICENSE: Proprietary - Personal Use Only
Copyright (c) 2025 A-Proof. All Rights Reserved.

REQUIREMENTS:
  • Java 17+ (install if needed)
  • 2GB RAM minimum

INSTALLATION:

1. INSTALL JAVA (if not installed):
   
   macOS:
     brew install openjdk
   
   Linux:
     sudo apt install openjdk-17-jre
   
   Windows:
     Download from: https://adoptium.net/

2. MOUNT THE ISO:
   
   macOS:
     hdiutil attach ModernOS-v1.0.2.iso
   
   Linux:
     sudo mount -o loop ModernOS-v1.0.2.iso /mnt

3. RUN MODERNOS:
   
   macOS:
     /Volumes/ModernOS/modernos/ModernOS.command
     (or double-click in Finder)
   
   Linux:
     /mnt/modernos/run.sh

FEATURES:
  • Works on ARM and x86_64
  • 10 built-in applications
  • HTML6 browser with Grain
  • AI integration (Ollama)
  • Uses system Java (no bundling)

WHY NO BUNDLED JAVA?
  To support both ARM and x86_64 Macs, we use your system's Java.
  This is smaller and works on any architecture!

WEBSITE: https://a-proof.github.io/ModernOS-Desktop
SUPPORT: github.com/A-Proof/ModernOS-Desktop

RESTRICTIONS:
  ✗ NO source viewing  ✗ NO modification  ✗ NO redistribution
  ✓ Personal use ONLY
EOF

# Quick start
cat > $BUILD_DIR/QUICKSTART.txt << 'EOF'
QUICKSTART:

1. Install Java: brew install openjdk (macOS)
2. Mount ISO: hdiutil attach ModernOS-v1.0.2.iso
3. Run: /Volumes/ModernOS/modernos/ModernOS.command

That's it!
EOF

echo -e "${GREEN}✓ Launcher created${NC}"
echo ""

echo -e "${BLUE}[4/5]${NC} Building ISO..."
if command -v mkisofs &> /dev/null; then
    mkisofs -o "$DIST_DIR/ModernOS-v$APP_VERSION.iso" \
            -V "ModernOS" \
            -volset "ModernOS v$APP_VERSION" \
            -R -J -joliet-long \
            $BUILD_DIR 2>/dev/null
elif command -v hdiutil &> /dev/null; then
    hdiutil makehybrid -iso -joliet \
            -o "$DIST_DIR/ModernOS-v$APP_VERSION.iso" \
            $BUILD_DIR > /dev/null 2>&1
fi
echo -e "${GREEN}✓ ISO created${NC}"
echo ""

echo -e "${BLUE}[5/5]${NC} Generating checksum..."
cd $DIST_DIR
shasum -a 256 "ModernOS-v$APP_VERSION.iso" > "ModernOS-v$APP_VERSION.iso.sha256"
cd ..
echo -e "${GREEN}✓ Checksum generated${NC}"
echo ""

echo "╔════════════════════════════════════════════════════════════╗"
echo "║              BUILD COMPLETE! 🎉                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}Build artifacts:${NC}"
ls -lh $DIST_DIR/ModernOS-v$APP_VERSION.*
echo ""
echo -e "${BLUE}Universal ISO Features:${NC}"
echo "  ✓ Works on ARM Macs (M1/M2/M3)"
echo "  ✓ Works on Intel Macs"
echo "  ✓ Uses system Java (smaller size)"
echo "  ✓ Auto-detects Java location"
echo "  ✓ Much smaller (~50MB vs 324MB)"
echo ""
echo -e "${YELLOW}To test on your ARM Mac:${NC}"
echo "  hdiutil attach $DIST_DIR/ModernOS-v$APP_VERSION.iso"
echo "  /Volumes/ModernOS/modernos/ModernOS.command"
echo ""
echo -e "${YELLOW}To publish:${NC}"
echo "  gh release create v$APP_VERSION \\"
echo "    $DIST_DIR/ModernOS-v$APP_VERSION.iso \\"
echo "    $DIST_DIR/ModernOS-v$APP_VERSION.iso.sha256 \\"
echo "    --title \"ModernOS v$APP_VERSION - Universal\" \\"
echo "    --notes \"Works on ARM and x86_64 Macs. Requires Java 17+.\""
echo ""
