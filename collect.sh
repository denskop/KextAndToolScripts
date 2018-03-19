#!/bin/bash

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
mkdir -p "Collection/Tools/ACPICA"
#
print "ACPICA"
cp -R "acpica/generate/unix/bin/" "Collection/Tools/ACPICA/"

echo -e "\n# Collect LongSoft tools"
mkdir -p "Collection/Tools/UEFITool"
#
print "UEFITool"
cp -R "UEFITool/UEFITool.app" "Collection/Tools/UEFITool/UEFITool.app"
#
print "UEFITool(NE)"
cp -R "UEFITool(NE)/UEFITool.app" "Collection/Tools/UEFITool/UEFITool(NE).app"

echo -e "\n# Collect Mieze kexts"
mkdir -p "Collection/LAN"
#
print "AtherosE2200Ethernet"
cp -R "AtherosE2200Ethernet/build/Release/AtherosE2200Ethernet.kext" "Collection/LAN/"
#
print "IntelMausiEthernet"
cp -R "IntelMausiEthernet/build/Release/IntelMausiEthernet.kext" "Collection/LAN/"
#
print "Realtek RTL8111"
cp -R "RTL8111_driver_for_OS_X/build/Release/RealtekRTL8111.kext" "Collection/LAN/"

echo -e "\n# Collect RehabMan kexts"
mkdir -p "Collection/Laptop"
mkdir -p "Collection/Misc"
mkdir -p "Collection/FakePCIID"
mkdir -p "Collection/Sound"
mkdir -p "Collection/Bluetooth"
mkdir -p "Collection/Bluetooth/BrcmPatchRAM"
#
print "EAPD Codec Commander"
cp -R "EAPD-Codec-Commander/build/Products/Release/CodecCommander.kext" "Collection/Sound/"
#
print "OSX ACPI Battery Driver"
cp -R "OS-X-ACPI-Battery-Driver/build/Products/Release/ACPIBatteryManager.kext" "Collection/Laptop/"
#
print "OSX ACPI Debug"
cp -R "OS-X-ACPI-Debug/build/Products/Release/ACPIDebug.kext" "Collection/Misc/"
#
print "OSX ACPI Keyboard"
cp -R "OS-X-ACPI-Keyboard/build/Products/Release/ACPIKeyboard.kext" "Collection/Laptop/"
#
print "OSX BrcmPatchRAM"
cp -R "OS-X-BrcmPatchRAM/build/Products/Release/" "Collection/Bluetooth/BrcmPatchRAM/"
#
print "OSX FakePCIID"
cp -R "OS-X-Fake-PCI-ID/build/Release/" "Collection/FakePCIID/"

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
print "IntelGraphicsFixup"
cp -R "IntelGraphicsFixup/build/Release/IntelGraphicsFixup.kext" "Collection/Lilu+Plugins"
#
print "Lilu"
cp -R "Lilu/build/Release/Lilu.kext" "Collection/Lilu+Plugins"
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
mkdir -p "Collection/Laptop/VoodooI2C/ACPI-Patches"
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
print "VoodooI2C Patches"
cp -R "VoodooI2C-Patches/Controllers" "Collection/Laptop/VoodooI2C/ACPI-Patches/"
cp -R "VoodooI2C-Patches/GPIO" "Collection/Laptop/VoodooI2C/ACPI-Patches/"
cp -R "VoodooI2C-Patches/Windows" "Collection/Laptop/VoodooI2C/ACPI-Patches/"

echo -e "\n# Collect Piker-Alpha kexts and tools"
mkdir -p "Collection/Misc"
#
print "AppleIntelInfo"
cp -R "AppleIntelInfo/build/Release/AppleIntelInfo.kext" "Collection/Misc"