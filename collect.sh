#!/bin/bash

SELF_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_PATH="$SELF_PATH/SourceCode"
COLLECT_PATH="$SELF_PATH/Collection"

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
mkdir -p "$COLLECT_PATH/Tools"

echo -e "\n# Collect ACPI Component Architecture"
mkdir -p "$COLLECT_PATH/Tools/ACPICA/Misc"
#
print "ACPICA"
cp -R "$SOURCE_PATH/ACPICA/generate/unix/bin/" "$COLLECT_PATH/Tools/ACPICA/Misc/"
mv "$COLLECT_PATH/Tools/ACPICA/Misc/iasl" "$COLLECT_PATH/Tools/ACPICA/"
cp -R "$SOURCE_PATH/ACPICA/documents/aslcompiler.pdf" "$COLLECT_PATH/Tools/ACPICA/"
#
echo -e "\n# Collect denskop forks"
mkdir -p "$COLLECT_PATH/Tools/"
#
print "Universal IFR Extractor"
cp -R "$SOURCE_PATH/Universal IFR Extractor/Qt/Universal IFR Extractor.app" "$COLLECT_PATH/Tools/"

echo -e "\n# Collect Kozlek kexts"
mkdir -p "$COLLECT_PATH/FakeSMC"
#
print "HWSensors"
rm -f -R "$COLLECT_PATH/FakeSMC/HWMonitor.app" # To avoid framework overwrite problems
cp -R "$SOURCE_PATH/HWSensors/Binaries/" "$COLLECT_PATH/FakeSMC/"
rm -f -R "$COLLECT_PATH/FakeSMC/org.hwsensors.HWMonitorHelper" # This is part of HWMonitor.app

echo -e "\n# Collect LongSoft tools"
mkdir -p "$COLLECT_PATH/Tools/UEFITool"
#
print "UEFITool"
cp -R "$SOURCE_PATH/UEFITool/UEFITool.app" "$COLLECT_PATH/Tools/UEFITool/UEFITool.app"
#
print "UEFITool(NE)"
cp -R "$SOURCE_PATH/UEFITool(NE)/UEFITool/UEFITool.app" "$COLLECT_PATH/Tools/UEFITool/UEFITool(NE).app"

echo -e "\n# Collect Mieze kexts"
mkdir -p "$COLLECT_PATH/LAN"
#
print "AtherosE2200Ethernet"
cp -R "$SOURCE_PATH/AtherosE2200Ethernet/build/Release/AtherosE2200Ethernet.kext" "$COLLECT_PATH/LAN/"
#
print "IntelMausiEthernet"
cp -R "$SOURCE_PATH/IntelMausiEthernet/build/Release/IntelMausiEthernet.kext" "$COLLECT_PATH/LAN/"
#
print "Realtek RTL8100"
cp -R "$SOURCE_PATH/Realtek RTL8100/build/Release/RealtekRTL8100.kext" "$COLLECT_PATH/LAN/"
#
print "Realtek RTL8111"
cp -R "$SOURCE_PATH/Realtek RTL8111/build/Release/RealtekRTL8111.kext" "$COLLECT_PATH/LAN/"

