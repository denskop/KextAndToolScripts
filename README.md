## System requirements
- macOS
- Command Line Tools
- Xcode (optional)
- Qt (optional)

## Scripts description
    Bash scripts deals with supported kext and tools
    - clone.sh download source codes
    - update.sh update source codes
    - build.sh build projects from source codes
    - collect.sh collect all built projects to 'Collection' folder

## How to use it
    git clone https://github.com/denskop/KextAndToolScripts.git
    cd KextAndToolScripts
    ./clone.sh
    ./build.sh
    ./collect.sh
 
## Known issues
~~1. VoodooHDA prefpane build fails~~<br>
~~2. NightShiftUnlocker build fails with Xcode 9~~<br>
3. NightShiftUnlocker is incompatible with actual Lilu
 
## List of supported kexts and tools

### 1. ACPI Component Architecture

- [ACPICA](https://github.com/acpica/acpica): iasl

### 2. EDK2 based projects
- [ApfsSupportPkg](https://github.com/acidanthera/ApfsSupportPkg)
- [AptioFixPkg](https://github.com/vit9696/AptioFixPkg)
- [CupertinoModulePkg](https://github.com/CupertinoNet/CupertinoModulePkg), [EfiMiscPkg](https://github.com/CupertinoNet/EfiMiscPkg), [EfiPkg](https://github.com/CupertinoNet/EfiPkg)
- [Clover EFI Bootloader](https://sourceforge.net/projects/cloverefiboot)

### 3. LongSoft tools
- [UEFITool](https://github.com/LongSoft/UEFITool/tree/master)
- [UEFITool (New Engine)](https://github.com/LongSoft/UEFITool/tree/new_engine)

### 4. alexandred kexts
- [VoodooI2C](https://github.com/alexandred/VoodooI2C)
with plugins: VoodooI2CELAN, VoodooI2CHID, VoodooI2CSynaptics, VoodooI2CUPDDEngine

### 5. corpnewt forks
- [NullCPUPowerManagement](https://github.com/corpnewt/NullCPUPowerManagement)

### 6. denskop forks
- [Universal IFR Extractor](https://github.com/denskop/Universal-IFR-Extractor)
- [VoodooTSCSync](https://github.com/denskop/VoodooTSCSync)

### 7. goodwin
- [HWPEnable](https://github.com/goodwin/HWPEnable)

### 8. Kozlek kexts and plugins
- [HWSensors](https://github.com/kozlek/HWSensors): FakeSMC.kext
with plugins: ACPISensors, CPUSensors,  GPUSensors, LPCSensors

### 9. kX Project kexts
- [kXAudioDriver](https://github.com/kxproject/kx-audio-driver)

### 10. Mieze kexts
- [AtherosE2200Ethernet](https://github.com/Mieze/AtherosE2200Ethernet)
- [IntelMausiEthernet](https://github.com/Mieze/IntelMausiEthernet)
- [Realtek RTL8100](https://github.com/Mieze/RealtekRTL8100)
- [Realtek RTL8111](https://github.com/Mieze/RTL8111_driver_for_OS_X)

### 11. Piker-Alpha kexts and tools
- [AppleIntelInfo](https://github.com/Piker-Alpha/AppleIntelInfo)
- [csrstat](https://github.com/Piker-Alpha/csrstat)
- [ssdtPRGen.sh](https://github.com/Piker-Alpha/ssdtPRGen.sh)

### 12. RehabMan kexts and forks
- [EAPD Codec Commander](https://github.com/RehabMan/EAPD-Codec-Commander)
- [ACPI Battery Driver](https://github.com/RehabMan/OS-X-ACPI-Battery-Driver)
- [ACPI Debug](https://github.com/RehabMan/OS-X-ACPI-Debug)
- [ACPI Keyboard](https://github.com/RehabMan/OS-X-ACPI-Keyboard)
- [BrcmPatchRAM](https://github.com/RehabMan/OS-X-BrcmPatchRAM)
- [FakePCIID](https://github.com/RehabMan/OS-X-Fake-PCI-ID)
- [USBInjectAll](https://github.com/RehabMan/OS-X-USB-Inject-All)
- [VoodooPS2](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller)

### 13. Slice kexts
- [VoodooHDA](https://sourceforge.net/projects/voodoohda/)

### 14. acidanthera kexts and plugins
- [AirportBrcmFixup](https://github.com/lvs1974/AirportBrcmFixup)
- [AppleALC](https://github.com/vit9696/AppleALC)
- [ATH9KFixup](https://github.com/chunnann/ATH9KFixup)
- [AzulPatcher4600](https://github.com/coderobe/AzulPatcher4600)
- [BT4LEContiunityFixup](https://github.com/lvs1974/BT4LEContiunityFixup)
- [CPUFriend](https://github.com/PMheart/CPUFriend)
- [EnableLidWake](https://github.com/syscl/EnableLidWake)
- [HibernationFixup](https://github.com/lvs1974/HibernationFixup)
- [IntelGraphicsDVMTFixup](https://github.com/BarbaraPalvin/IntelGraphicsDVMTFixup)
- [Lilu](https://github.com/vit9696/Lilu)
- [MaciASL](https://github.com/RehabMan/OS-X-MaciASL-patchmatic)
- [NightShiftUnlocker](https://github.com/Austere-J/NightShiftUnlocker)
- [NoTouchID](https://github.com/al3xtjames/NoTouchID)
- [WhateverGreen](https://github.com/vit9696/WhateverGreen)

### 15. vulgo tools
- [bootoption](https://github.com/vulgo/bootoption)
