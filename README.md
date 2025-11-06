# 🧠 ModernOS  
*A next-generation experimental operating system built for speed, clarity, and modular design.*

---

## 🚀 Overview  
**ModernOS** is a lightweight, modular operating system designed for modern computing environments.  
It’s built from the ground up in **C** and **Assembly**, developed and tested in **Xcode**, and runs on x86_64 hardware.  

The system focuses on:
- ⚙️ **Modular kernel architecture** – inspired by microkernel design, enabling cleaner system calls and driver isolation.  
- 🖥️ **Fast framebuffer graphics** – optimized low-level drawing functions for direct screen rendering.  
- 💾 **Smart memory management** – efficient paging and segmentation for modern hardware.  
- 🔄 **Self-updating system** – checks the GitHub release page for the newest build and updates automatically.  
- 🔐 **Safe boot process** – BIOS and Multiboot-compliant, ready for UEFI expansion.

ModernOS is a research and hobby OS project, designed to demonstrate modern kernel development principles while remaining accessible for testing in emulators or real hardware.

---

## 🧩 Architecture  
| Component | Description |
|------------|--------------|
| **Kernel Core** | Developed in Xcode using C with inline Assembly. Handles multitasking, interrupts, and system calls. |
| **Memory Manager** | Physical and virtual memory allocator, implementing paging. |
| **Graphics Layer** | Framebuffer-based rendering for text and simple UI. |
| **Shell Interface** | Minimal text interface for command execution (in progress). |
| **Auto-Updater** | Fetches new versions directly from the [ModernOS GitHub Releases](https://github.com/YOUR_USERNAME/ModernOS/releases). |

*(Note: Source code is private, but the full kernel is compiled and managed in Xcode.)*

---

## 🧠 Development  
ModernOS’s kernel is fully developed within **Xcode**, leveraging its build tools for cross-compilation and inline C/Assembly editing.  
You can **view** the kernel structure in Xcode by importing the `.xcodeproj`, but **do not modify** the build setup — it’s optimized for internal debugging and release builds only.

---

## 💿 Boot Instructions  

### ▶️ 1. **Using QEMU**
```bash
qemu-system-x86_64 -cdrom ModernOS.iso -m 512M
```

### 🧰 2. **Using UTM (iPad/macOS)**
1. Open UTM.
2. Create a new VM → Choose **Boot from ISO Image**.
3. Select `ModernOS.iso`.
4. Set RAM to at least **512 MB**.
5. Start the virtual machine.

### 💻 3. **Booting on Real Hardware**
1. Flash the `ModernOS.iso` to a USB drive:
   ```bash
   sudo dd if=ModernOS.iso of=/dev/diskX bs=1m
   ```
   *(replace `/dev/diskX` with your USB device path)*  
2. Boot your PC, open the BIOS/boot menu.
3. Select the USB device.
4. ModernOS will start automatically.

---

## 🔄 Auto-Update System
ModernOS includes a built-in updater that checks the GitHub repository for new versions.  
- On boot, it compares the current build number with the latest release tag.  
- If an update is found, it automatically downloads and replaces system binaries.  
- Updates are verified and applied safely on the next reboot.

👉 Visit [ModernOS Releases](https://github.com/A-Proof/ModernOS/releases) to see current builds and changelogs.

---

## 🧱 Requirements
- CPU: x86_64-compatible processor  
- Memory: 512 MB minimum  
- Storage: 100 MB  
- BIOS or UEFI (legacy mode supported)  

---

## 🧰 Tools Used
- **Xcode** for kernel development  
- **NASM** for low-level assembly routines  
- **LD** and **objcopy** for linking and image generation  
- **QEMU / UTM** for virtualized testing  

---

## 🧩 Project Status
| Feature | Status |
|----------|--------|
| Bootloader | ✅ Stable |
| Kernel Core | ✅ Working |
| Framebuffer UI | ✅ Active |
| Shell Interface | ⚙️ In Progress |
| Network Stack | 🚧 Planned |
| Package Updater | ✅ Active |

---

## 🌐 Project Links
- **Releases:** [ModernOS GitHub Releases](https://github.com/A-Proof/ModernOS/releases)  
---

## AI Usage
On versions *forward from 2025 Dec 25* There may be a built in AI. There are no tiers yet. Srry!

# RK.rubyKit

Python library for developing apps for RubyOS (Release: December 2025 - January 2026)

## Installation

```bash
pip install RK.rubyKit
```

## Quick Start

### Creating a Box

```python
import rk

# Create a mask for UI
ui_mask = rk.mask(rk.UI)

# Create a box at coordinates
box = rk.Box.new(x=0, y=0, z=1)
```

### Using Variables, Waits and Repeats

Create a `def.py` file with your Python definitions:

```python
# def.py
def wait(seconds):
    import time
    time.sleep(seconds)

def coolFunc():
    print("Cool function!")
```

In your `.rk` file, reference these definitions:

```python
import rk

# Read wait function from def.py line 80
machine_context = rk.Machine.Know(ui_mask, 100)
rk.line("80", header="wait", time=10)

# Read function definition from line 20
rk.Machine.Know(ui_mask, 45)
rk.line("20", header="def", var1="coolFunc")
```

### String Creation

```python
# Create a text string with Arial font
text = rk.string("Arial:Text", "Hello RubyOS!")
```

## File Structure

Your RubyKit project should have:

- `def.py` - Python code definitions (waits, functions, etc.)
- `app.rk` - RubyKit commands and UI definitions
- `compile.py` - Compilation script

### Example `app.rk` File

```ruby
make_header(10)
def.py = def
-l import def as d
host(cmd:1)
host(cmd:2)
host(cmd:3)

xa:1 create as:
mask(n.UI)
box.new = coordinates(x:0, y:0, z:1)

xa:2 create as:
machine.Know(mask, 100)
line("80", header: wait, time: 10)

xa:3 create as:
string(Arial:Text, coool)

run(x1-x3)
```

### Example `compile.py` File

```python
import rk

rk_compiler = rk.RubyKit()

def compile_app(app_name):
    rk_compiler.compile_sh("def.py", app_name)
    print("Finished installing.")

compile_app("myApp")
```

Or use the shorthand:

```python
import rk
rk.compile("myApp")
```

## API Reference

### Classes

- **`RubyKit`** - Main compiler and runtime
- **`Mask`** - UI masking operations
- **`Box`** - UI box element with coordinates
- **`Machine`** - Read external code definitions
- **`String`** - Text creation and editing

### Functions

- **`mask(ui_type)`** - Create a new UI mask
- **`coordinates(x, y, z)`** - Create coordinate dictionary
- **`line(line_num, header, **kwargs)`** - Reference line from def.py
- **`string(font_text, content)`** - Create formatted text
- **`compile(app_name)`** - Compile RubyKit application

## License

MIT License

## ⚠️ License  
ModernOS is a **closed-source project**.  
Binaries may be freely downloaded and tested, but redistribution or reverse engineering of the kernel is prohibited.  

© 2025 ModernOS Development Team. All rights reserved.