echo -e "\n# Collect RehabMan kexts and tools"
mkdir -p "$COLLECT_PATH/Laptop"
mkdir -p "$COLLECT_PATH/Laptop/VoodooPS2"
mkdir -p "$COLLECT_PATH/Debug"
mkdir -p "$COLLECT_PATH/FakePCIID"
mkdir -p "$COLLECT_PATH/Sound"
mkdir -p "$COLLECT_PATH/Bluetooth"
mkdir -p "$COLLECT_PATH/Bluetooth/BrcmPatchRAM"
mkdir -p "$COLLECT_PATH/USB/USBInjectAll"
#
print "EAPD Codec Commander"
cp -R "$SOURCE_PATH/EAPD Codec Commander/build/Products/Release/CodecCommander.kext" "$COLLECT_PATH/Sound/"
#
print "ACPI Battery Driver"
cp -R "$SOURCE_PATH/ACPI Battery Driver/build/Products/Release/ACPIBatteryManager.kext" "$COLLECT_PATH/Laptop/"
#
print "ACPI Debug"
cp -R "$SOURCE_PATH/ACPI Debug/build/Products/Release/ACPIDebug.kext" "$COLLECT_PATH/Debug/"
#
print "ACPI Keyboard"
cp -R "$SOURCE_PATH/ACPI Keyboard/build/Products/Release/ACPIKeyboard.kext" "$COLLECT_PATH/Laptop/"
#
print "BrcmPatchRAM"
cp -R "$SOURCE_PATH/BrcmPatchRAM/build/Products/Release/" "$COLLECT_PATH/Bluetooth/BrcmPatchRAM/"
#
print "FakePCIID"
cp -R "$SOURCE_PATH/FakePCIID/build/Release/" "$COLLECT_PATH/FakePCIID/"
#
print "MaciASL"
cp -R "$SOURCE_PATH/MaciASL/build/Release/MaciASL.app" "$COLLECT_PATH/Tools/"
#
print "USBInjectAll"
cp -R "$SOURCE_PATH/USBInjectAll/build/Products/Release/USBInjectAll.kext" "$COLLECT_PATH/USB/USBInjectAll/"
cp -R "$SOURCE_PATH/USBInjectAll/config_patches.plist" "$COLLECT_PATH/USB/USBInjectAll/"
cp -R "$SOURCE_PATH/USBInjectAll/SSDT-UIAC-ALL.dsl" "$COLLECT_PATH/USB/USBInjectAll/"
#
print "VoodooPS2"
cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/VoodooPS2Controller.kext" "$COLLECT_PATH/Laptop/VoodooPS2/"
cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/VoodooPS2Daemon" "$COLLECT_PATH/Laptop/VoodooPS2/"
cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/VoodooPS2synapticsPane.prefPane" "$COLLECT_PATH/Laptop/VoodooPS2/"
cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/synapticsconfigload" "$COLLECT_PATH/Laptop/VoodooPS2/"

echo -e "\n# Collect Slice kexts"
mkdir -p "$COLLECT_PATH/Sound/VoodooHDA"
#
print "VoodooHDA"
cp -R "$SOURCE_PATH/VoodooHDA/tranc/build/Release/VoodooHDA.kext" "$COLLECT_PATH/Sound/VoodooHDA"
cp -R "$SOURCE_PATH/VoodooHDA/VoodooHdaSettingsLoader/src/build/Release/VoodooHdaSettingsLoader.app" "$COLLECT_PATH/Sound/VoodooHDA"

echo -e "\n# Collect vit9696 kexts and plugins"
mkdir -p "$COLLECT_PATH/Lilu+Plugins"
#
print "AirportBrcmFixup"
cp -R "$SOURCE_PATH/AirportBrcmFixup/build/Release/AirportBrcmFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "AppleALC"
cp -R "$SOURCE_PATH/AppleALC/build/Release/AppleALC.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "ATH9KFixup"
cp -R "$SOURCE_PATH/ATH9KFixup/build/Release/ATH9KFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "AzulPatcher4600"
cp -R "$SOURCE_PATH/AzulPatcher4600/build/Release/AzulPatcher4600.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "BT4LEContiunityFixup"
cp -R "$SOURCE_PATH/BT4LEContiunityFixup/build/Release/BT4LEContiunityFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "CoreDisplayFixup"
cp -R "$SOURCE_PATH/CoreDisplayFixup/build/Release/CoreDisplayFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "CPUFriend"
cp -R "$SOURCE_PATH/CPUFriend/build/Release/CPUFriend.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "EnableLidWake"
cp -R "$SOURCE_PATH/EnableLidWake/build/Release/EnableLidWake.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "HibernationFixup"
cp -R "$SOURCE_PATH/HibernationFixup/build/Release/HibernationFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "IntelGraphicsDVMTFixup"
cp -R "$SOURCE_PATH/IntelGraphicsDVMTFixup/build/Release/IntelGraphicsDVMTFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "IntelGraphicsFixup"
cp -R "$SOURCE_PATH/IntelGraphicsFixup/build/Release/IntelGraphicsFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "Lilu"
cp -R "$SOURCE_PATH/Lilu/build/Release/Lilu.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "NightShiftUnlocker"
cp -R "$SOURCE_PATH/NightShiftUnlocker/build/Release/NightShiftUnlocker.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "NvidiaGraphicsFixup"
cp -R "$SOURCE_PATH/NvidiaGraphicsFixup/build/Release/NvidiaGraphicsFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "Shiki"
cp -R "$SOURCE_PATH/Shiki/build/Release/Shiki.kext" "$COLLECT_PATH/Lilu+Plugins"
#
print "WhateverGreen"
cp -R "$SOURCE_PATH/WhateverGreen/build/Release/WhateverGreen.kext" "$COLLECT_PATH/Lilu+Plugins"

