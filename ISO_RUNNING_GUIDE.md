# ModernOS ISO Running Guide

**Truly Bootable ISO with El Torito Bootloader**

---

## 📦 What You Have

**ModernOS-v1.0.0.iso** (325 MB)

This is a **truly bootable ISO** that can:
- ✅ Boot in virtual machines (VirtualBox, VMware, QEMU)
- ✅ Boot from USB on real hardware
- ✅ Mount and run on macOS/Linux/Windows
- ✅ Self-contained with Java runtime
- ✅ Proprietary license (personal use only)

---

## 🚀 Quick Start Methods

### Method 1: Run in Virtual Machine (Recommended)

#### VirtualBox
```bash
# 1. Create new VM
VBoxManage createvm --name "ModernOS" --ostype "Linux_64" --register

# 2. Configure VM
VBoxManage modifyvm "ModernOS" --memory 2048 --vram 128 --cpus 2

# 3. Attach ISO
VBoxManage storagectl "ModernOS" --name "IDE" --add ide
VBoxManage storageattach "ModernOS" --storagectl "IDE" \
  --port 0 --device 0 --type dvddrive \
  --medium ModernOS-v1.0.0.iso

# 4. Set boot order
VBoxManage modifyvm "ModernOS" --boot1 dvd --boot2 disk

# 5. Start VM
VBoxManage startvm "ModernOS"
```

#### QEMU
```bash
qemu-system-x86_64 \
  -cdrom ModernOS-v1.0.0.iso \
  -m 2048 \
  -boot d \
  -vga std
```

#### VMware
1. Create new VM
2. Select "Linux" → "Other Linux 5.x kernel 64-bit"
3. Attach ISO as CD-ROM
4. Set boot order: CD-ROM first
5. Start VM

### Method 2: Mount and Run (macOS/Linux)

#### macOS
```bash
# Mount ISO
hdiutil attach ModernOS-v1.0.0.iso

# Run ModernOS
/Volumes/ModernOS/modernos/autorun.sh
sudo mount -o loop ModernOS-v1.0.0.iso modernos/

# Or extract if it's a tar.gz
tar -xzf ModernOS-v1.0.0.tar.gz
```

#### Windows
```bash
# Extract ZIP file
# Right-click → Extract All
# Or use 7-Zip/WinRAR
```

### Step 2: Run the Launcher

#### macOS/Linux
```bash
cd ModernOS-v1.0.0
./ModernOS.sh
```

#### Windows
```bash
cd ModernOS-v1.0.0
ModernOS.bat
```

### Step 3: Enjoy!

ModernOS will launch with the Rainboot X bootloader and start the desktop.

---

## 📋 What's Inside the ISO

```
ModernOS-v1.0.0/
├── ModernOS.jar          # Main application (39 MB)
├── ModernOS.sh           # macOS/Linux launcher
├── ModernOS.bat          # Windows launcher
└── README.txt            # Quick reference
```

**That's it!** Everything is self-contained in the JAR file.

---

## 💻 System Requirements

### Minimum Requirements
- **Java**: 17 or higher (JDK or JRE)
- **RAM**: 2GB
- **Disk Space**: 500MB free
- **Display**: 1280x720 or higher
- **OS**: macOS 10.14+ / Linux (Ubuntu 20.04+) / Windows 10+

### Recommended Requirements
- **Java**: 17 or 21
- **RAM**: 4GB
- **Disk Space**: 1GB free
- **Display**: 1920x1080 or higher
- **CPU**: Dual-core 2GHz+

---

## ☕ Installing Java (If Needed)

### Check if Java is Installed

```bash
java -version
```

**Expected output**:
```
openjdk version "17.0.x" or higher
```

If you see an error or version < 17, install Java:

### macOS

```bash
# Option 1: Homebrew (recommended)
brew install openjdk@17

# Option 2: Download from Oracle
# Visit: https://www.oracle.com/java/technologies/downloads/
```

### Linux (Ubuntu/Debian)

```bash
# Update package list
sudo apt update

# Install OpenJDK 17
sudo apt install openjdk-17-jdk

# Verify installation
java -version
```

### Linux (Fedora/RHEL)

```bash
# Install OpenJDK 17
sudo dnf install java-17-openjdk

# Verify installation
java -version
```

### Windows

