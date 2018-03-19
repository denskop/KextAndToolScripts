#!/bin/bash

function git_clone()
{
    echo "🔸 $(tput bold)$2$(tput sgr0):"

    if [ -z "$3" ]; then
        git clone "$1"
    else
        git clone "$1" "$2" -b "$3"
    fi 

}

function git_clone2()
{
    echo "🔸 $(tput bold)$3$(tput sgr0):"

    git clone "$1" "$2"
}

function svn_co()
{
    if [ -z "$3" ]; then
        echo "🔸 $(tput bold)$2$(tput sgr0):"
    else
        echo "🔸 $(tput bold)$3$(tput sgr0):"
    fi

    svn checkout "$1" "$2"
}

echo -e "\n# Clone ACPI Component Architecture"
git_clone https://github.com/acpica/acpica.git "ACPICA"

echo -e "\n# Clone LongSoft tools"
git_clone https://github.com/LongSoft/UEFITool.git "UEFITool"
git_clone https://github.com/LongSoft/UEFITool.git "UEFITool(NE)" new_engine

echo -e "\n# Clone Mieze kexts"
git_clone https://github.com/Mieze/AtherosE2200Ethernet.git "AtherosE2200Ethernet"
git_clone https://github.com/Mieze/IntelMausiEthernet.git "IntelMausiEthernet"
git_clone https://github.com/Mieze/RealtekRTL8100.git "Realtek RTL8100"
git_clone https://github.com/Mieze/RTL8111_driver_for_OS_X.git "Realtek RTL8111"

echo -e "\n# Clone RehabMan kexts"
git_clone https://github.com/RehabMan/EAPD-Codec-Commander.git "EAPD Codec Commander"
git_clone https://github.com/RehabMan/OS-X-ACPI-Battery-Driver.git "OSX ACPI Battery Driver"
git_clone https://github.com/RehabMan/OS-X-ACPI-Debug.git "OSX ACPI Debug"
git_clone https://github.com/RehabMan/OS-X-ACPI-Keyboard.git "OSX ACPI Keyboard"
git_clone https://github.com/RehabMan/OS-X-BrcmPatchRAM.git "OSX BrcmPatchRAM"
git_clone https://github.com/RehabMan/OS-X-Fake-PCI-ID.git "OSX FakePCIID"

echo -e "\n# Clone vit9696 kexts and plugins"
git_clone https://github.com/lvs1974/AirportBrcmFixup.git "AirportBrcmFixup"            #lvs1974
git_clone https://github.com/vit9696/AppleALC.git "AppleALC"
git_clone https://github.com/chunnann/ATH9KFixup.git "ATH9KFixup"						#chunnann
git_clone https://github.com/coderobe/AzulPatcher4600.git "AzulPatcher4600"             #coderobe
git_clone https://github.com/lvs1974/BT4LEContiunityFixup.git "BT4LEContiunityFixup"	#lvs1974
git_clone https://github.com/PMheart/CoreDisplayFixup.git "CoreDisplayFixup"    		#PMheart
git_clone https://github.com/PMheart/CPUFriend.git "CPUFriend"                          #PMheart
git_clone https://github.com/syscl/EnableLidWake.git "EnableLidWake"	           		#syscl
git_clone https://github.com/lvs1974/HibernationFixup.git "HibernationFixup"    		#lvs1974	
git_clone https://github.com/lvs1974/IntelGraphicsFixup.git "IntelGraphicsFixup"        #lvs1974
git_clone https://github.com/vit9696/Lilu.git "Lilu"
git_clone https://github.com/lvs1974/NvidiaGraphicsFixup.git "NvidiaGraphicsFixup"      #lvs1974
git_clone https://github.com/vit9696/Shiki.git "Shiki"
git_clone https://github.com/vit9696/WhateverGreen.git "WhateverGreen"

echo -e "\n# Clone alexandred kexts"
git_clone https://github.com/alexandred/VoodooI2C.git "VoodooI2C"

# Dependencies
git_clone2 https://github.com/coolstar/VoodooGPIO.git "VoodooI2C/Dependencies/VoodooGPIO" "VoodooGPIO"

# Satellites
git_clone2 https://github.com/kprinssu/VoodooI2CELAN.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN" "VoodooI2CELAN"
git_clone2 https://github.com/alexandred/VoodooI2CHID.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID" "VoodooI2CHID"
git_clone2 https://github.com/alexandred/VoodooI2CSynaptics.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics" "VoodooI2CSynaptics"
git_clone2 https://github.com/blankmac/VoodooI2CUPDDEngine.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine" "VoodooI2CUPDDEngine"

# Patches
git_clone2 https://github.com/alexandred/VoodooI2C-Patches.git "VoodooI2C-Patches" "VoodooI2C Patches"

echo -e "\n# Clone Piker-Alpha kexts and tools"
git_clone https://github.com/Piker-Alpha/AppleIntelInfo.git "AppleIntelInfo"
git_clone https://github.com/Piker-Alpha/ssdtPRGen.sh "ssdtPRGen"

echo -e "\n# Clone UEFI projects"
git_clone https://github.com/vit9696/AptioFixPkg.git "AptioFixPkg"
git_clone https://github.com/tianocore/edk2.git "EDK2"
#svn_co https://svn.code.sf.net/p/edk2/code/trunk . "EDK2"
svn_co https://svn.code.sf.net/p/cloverefiboot/code Clover "Clover EFI Bootloader"