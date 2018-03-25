#!/bin/bash

# print
# args: <string> optional: <plugin>
function print()
{
    if [ "$2" != "plugin" ]; then
        echo "🔹 $(tput bold)$1$(tput sgr0)"
    else
        echo "    ➕ $(tput bold)$1$(tput sgr0)"
    fi
}
mkdir -p "Collection/Tools"

echo -e "\n# Collect ACPI Component Architecture"
mkdir -p "Collection/Tools/ACPICA/Misc"
#
print "ACPICA"
cp -R "ACPICA/generate/unix/bin/" "Collection/Tools/ACPICA/Misc/"
mv "Collection/Tools/ACPICA/Misc/iasl" "Collection/Tools/ACPICA/"
cp -R "ACPICA/documents/aslcompiler.pdf" "Collection/Tools/ACPICA/"
#
echo -e "\n# Collect denskop forks"
mkdir -p "Collection/Tools/"
cp -R "Universal IFR Extractor/Qt/Universal IFR Extractor.app" "Collection/Tools/"

echo -e "\n# Collect Kozlek kexts"
mkdir -p "Collection/FakeSMC"
#
print "HWSensors"
rm -f -R "Collection/FakeSMC/HWMonitor.app" # To avoid framework overwrite problems
cp -R "HWSensors/Binaries/" "Collection/FakeSMC/"
rm -f -R "Collection/FakeSMC/org.hwsensors.HWMonitorHelper" # This is part of HWMonitor.app

echo -e "\n# Collect LongSoft tools"
mkdir -p "Collection/Tools/UEFITool"
#
print "UEFITool"
cp -R "UEFITool/UEFITool.app" "Collection/Tools/UEFITool/UEFITool.app"
#
print "UEFITool(NE)"
cp -R "UEFITool(NE)/UEFITool/UEFITool.app" "Collection/Tools/UEFITool/UEFITool(NE).app"

echo -e "\n# Collect Mieze kexts"
mkdir -p "Collection/LAN"
#
print "AtherosE2200Ethernet"
cp -R "AtherosE2200Ethernet/build/Release/AtherosE2200Ethernet.kext" "Collection/LAN/"
#
print "IntelMausiEthernet"
cp -R "IntelMausiEthernet/build/Release/IntelMausiEthernet.kext" "Collection/LAN/"
#
print "Realtek RTL8100"
cp -R "Realtek RTL8100/build/Release/RealtekRTL8100.kext" "Collection/LAN/"
#
print "Realtek RTL8111"
cp -R "Realtek RTL8111/build/Release/RealtekRTL8111.kext" "Collection/LAN/"

echo -e "\n# Collect RehabMan kexts and tools"
mkdir -p "Collection/Laptop"
mkdir -p "Collection/Laptop/VoodooPS2"
mkdir -p "Collection/Debug"
mkdir -p "Collection/FakePCIID"
mkdir -p "Collection/Sound"
mkdir -p "Collection/Bluetooth"
mkdir -p "Collection/Bluetooth/BrcmPatchRAM"
mkdir -p "Collection/USB/USBInjectAll"
#
print "EAPD Codec Commander"
cp -R "EAPD Codec Commander/build/Products/Release/CodecCommander.kext" "Collection/Sound/"
#
print "ACPI Battery Driver"
cp -R "ACPI Battery Driver/build/Products/Release/ACPIBatteryManager.kext" "Collection/Laptop/"
#
print "ACPI Debug"
cp -R "ACPI Debug/build/Products/Release/ACPIDebug.kext" "Collection/Debug/"
#
print "ACPI Keyboard"
cp -R "ACPI Keyboard/build/Products/Release/ACPIKeyboard.kext" "Collection/Laptop/"
#
print "BrcmPatchRAM"
cp -R "BrcmPatchRAM/build/Products/Release/" "Collection/Bluetooth/BrcmPatchRAM/"
#
print "FakePCIID"
cp -R "FakePCIID/build/Release/" "Collection/FakePCIID/"
#
print "MaciASL"
cp -R "MaciASL/build/Release/MaciASL.app" "Collection/Tools/"
#
print "USBInjectAll"
cp -R "USBInjectAll/build/Products/Release/USBInjectAll.kext" "Collection/USB/USBInjectAll/"
cp -R "USBInjectAll/config_patches.plist" "Collection/USB/USBInjectAll/"
cp -R "USBInjectAll/SSDT-UIAC-ALL.dsl" "Collection/USB/USBInjectAll/"
#
print "VoodooPS2"
cp -R "VoodooPS2/build/Products/Release/VoodooPS2Controller.kext" "Collection/Laptop/VoodooPS2/"
cp -R "VoodooPS2/build/Products/Release/VoodooPS2Daemon" "Collection/Laptop/VoodooPS2/"
cp -R "VoodooPS2/build/Products/Release/VoodooPS2synapticsPane.prefPane" "Collection/Laptop/VoodooPS2/"
cp -R "VoodooPS2/build/Products/Release/synapticsconfigload" "Collection/Laptop/VoodooPS2/"

