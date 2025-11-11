# 🧠 **ModernOS**  
*A next-generation experimental operating system built for speed, clarity, and modular design.*

---

## 🧩 **What it is**
ModernOS is a closed source operating system made with tools such as **IDEs**, **QEMU**, and **Make**.  
We also use **C++**, **Rust**, **C**, and **Assembly**. These scripting languages are corely needed for many operations.

---

## 🚀 **Official Releases**

### 🧱 Beta Versions
- **ModernOS Seed (v0.0.1)** — Was never released but final testing was on **November 4th**.  
- **ModernOS Alpha (v0.2.0)** — Released in **Early November** but really basic. *(Released November 7th, public testing.)*  
- **ModernOS Beta (v0.3.0)** — Released in **Later November** *(around the 8th, public testing.)*  
- **ModernOS New-UI (v0.4.0)** — Released on **November 10th** with new UI but really errored and unsimple. *Public testing allowed!*

### 🧭 Public, Real Versions
> **ModernOS (v1.0.0)** — *Releasing soon, no name yet!*

---

## 💽 **Running The OS**

### 🧰 QEMU Virtual Machines
For versions **0.2.0 – 0.4.0**  
```bash
qemu-system-x86_64 -cdrom ModernOS.iso -boot d -m 1024 -vga std
```

For versions **0.5.0+**  
```bash
qemu-system-x86_64 -cdrom ModernOS.iso -boot d -m 1024 -vga virtio -device e1000 -soundhw ac97
```

---

### 💻 Running on Hardware

If you are on a **Windows Computer, MacBook with Apple Silicon, or any Qualcomm PC**, you are **ARM64**.  
If you are on **anything else**, you are **x86_64**.

---

#### ⚙️ **ARM_64 Real Hardware**

1. Connect a **USB drive** to your PC/Laptop.  
2. Run:  
   ```bash
   sudo dd if=ModernOS.iso of=/dev/diskN bs=4M status=progress
   sync
   ```
   Replace **/dev/diskN** with your USB system file disk name.  
3. Insert the **SD/USB** card in the ARM board.  
   **Good news:** You can plug it into a port!  
4. Power it on.  

If the board supports **UEFI** (Raspberry Pi 4+ does), it should boot directly.  
Otherwise, you’ll need a small ARM bootloader like **U-Boot** to load the kernel.  

Only download ***ARM_64*** releases on these.  
*(Beta versions are x86_64.)*

If **on Mac**, good news again!  
After plugging it in, instead of doing BIOS and everything, go to:  
> **Settings → General → Startup Settings**  

If your computer recognizes it, just click on it and **boot it!**  
It may have instructions though.

---

#### ⚙️ **x86_64 Real Hardware**

1. Connect a **USB drive** to your PC/Laptop.  
2. Run:  
   ```bash
   sudo dd if=ModernOS.iso of=/dev/diskN bs=4M status=progress
   sync
   ```
   Replace **/dev/diskN** with your USB system file disk name.  
3. Plug the USB into your computer.  
   *Adapters and USB Hubs do work!*  

If on **Intel Mac**, type:  
```bash
sudo bless --mount /Volumes/ModernOS --setBoot --nextonly
sudo shutdown -r now
```

If on **Linux**, type:  
```bash
sudo grub-reboot "hd1,gpt1"
sudo reboot
```
*(Assuming your USB disk name is `hd1`, otherwise change it to your USB disk’s name.)*

If you are on a **Windows/Microsoft Computer without Qualcomm**, it’s a bit easier to boot it:  
```bash
sudo grub-reboot "hd1,gpt1"
sudo reboot
```

And now the **OS is installed!**

---

## 🧠 **Code**

**RK.rubyKit** is a Python library to code apps.  
It is not fully working however.  

In older versions *(0.3 & 0.4)*, **TinkerCode** had a programming language called `.wallpaper(s)`.  
However, they didn’t work and are removed.

---

## 🤖 **AI Integration**

- Assistant models made from scratch will be available in the **Full Release**.  
- GPT models will also be included as alternatives, *if we get permission.*

---

## ⚠️ **License**

ModernOS is a **closed-source project**.  
Binaries may be freely downloaded and tested, but redistribution or reverse engineering of the kernel is prohibited.  

© **2025 ModernOS Development Team. All rights reserved.**