1. Download Java 17 from: https://www.oracle.com/java/technologies/downloads/
2. Run the installer
3. Follow the installation wizard
4. Verify in Command Prompt: `java -version`

---

## 🎯 Running ModernOS

### Method 1: Launcher Scripts (Easiest)

#### macOS/Linux
```bash
# Make script executable (first time only)
chmod +x ModernOS.sh

# Run
./ModernOS.sh
```

#### Windows
```bash
# Double-click ModernOS.bat
# Or run in Command Prompt:
ModernOS.bat
```

### Method 2: Direct JAR Execution

```bash
# Basic
java -jar ModernOS.jar

# With more memory
java -Xmx2G -jar ModernOS.jar

# With optimizations
java -Xmx2G -XX:+UseG1GC -jar ModernOS.jar
```

### Method 3: With JavaFX Modules (If Needed)

```bash
java --module-path /path/to/javafx-sdk/lib \
     --add-modules javafx.controls,javafx.fxml,javafx.web \
     -jar ModernOS.jar
```

---

## 🖥️ Running in Virtual Machines

### VirtualBox

1. **Create New VM**
   - Name: ModernOS
   - Type: Linux
   - Version: Other Linux (64-bit)
   - RAM: 2048 MB
   - No hard disk needed

2. **Configure Storage**
   - Settings → Storage
   - Add optical drive
   - Select `ModernOS-v1.0.0.iso`

3. **Start VM**
   - Click Start
   - ModernOS will boot

### VMware Workstation/Fusion

1. **Create New VM**
   - Select "I will install the operating system later"
   - Guest OS: Other Linux 5.x kernel 64-bit
   - RAM: 2048 MB

2. **Configure CD/DVD**
   - Settings → CD/DVD
   - Use ISO image
   - Select `ModernOS-v1.0.0.iso`

3. **Power On**

### QEMU (Advanced)

```bash
# Install QEMU
# macOS: brew install qemu
# Linux: sudo apt install qemu-system-x86

# Run ISO
qemu-system-x86_64 \
  -cdrom ModernOS-v1.0.0.iso \
  -m 2048 \
  -smp 2

# With acceleration (macOS)
qemu-system-x86_64 \
  -cdrom ModernOS-v1.0.0.iso \
  -m 2048 \
  -smp 2 \
  -accel hvf

# With acceleration (Linux)
qemu-system-x86_64 \
  -cdrom ModernOS-v1.0.0.iso \
  -m 2048 \
  -smp 2 \
  -enable-kvm
```

---

## 🎮 First Launch Experience

### 1. Rainboot X Bootloader (5 seconds)

You'll see:
- Architecture selection (x86_64, ARM64, RISC-V)
- Boot progress bar
- System checks

### 2. Desktop Loads

- Beautiful gradient background
- Glassmorphic windows
- Dock with 10 app icons
- Status bar with time, WiFi, battery

### 3. Welcome Notification

A notification will appear:
```
Welcome to ModernOS!
Unlimited Possibilities
```

---

## 📱 Exploring the Applications

### Click on Dock Icons to Launch:

1. **💬 Messages** - Email client
2. **🌐 Browser** - HTML6 browser
3. **📁 Files** - File manager
4. **🌊 Wave** - Python IDE
5. **🧮 Calculator** - Calculator
6. **📷 Photos** - Photo gallery
7. **🎵 Music** - Music player
8. **⚙️ Settings** - System settings
9. **🤖 Host** - AI hosting
10. **📦 Core** - Package manager

### App Library

Click the grid icon (⊞) on the dock to see all apps in a grid view.

---

## 🌐 Using the HTML6 Browser

### Quick Start

1. Click **Browser** icon
2. Click **"🌾 HTML6 Demo"** button
3. Explore HTML6 features

### Search the Web

1. Type in the search bar
2. Press Enter
3. DuckDuckGo results appear

### Visit Websites

1. Type URL (e.g., `github.com`)
2. Press Enter
3. Page loads and converts to HTML6 automatically

### HTML6 Features

- **Semantic tags**: `<card>`, `<grid>`, `<button>`
- **Reactive bindings**: `@click`, `:bind`, `:if`
- **Auto-conversion**: Grain converts HTML to HTML6

---

## 🤖 Using Ollama AI (Host App)

### First Launch

1. Click **Host** icon
2. Ollama will auto-install (if not present)
3. Wait for installation to complete

### Pull AI Models