echo -e "\n# Collect alexandred kexts"
mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C"
mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches"
#
print "VoodooI2C"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release/VoodooI2C.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
#
print "VoodooI2CELAN"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN/build/Release/VoodooI2CELAN.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
#
print "VoodooI2CHID"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CHID/build/Release/VoodooI2CHID.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
#
print "VoodooI2CSynaptics"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics/build/Release/VoodooI2CSynaptics.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
#
print "VoodooI2CUPDDEngine"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine/build/Release/VoodooI2CUPDDEngine.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
#
print "VoodooI2C ACPI Patches"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C ACPI Patches/Controllers" "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches/"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C ACPI Patches/GPIO" "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches/"
cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C ACPI Patches/Windows" "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches/"

echo -e "\n# Collect Piker-Alpha kexts and tools"
mkdir -p "$COLLECT_PATH/Debug"
#
print "AppleIntelInfo"
cp -R "$SOURCE_PATH/AppleIntelInfo/build/Release/AppleIntelInfo.kext" "$COLLECT_PATH/Debug"
#
print "csrstat"
cp -R "$SOURCE_PATH/csrstat/out" "$COLLECT_PATH/Tools/csrstat"
#
print "ssdtPRGen"
cp -R "$SOURCE_PATH/ssdtPRGen/ssdtPRGen.sh" "$COLLECT_PATH/Tools/"

echo -e "\n# Collect vulgo tools"
#
print "bootoption"
cp -R "$SOURCE_PATH/bootoption/build/Release/bootoption" "$COLLECT_PATH/Tools/"

echo -e "\n# Collect UEFI projects"
mkdir -p "$COLLECT_PATH/UEFI/Drivers"
mkdir -p "$COLLECT_PATH/UEFI/BOOT"
mkdir -p "$COLLECT_PATH/UEFI/Debug"
#
print "AptioMemoryFix"
cp "$SOURCE_PATH/edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/AptioMemoryFix.efi" "$COLLECT_PATH/UEFI/Drivers/AptioMemoryFix-64.efi"
#
print "AptioInputFix"
cp "$SOURCE_PATH/edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/AptioInputFix.efi" "$COLLECT_PATH/UEFI/Drivers/AptioInputFix-64.efi"

print "Clover EFI Bootloader"
# bootloader
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/CLOVER.efi" "$COLLECT_PATH/UEFI/BOOT/BOOTX64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/CLOVER.efi" "$COLLECT_PATH/UEFI/CLOVERX64.efi"

# drivers
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/DataHubDxe.efi" "$COLLECT_PATH/UEFI/Drivers/DataHubDxe-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/AppleImageCodec.efi" "$COLLECT_PATH/UEFI/Drivers/AppleImageCodec-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/AppleKeyAggregator.efi" "$COLLECT_PATH/UEFI/Drivers/AppleKeyAggregator-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/AppleUITheme.efi" "$COLLECT_PATH/UEFI/Drivers/AppleUITheme-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/EmuVariableUefi.efi" "$COLLECT_PATH/UEFI/Drivers/EmuVariableUefi-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/Fat.efi" "$COLLECT_PATH/UEFI/Drivers/Fat-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/FirmwareVolume.efi" "$COLLECT_PATH/UEFI/Drivers/FirmwareVolume-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/FSInject.efi" "$COLLECT_PATH/UEFI/Drivers/FSInject-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/OsxAptioFix2Drv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxAptioFix2Drv-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/OsxAptioFix3Drv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxAptioFix3Drv-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/OsxAptioFixDrv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxAptioFixDrv-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/OsxFatBinaryDrv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxFatBinaryDrv-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/OsxLowMemFixDrv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxLowMemFixDrv-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/PartitionDxe.efi" "$COLLECT_PATH/UEFI/Drivers/PartitionDxe-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/SMCHelper.efi" "$COLLECT_PATH/UEFI/Drivers/SMCHelper-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/VBoxHfs.efi" "$COLLECT_PATH/UEFI/Drivers/VBoxHfs-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/CsmVideoDxe.efi" "$COLLECT_PATH/UEFI/Drivers/CsmVideoDxe-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/UsbKbDxe.efi" "$COLLECT_PATH/UEFI/Drivers/UsbKbDxe-64.efi"
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/UsbMouseDxe.efi" "$COLLECT_PATH/UEFI/Drivers/UsbMouseDxe-64.efi"

# additinal drivers
cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE5/X64/DumpUefiCalls.efi" "$COLLECT_PATH/UEFI/Debug/DumpUefiCalls-64.efi"