echo -e "\n# Collect Slice kexts"
mkdir -p "Collection/Sound/VoodooHDA"
#
print "VoodooHDA"
cp -R "VoodooHDA/tranc/build/Release/VoodooHDA.kext" "Collection/Sound/VoodooHDA"
cp -R "VoodooHDA/VoodooHdaSettingsLoader/src/build/Release/VoodooHdaSettingsLoader.app" "Collection/Sound/VoodooHDA"

echo -e "\n# Collect vit9696 kexts and plugins"
mkdir -p "Collection/Lilu+Plugins"
#
print "AirportBrcmFixup"
cp -R "AirportBrcmFixup/build/Release/AirportBrcmFixup.kext" "Collection/Lilu+Plugins"
#
print "AppleALC"
cp -R "AppleALC/build/Release/AppleALC.kext" "Collection/Lilu+Plugins"
#
print "ATH9KFixup"
cp -R "ATH9KFixup/build/Release/ATH9KFixup.kext" "Collection/Lilu+Plugins"
#
print "AzulPatcher4600"
cp -R "AzulPatcher4600/build/Release/AzulPatcher4600.kext" "Collection/Lilu+Plugins"
#
print "BT4LEContiunityFixup"
cp -R "BT4LEContiunityFixup/build/Release/BT4LEContiunityFixup.kext" "Collection/Lilu+Plugins"
#
print "CoreDisplayFixup"
cp -R "CoreDisplayFixup/build/Release/CoreDisplayFixup.kext" "Collection/Lilu+Plugins"
#
print "CPUFriend"
cp -R "CPUFriend/build/Release/CPUFriend.kext" "Collection/Lilu+Plugins"
#
print "EnableLidWake"
cp -R "EnableLidWake/build/Release/EnableLidWake.kext" "Collection/Lilu+Plugins"
#
print "HibernationFixup"
cp -R "HibernationFixup/build/Release/HibernationFixup.kext" "Collection/Lilu+Plugins"
#
print "IntelGraphicsDVMTFixup"
cp -R "IntelGraphicsDVMTFixup/build/Release/IntelGraphicsDVMTFixup.kext" "Collection/Lilu+Plugins"
#
print "IntelGraphicsFixup"
cp -R "IntelGraphicsFixup/build/Release/IntelGraphicsFixup.kext" "Collection/Lilu+Plugins"
#
print "Lilu"
cp -R "Lilu/build/Release/Lilu.kext" "Collection/Lilu+Plugins"
#
print "NightShiftUnlocker"
cp -R "NightShiftUnlocker/build/Release/NightShiftUnlocker.kext" "Collection/Lilu+Plugins"
#
print "NvidiaGraphicsFixup"
cp -R "NvidiaGraphicsFixup/build/Release/NvidiaGraphicsFixup.kext" "Collection/Lilu+Plugins"
#
print "Shiki"
cp -R "Shiki/build/Release/Shiki.kext" "Collection/Lilu+Plugins"
#
print "WhateverGreen"
cp -R "WhateverGreen/build/Release/WhateverGreen.kext" "Collection/Lilu+Plugins"

