#!/bin/bash

function git_pull()
{
    if [ -z "$2" ]; then
    	echo "🔸 $(tput bold)$1$(tput sgr0):"
    else
        echo "🔸 $(tput bold)$2$(tput sgr0):"
    fi
    git -C "$1" pull
    #echo ""
}

function svn_update()
{
    if [ -z "$2" ]; then
    	echo "🔸 $(tput bold)$1$(tput sgr0):"
    else
        echo "🔸 $(tput bold)$2$(tput sgr0):"
    fi

    cd "$1"
    svn update
    cd ..
}

echo -e "\n# Update ACPI Component Architecture"
git_pull acpica "ACPICA"

echo -e "\n# Update LongSoft tools"
git_pull UEFITool
git_pull "UEFITool(NE)" "UEFITool(NE)"

echo -e "\n# Update Mieze kexts"
git_pull AtherosE2200Ethernet
git_pull IntelMausiEthernet
git_pull RealtekRTL8100 "Realtek RTL8100"
git_pull RTL8111_driver_for_OS_X "Realtek RTL8111"

echo -e "\n# Update RehabMan kexts and tools"
git_pull EAPD-Codec-Commander "EAPD Codec Commander"
git_pull OS-X-ACPI-Battery-Driver "OSX ACPI Battery Driver"
git_pull OS-X-ACPI-Debug "OSX ACPI Debug"
git_pull OS-X-ACPI-Keyboard "OSX ACPI Keyboard"
git_pull OS-X-BrcmPatchRAM "OSX BrcmPatchRAM"
git_pull OS-X-Fake-PCI-ID "OSX FakePCIID"
#
git_pull OS-X-MaciASL-patchmatic "OSX MaciASL"

echo -e "\n# Update vit9696 kexts and plugins"
git_pull AirportBrcmFixup       #lvs1974
git_pull AppleALC
git_pull ATH9KFixup             #chunnann
git_pull AzulPatcher4600        #coderobe
git_pull BT4LEContiunityFixup	#lvs1974
git_pull CoreDisplayFixup       #PMheart
git_pull CPUFriend		        #PMheart
git_pull EnableLidWake		    #syscl
git_pull HibernationFixup       #lvs1974	
git_pull IntelGraphicsFixup	    #lvs1974
git_pull Lilu
git_pull NvidiaGraphicsFixup	#lvs1974
git_pull Shiki
git_pull WhateverGreen

echo -e "\n# Update alexandred kexts"
git_pull "VoodooI2C/Dependencies/VoodooGPIO" "VoodooGPIO"
git_pull "VoodooI2C/Dependencies/VoodooI2CServices" "VoodooI2CServices"
#
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN" "VoodooI2CELAN"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID" "VoodooI2CHID"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics" "VoodooI2CSynaptics"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine" "VoodooI2CUPDDEngine"
#
git_pull "VoodooI2C-Patches" "VoodooI2C Patches"

echo -e "\n# Update Piker-Alpha kexts and tools"
git_pull "AppleIntelInfo"
git_pull "ssdtPRGen.sh" "ssdtPRGen"

echo -e "\n# Update UEFI projects"
git_pull edk2 "EDK2"                                        #TianoCore
#svn_update edk2

svn_update edk2/Clover "Clover EFI Bootloader"              #CloverTeam

#cd edk2
git_pull "edk2/AptioFixPkg" "AptioFixPkg"                   #vit9696
# UEFI useful packages
git_pull "edk2/CupertinoModulePkg" "CupertinoModulePkg"     #CupertinoNet   
git_pull "edk2/EfiMiscPkg" "EfiMiscPkg"                     #CupertinoNet
git_pull "edk2/EfiPkg" "EfiPkg"                             #CupertinoNet