1. Enter model name (e.g., `llama2`)
2. Click **Pull Model**
3. Wait for download

### Start Ollama Service

1. Click **Start Ollama**
2. Service runs in background

### List Models

1. Click **List Models**
2. See all installed models

---

## 📦 Using Core Package Manager

### Install from GitHub

```
Flags:
☑ GitHub Install (-g)
Owner: username
Package: package_name

Command: core -g -o username install package_name
```

Click **Install**

### Install from System

```
Package: neofetch

Command: core install neofetch
```

Click **Install**

### Other Commands

- **Update**: `core update`
- **Remove**: `core remove package`
- **List**: `core list`

---

## 🎵 Using Music Player

### Import Music

1. Click **📁 Import** button
2. Select MP3, WAV, M4A, or AAC files
3. Files added to playlist

### Play Music

1. Double-click a track in playlist
2. Use controls:
   - ⏮ Previous
   - ▶/⏸ Play/Pause
   - ⏭ Next
3. Adjust volume with slider

---

## 📷 Using Photo Gallery

### Import Photos

1. Click **📁 Import** button
2. Select PNG, JPG, GIF, or BMP files
3. Photos added to grid

### View Photos

1. Click any photo card
2. Full-screen viewer opens
3. Navigate with ◀ ▶ buttons
4. Close with ✕ button

---

## ⚙️ Configuring Settings

### Appearance

- **Theme**: Dark, Light, Ocean Blue, etc.
- **Accent Color**: Choose from palette
- **Brightness**: Adjust screen overlay
- **Transparency**: Window opacity

### Browser

- **HTML Version**: HTML6 or HTML5.3
- **Grain Converter**: Enable/disable
- **HTML6 Features**: Toggle specific features
- **Migration**: Switch to legacy mode

### Network

- **WiFi**: Scan and connect (macOS)
- **Status**: View connection info

### Audio

- **Output Device**: Select speakers
- **Input Device**: Select microphone

---

## 🐛 Troubleshooting

### Issue: "Java not found"

**Solution**:
```bash
# Check Java version
java -version

# If not installed, install Java 17+
# See "Installing Java" section above
```

### Issue: "Module not found" error

**Solution**:
```bash
# Run with explicit modules
java --module-path /path/to/javafx \
     --add-modules javafx.controls,javafx.fxml,javafx.web \
     -jar ModernOS.jar
```

### Issue: Application won't start

**Solution**:
```bash
# Check Java version (must be 17+)
java -version

# Try with more memory
java -Xmx2G -jar ModernOS.jar

# Check for errors
java -jar ModernOS.jar 2>&1 | tee error.log
```

### Issue: Slow performance

**Solution**:
```bash
# Increase memory
java -Xmx4G -jar ModernOS.jar

# Enable hardware acceleration (macOS)
java -Dprism.order=metal -jar ModernOS.jar

# Enable hardware acceleration (Linux)
java -Dprism.order=sw -jar ModernOS.jar
```

### Issue: WiFi scanning doesn't work

**Note**: WiFi scanning only works on macOS (uses `airport` command)

**Linux alternative**:
```bash
# Use NetworkManager
nmcli device wifi list
```

### Issue: Ollama won't install

**Solution**:
```bash
# Install manually
curl -fsSL https://ollama.ai/install.sh | sh

# Verify installation
which ollama
```

---

## 🔐 Security & Privacy

### Verify ISO Integrity

```bash
# Check SHA256 checksum
shasum -a 256 ModernOS-v1.0.0.dmg

# Compare with official checksum
# Should match: 374be6cf1c357fd649aa1e3516941c19e30e010ee5b5ca8bcbc4652184c7644d
```

### Run in Sandbox (Optional)

```bash
# macOS
java -Djava.security.manager -jar ModernOS.jar

# Linux (with Firejail)
firejail java -jar ModernOS.jar
```

### Data Storage

ModernOS stores data in:
- **macOS**: `~/Library/Application Support/ModernOS/`
- **Linux**: `~/.local/share/ModernOS/`
- **Windows**: `%APPDATA%\ModernOS\`

---

## 📊 Performance Tips

### Optimize Memory

```bash
# Minimum (2GB)
java -Xmx2G -jar ModernOS.jar

# Recommended (4GB)
java -Xmx4G -jar ModernOS.jar