echo -e "\n# Collect alexandred kexts"
mkdir -p "Collection/Laptop/VoodooI2C"
mkdir -p "Collection/Laptop/VoodooI2C/ACPI Patches"
#
print "VoodooI2C"
cp -R "VoodooI2C/VoodooI2C/build/Release/VoodooI2C.kext" "Collection/Laptop/VoodooI2C"
#
print "VoodooI2CELAN"
cp -R "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN/build/Release/VoodooI2CELAN.kext" "Collection/Laptop/VoodooI2C"
#
print "VoodooI2CHID"
cp -R "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID/build/Release/VoodooI2CHID.kext" "Collection/Laptop/VoodooI2C"
#
print "VoodooI2CSynaptics"
cp -R "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics/build/Release/VoodooI2CSynaptics.kext" "Collection/Laptop/VoodooI2C"
#
print "VoodooI2CUPDDEngine"
cp -R "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine/build/Release/VoodooI2CUPDDEngine.kext" "Collection/Laptop/VoodooI2C"
#
print "VoodooI2C ACPI Patches"
cp -R "VoodooI2C/VoodooI2C ACPI Patches/Controllers" "Collection/Laptop/VoodooI2C/ACPI Patches/"
cp -R "VoodooI2C/VoodooI2C ACPI Patches/GPIO" "Collection/Laptop/VoodooI2C/ACPI Patches/"
cp -R "VoodooI2C/VoodooI2C ACPI Patches/Windows" "Collection/Laptop/VoodooI2C/ACPI Patches/"

echo -e "\n# Collect Piker-Alpha kexts and tools"
mkdir -p "Collection/Debug"
#
print "AppleIntelInfo"
cp -R "AppleIntelInfo/build/Release/AppleIntelInfo.kext" "Collection/Debug"
#
print "ssdtPRGen"
cp -R "ssdtPRGen/ssdtPRGen.sh" "Collection/Tools/"

echo -e "\n# Collect UEFI projects"
mkdir -p "Collection/UEFI/Drivers"
mkdir -p "Collection/UEFI/BOOT"
mkdir -p "Collection/UEFI/Debug"
#
print "AptioMemoryFix"
cp "edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/AptioMemoryFix.efi" "Collection/UEFI/Drivers/AptioMemoryFix-64.efi"
#
print "AptioInputFix"
cp "edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/AptioInputFix.efi" "Collection/UEFI/Drivers/AptioInputFix-64.efi"

print "Clover EFI Bootloader"
# bootloader
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/CLOVER.efi" "Collection/UEFI/BOOT/BOOTX64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/CLOVER.efi" "Collection/UEFI/CLOVERX64.efi"

# drivers
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/DataHubDxe.efi" "Collection/UEFI/Drivers/DataHubDxe-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/AppleImageCodec.efi" "Collection/UEFI/Drivers/AppleImageCodec-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/AppleKeyAggregator.efi" "Collection/UEFI/Drivers/AppleKeyAggregator-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/AppleUITheme.efi" "Collection/UEFI/Drivers/AppleUITheme-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/EmuVariableUefi.efi" "Collection/UEFI/Drivers/EmuVariableUefi-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/Fat.efi" "Collection/UEFI/Drivers/Fat-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/FirmwareVolume.efi" "Collection/UEFI/Drivers/FirmwareVolume-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/FSInject.efi" "Collection/UEFI/Drivers/FSInject-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/OsxAptioFix2Drv.efi" "Collection/UEFI/Drivers/OsxAptioFix2Drv-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/OsxAptioFix3Drv.efi" "Collection/UEFI/Drivers/OsxAptioFix3Drv-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/OsxAptioFixDrv.efi" "Collection/UEFI/Drivers/OsxAptioFixDrv-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/OsxFatBinaryDrv.efi" "Collection/UEFI/Drivers/OsxFatBinaryDrv-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/OsxLowMemFixDrv.efi" "Collection/UEFI/Drivers/OsxLowMemFixDrv-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/PartitionDxe.efi" "Collection/UEFI/Drivers/PartitionDxe-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/SMCHelper.efi" "Collection/UEFI/Drivers/SMCHelper-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/VBoxHfs.efi" "Collection/UEFI/Drivers/VBoxHfs-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/CsmVideoDxe.efi" "Collection/UEFI/Drivers/CsmVideoDxe-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/UsbKbDxe.efi" "Collection/UEFI/Drivers/UsbKbDxe-64.efi"
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/UsbMouseDxe.efi" "Collection/UEFI/Drivers/UsbMouseDxe-64.efi"

# additinal drivers
cp "edk2/Build/Clover/RELEASE_XCODE5/X64/DumpUefiCalls.efi" "Collection/UEFI/Debug/DumpUefiCalls-64.efi"
