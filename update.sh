#!/bin/bash

# git_pull
# args: <folder> optional: <string>
function git_pull()
{
    echo "🔸 $(tput bold)$(basename "$1")$(tput sgr0):"
    git -C "$1" pull
}

# svn_update
# args: <folder> optional: <string>
function svn_update()
{
    echo "🔸 $(tput bold)$(basename "$1")$(tput sgr0):"
    pushd "$1" >/dev/null
    svn update
    popd >/dev/null
}

# Check git svn tools
if [ "$(git -v 2>&1 | grep "no developer")" != "" ] || [ "$(svn -v 2>&1 | grep "no developer")" != "" ]; then
    echo "Command Line Tools: Not Installed or Not Selected, aborting..."
    exit 1
else
    echo "Command Line Tools: Installed"
fi

echo -e "\n# Update ACPI Component Architecture"
git_pull "ACPICA"

echo -e "\n# Update Kozlek kexts"
git_pull "HWSensors"

echo -e "\n# Update LongSoft tools"
git_pull "UEFITool"
git_pull "UEFITool(NE)"

echo -e "\n# Update Mieze kexts"
git_pull "AtherosE2200Ethernet"
git_pull "IntelMausiEthernet"
git_pull "Realtek RTL8100"
git_pull "Realtek RTL8111"

echo -e "\n# Update RehabMan kexts and tools"
git_pull "EAPD Codec Commander"
git_pull "ACPI Battery Driver"
git_pull "ACPI Debug"
git_pull "ACPI Keyboard"
git_pull "BrcmPatchRAM"
git_pull "FakePCIID"
#
git_pull "MaciASL"

echo -e "\n# Update Slice kexts"
svn_update "VoodooHDA"

echo -e "\n# Update vit9696 kexts and plugins"
git_pull "AirportBrcmFixup"     #lvs1974
git_pull "AppleALC"
git_pull "ATH9KFixup"           #chunnann
git_pull "AzulPatcher4600"      #coderobe
git_pull "BT4LEContiunityFixup" #lvs1974
git_pull "CoreDisplayFixup"     #PMheart
git_pull "CPUFriend"            #PMheart
git_pull "EnableLidWake"        #syscl
git_pull "HibernationFixup"     #lvs1974
git_pull "IntelGraphicsFixup"   #lvs1974
git_pull "Lilu"
git_pull "NvidiaGraphicsFixup"  #lvs1974
git_pull "Shiki"
git_pull "WhateverGreen"

echo -e "\n# Update alexandred kexts"
git_pull "VoodooI2C/Dependencies/VoodooGPIO"
git_pull "VoodooI2C/Dependencies/VoodooI2CServices"
#
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine"
#
git_pull "VoodooI2C/ACPI-Patches"

echo -e "\n# Update Piker-Alpha kexts and tools"
git_pull "AppleIntelInfo"
git_pull "ssdtPRGen.sh"

echo -e "\n# Update UEFI projects"
#git_pull edk2                                          #TianoCore
#svn_update edk2
svn_update "edk2/Clover"                                #CloverTeam
git_pull "edk2/AptioFixPkg"                             #vit9696
# UEFI useful packages
git_pull "edk2/CupertinoModulePkg"                      #CupertinoNet
git_pull "edk2/EfiMiscPkg"                              #CupertinoNet
git_pull "edk2/EfiPkg"                                  #CupertinoNet