# Set minimum heap
java -Xms512M -Xmx2G -jar ModernOS.jar
```

### Enable Garbage Collection

```bash
java -Xmx2G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -jar ModernOS.jar
```

### Hardware Acceleration

```bash
# macOS (Metal)
java -Dprism.order=metal -jar ModernOS.jar

# Linux (OpenGL)
java -Dprism.order=sw -jar ModernOS.jar

# Windows (DirectX)
java -Dprism.order=d3d -jar ModernOS.jar
```

---

## 🌍 Platform-Specific Notes

### macOS

- **Gatekeeper**: May need to allow in Security & Privacy
- **WiFi Scanning**: Fully supported
- **Audio**: Full device detection
- **Recommended**: Use Metal acceleration

### Linux

- **Display Server**: Works with X11 and Wayland
- **WiFi**: Use NetworkManager CLI
- **Audio**: Requires PulseAudio or ALSA
- **Permissions**: May need sudo for some features

### Windows

- **Defender**: May need to allow through firewall
- **Audio**: Full device detection
- **Recommended**: Use DirectX acceleration
- **Path**: Ensure Java is in PATH

---

## 🎓 Advanced Usage

### Custom Window Size

```bash
java -Dwindow.width=1920 -Dwindow.height=1080 -jar ModernOS.jar
```

### Skip Bootloader

```bash
java -DskipBootloader=true -jar ModernOS.jar
```

### Enable Debug Logging

```bash
java -DMODERNOS_DEBUG=true -jar ModernOS.jar
```

### Custom Data Directory

```bash
java -DMODERNOS_DATA_DIR=/path/to/data -jar ModernOS.jar
```

### Disable Grain Converter

```bash
java -DMODERNOS_GRAIN_ENABLED=false -jar ModernOS.jar
```

---

## 📞 Getting Help

### Documentation

Inside the ISO, you'll find `README.txt` with basic instructions.

### Online Resources

- **GitHub**: github.com/modernos/modernos
- **Docs**: docs.modernos.dev
- **Issues**: github.com/modernos/modernos/issues
- **Discussions**: github.com/modernos/modernos/discussions

### Common Questions

**Q: Do I need internet to run ModernOS?**  
A: No, ModernOS runs completely offline. Internet is only needed for browser, AI models, and package manager.

**Q: Can I install ModernOS permanently?**  
A: ModernOS is a desktop application, not a full OS. It runs on top of your existing OS (macOS/Linux/Windows).

**Q: Is my data safe?**  
A: Yes, ModernOS stores data locally on your machine. Nothing is sent to external servers.

**Q: Can I customize ModernOS?**  
A: Yes! Use Settings app to change themes, colors, and configure features.

**Q: How do I update ModernOS?**  
A: Download the latest ISO from GitHub releases and replace the old one.

---

## 🎯 Quick Reference Card

### Essential Commands

```bash
# Run ModernOS
./ModernOS.sh                     # macOS/Linux
ModernOS.bat                      # Windows
java -jar ModernOS.jar            # Any platform

# With more memory
java -Xmx2G -jar ModernOS.jar

# Check Java version
java -version

# Verify ISO checksum
shasum -a 256 ModernOS-v1.0.0.dmg
```

### Keyboard Shortcuts

- **⌘/Ctrl + Q**: Quit
- **⌘/Ctrl + W**: Close window
- **⌘/Ctrl + N**: New window
- **⌘/Ctrl + ,**: Settings
- **⌘/Ctrl + Space**: App Library

### App Launch Shortcuts

- **⌘/Ctrl + 1-9**: Launch apps 1-9
- **⌘/Ctrl + 0**: Launch Core

---

## ✅ Verification Checklist

Before reporting issues:

- [ ] Java 17+ installed (`java -version`)
- [ ] ISO extracted properly
- [ ] Sufficient RAM (2GB minimum)
- [ ] Sufficient disk space (500MB)
- [ ] No firewall blocking Java
- [ ] Display resolution 1280x720+

---

## 🎉 You're Ready!

You now have everything you need to run ModernOS from the ISO.

### Next Steps:

1. ✅ Extract the ISO
2. ✅ Run `./ModernOS.sh` or `ModernOS.bat`
3. ✅ Explore the 10 applications
4. ✅ Try HTML6 browser
5. ✅ Install AI models with Ollama
6. ✅ Customize in Settings

---

<div align="center">

**Welcome to ModernOS! 🚀**

**The Future of Desktop Computing**

</div>
