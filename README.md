## System requirements
- macOS
- Command Line Tools
- Xcode (optional)
- Qt (optional)

## How to use it
    git clone https://github.com/denskop/KextAndToolScripts.git
    cd KextAndToolScripts
    ./clone.sh
    ./build.sh
    ./collect.sh

## List of supported kexts and tools

### 1. ACPI Component Architecture

- ACPICA: iasl

### 2. EDK2 based projects
- AptioFixPkg
- CupertinoModulePkg, EfiMiscPkg, EfiPkg
- Clover EFI Bootloader

### 3. LongSoft tools
- UEFITool
- UEFITool (New Engine)

### 4. alexandred kexts
- VoodooI2C
with plugins: VoodooI2CELAN, VoodooI2CHID, VoodooI2CSynaptics, VoodooI2CUPDDEngine

### 5. Kozlek kexts and plugins
- HWSensors: FakeSMC.kext
with plugins: ACPISensors, CPUSensors,  GPUSensors, LPCSensors

### 6. Mieze kexts
- AtherosE2200Ethernet
- IntelMausiEthernet
- Realtek RTL8100
- Realtek RTL8111

### 7. Piker-Alpha kexts and tools
- AppleIntelInfo
- ssdtPRGen.sh

### 8. RehabMan kexts and forks
- EAPD Codec Commander
- OSX ACPI Battery Driver
- OSX ACPI Debug
- OSX ACPI Keyboard
- OSX BrcmPatchRAM
- OSX FakePCIID
- OSX MaciASL

### 9. Slice kexts
- VoodooHDA

### 10. vit9696 kexts and plugins
- AirportBrcmFixup
- AppleALC
- ATH9KFixup
- AzulPatcher4600
- BT4LEContiunityFixup
- CoreDisplayFixup
- CPUFriend
- EnableLidWake
- HibernationFixup
- IntelGraphicsFixup
- Lilu
- NvidiaGraphicsFixup
- Shiki
- WhateverGreen
