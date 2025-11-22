# ModernOS v1.0.0

<div align="center">

![ModernOS](https://img.shields.io/badge/ModernOS-v1.0.0-blue?style=for-the-badge)
![Java](https://img.shields.io/badge/Java-17+-orange?style=for-the-badge&logo=java)
![JavaFX](https://img.shields.io/badge/JavaFX-21-green?style=for-the-badge)
![HTML6](https://img.shields.io/badge/HTML6-Ready-purple?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**Next-Generation Desktop Operating System with HTML6 Support**

[Features](#features) • [Installation](#installation) • [Building](#building) • [Apps](#applications) • [HTML6](#html6-specification)

</div>

---

## 🌟 Overview

ModernOS is a revolutionary desktop operating system built with JavaFX, featuring HTML6 browser with Grain auto-converter, AI integration, and 10 production-ready applications.

## ✨ Key Features

- 🎨 **50 Professional Vector Icons** (5 sizes each, no emojis)
- 🌐 **HTML6 Browser** with 60+ semantic tags
- 🌾 **Grain Auto-Converter** (HTML → HTML6)
- 🤖 **Ollama AI Integration** (auto-install)
- 📦 **Core Package Manager** (GitHub + system packages)
- 🎵 **Music Player** with MediaPlayer
- 📷 **Photo Gallery** with viewer
- ⚙️ **Full System Settings**
- 🔔 **Notification Center**
- 🚀 **Rainboot X Bootloader**

---

## 📦 Quick Start

### Option 1: Run Pre-built

```bash
# Download and extract
wget https://github.com/modernos/releases/ModernOS-v1.0.0.zip
unzip ModernOS-v1.0.0.zip

# Run
./ModernOS.sh          # macOS/Linux
ModernOS.bat           # Windows
java -jar ModernOS.jar # Any platform
```

### Option 2: Build from Source

```bash
# Clone
git clone https://github.com/modernos/modernos.git
cd modernos

# Generate icons
python3 generate_vector_icons.py

# Build and run
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
mvn clean javafx:run
```

### Requirements

- Java 17+
- Maven 3.6+
- 2GB RAM
- 500MB disk space

---

## 🔨 Building ISO/DMG

```bash
# Make script executable
chmod +x build-iso.sh

# Build
./build-iso.sh

# Output in dist/
# - ModernOS-v1.0.0.dmg (macOS)
# - ModernOS-v1.0.0.iso (Linux)
# - ModernOS-v1.0.0.zip (Windows)
```

### ISO Build Process

The build script:
1. ✓ Checks dependencies (Java, Maven)
2. ✓ Cleans previous builds
3. ✓ Generates 50 vector icons
4. ✓ Builds JAR with Maven
5. ✓ Creates ISO structure
6. ✓ Generates launchers (sh/bat)
7. ✓ Creates bootable image
8. ✓ Generates SHA256 checksums

---

## 🚀 Applications

| App | Description | Features |
|-----|-------------|----------|
| 💬 **Messages** | Email client | IMAP/SMTP support |
| 🌐 **Browser** | HTML6 browser | Grain converter, HTML5.3 fallback |
| 📁 **Files** | File manager | System integration |
| 🌊 **Wave** | Python IDE | Syntax highlighting, execution |
| 🧮 **Calculator** | Calculator | Scientific operations |
| 📷 **Photos** | Photo gallery | Grid view, full-screen viewer, import |
| 🎵 **Music** | Music player | Playlists, MediaPlayer, import |
| ⚙️ **Settings** | System config | Appearance, Browser, Network, Audio |
| 🤖 **Host** | AI hosting | Ollama auto-install, model management |
| 📦 **Core** | Package manager | GitHub + system packages |

---

## 🌾 HTML6 Specification

### New Tags (60+)

**Layout**: `<app>`, `<view>`, `<card>`, `<grid>`, `<flex>`, `<container>`

**Components**: `<button>`, `<toggle>`, `<tabs>`, `<modal>`, `<toast>`, `<dropdown>`

**Data**: `<table>`, `<list>`, `<tree>`, `<chart>`, `<timeline>`

**Forms**: `<form>`, `<field>`, `<upload>`, `<date>`, `<time>`, `<color>`

**Advanced**: `<ai>`, `<voice>`, `<ar>`, `<vr>`, `<3d>`, `<neural>`, `<quantum>`

### Attributes

**Reactivity**: `@click`, `@input`, `:bind`, `:model`, `:class`, `:style`

**Conditionals**: `:if`, `:else`, `:show`, `:for`

**States**: `:loading`, `:error`, `:required`, `:pattern`

### Example

```html
<!DOCTYPE html6>
<html>
<body>
    <app>
        <card>
            <h1>Welcome to HTML6</h1>
            <button @click="loadData()" :loading="isLoading">
                Load Data
            </button>
        </card>
        
        <grid cols="3" gap="20">
            <card :for="item in items">
                <h3>{{ item.title }}</h3>
            </card>
        </grid>
    </app>
</body>
</html>
```

---

## 🌐 Browser Settings

**Settings → Browser** to configure:

- **HTML Version**: HTML6 / HTML5.3 (Legacy)
- **Grain Converter**: Auto-conversion toggle
- **HTML6 Features**: Reactivity, Components, AI, AR/VR
- **Migration**: Switch to HTML5.3 mode

---

## 🧪 Testing

### Run Application
```bash
mvn javafx:run
```

### Build Package
```bash
mvn clean package
```

### QEMU Testing
```bash
# Test ISO
qemu-system-x86_64 -cdrom dist/ModernOS-v1.0.0.iso -m 2048

# With acceleration (macOS)
qemu-system-x86_64 -cdrom dist/ModernOS-v1.0.0.iso -m 2048 -accel hvf
```

---

## 📁 Project Structure

```
modernos/
├── src/main/java/com/modernos/
│   ├── ModernOS.java              # Main app
│   ├── AppWindow.java             # Window manager
│   ├── NotificationCenter.java    # Notifications
│   ├── AppLibrary.java            # App launcher
│   ├── Bootloader.java            # Boot sequence
│   ├── apps/                      # Applications
│   │   ├── BrowserApp.java
│   │   ├── MusicApp.java
│   │   ├── PhotosApp.java
│   │   ├── SettingsApp.java
│   │   ├── HostApp.java
│   │   └── CoreApp.java
│   └── browser/                   # HTML6 & Grain
│       ├── HTML6Spec.java
│       └── GrainConverter.java
├── src/main/resources/
│   ├── icons/                     # 50 vector icons
│   └── styles.css
├── generate_vector_icons.py       # Icon generator
├── build-iso.sh                   # ISO builder
├── pom.xml                        # Maven config
└── README.md
```

---

## 📄 License

MIT License

---

## 🙏 Credits

- **JavaFX** - UI framework
- **Jsoup** - HTML parsing
- **Ollama** - AI integration
- **Pillow** - Icon generation

---

<div align="center">

**Made with ❤️ by the ModernOS Team**

[GitHub](https://github.com/modernos) • [Docs](https://docs.modernos.dev)

</div>
# modernos-source
