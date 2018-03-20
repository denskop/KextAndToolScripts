#!/bin/bash

# git_clone
# args: <url> <folder> optional: <branch>
function git_clone()
{
    echo "🔸 $(tput bold)$2$(tput sgr0):"

    if [ -z "$3" ]; then
        git clone "$1"
    else
        git clone "$1" "$2" -b "$3"
    fi 

}

# git_clone2
# args: <url> <folder> <string>
function git_clone2()
{
    echo "🔸 $(tput bold)$3$(tput sgr0):"

    git clone "$1" "$2"
}

# git_checkout
# args: <url> <folder> <sha> <string>
function git_checkout()
{
    echo "🔸 $(tput bold)$4$(tput sgr0):"

    git clone "$1" "$2"
    git -C "$2" checkout "$3"
}

# svn_co
# args: <url> <folder> optional: <string>
function svn_co()
{
    if [ -z "$3" ]; then
        echo "🔸 $(tput bold)$2$(tput sgr0):"
    else
        echo "🔸 $(tput bold)$3$(tput sgr0):"
    fi

    svn checkout "$1" "$2"
}

# Check git svn tools
if [ "$(git -v 2>&1 | grep "no developer")" != "" ] || [ "$(svn -v 2>&1 | grep "no developer")" != "" ]; then
    echo "Command Line Tools: Not Installed or Not Selected, aborting..."
    exit 1
else
    echo "Command Line Tools: Installed"
fi

echo -e "\n# Clone ACPI Component Architecture"
git_clone https://github.com/acpica/acpica.git "ACPICA"

echo -e "\n# Clone Kozlek kexts"
git_clone https://github.com/kozlek/HWSensors.git "HWSensors"

echo -e "\n# Clone LongSoft tools"
git_clone https://github.com/LongSoft/UEFITool.git "UEFITool"
git_clone https://github.com/LongSoft/UEFITool.git "UEFITool(NE)" new_engine

echo -e "\n# Clone Mieze kexts"
git_clone https://github.com/Mieze/AtherosE2200Ethernet.git "AtherosE2200Ethernet"
git_clone https://github.com/Mieze/IntelMausiEthernet.git "IntelMausiEthernet"
git_clone https://github.com/Mieze/RealtekRTL8100.git "Realtek RTL8100"
git_clone https://github.com/Mieze/RTL8111_driver_for_OS_X.git "Realtek RTL8111"

echo -e "\n# Clone RehabMan kexts and tools"
git_clone https://github.com/RehabMan/EAPD-Codec-Commander.git "EAPD Codec Commander"
git_clone https://github.com/RehabMan/OS-X-ACPI-Battery-Driver.git "OSX ACPI Battery Driver"
git_clone https://github.com/RehabMan/OS-X-ACPI-Debug.git "OSX ACPI Debug"
git_clone https://github.com/RehabMan/OS-X-ACPI-Keyboard.git "OSX ACPI Keyboard"
git_clone https://github.com/RehabMan/OS-X-BrcmPatchRAM.git "OSX BrcmPatchRAM"
git_clone https://github.com/RehabMan/OS-X-Fake-PCI-ID.git "OSX FakePCIID"
#
git_clone https://github.com/RehabMan/OS-X-MaciASL-patchmatic.git "OSX MaciASL"

echo -e "\n# Clone Slice kexts"
svn_co https://svn.code.sf.net/p/voodoohda/code "VoodooHDA"

echo -e "\n# Clone vit9696 kexts and plugins"
git_clone https://github.com/lvs1974/AirportBrcmFixup.git "AirportBrcmFixup"            #lvs1974
git_clone https://github.com/vit9696/AppleALC.git "AppleALC"
git_clone https://github.com/chunnann/ATH9KFixup.git "ATH9KFixup"                       #chunnann
git_clone https://github.com/coderobe/AzulPatcher4600.git "AzulPatcher4600"             #coderobe
git_clone https://github.com/lvs1974/BT4LEContiunityFixup.git "BT4LEContiunityFixup"    #lvs1974
git_clone https://github.com/PMheart/CoreDisplayFixup.git "CoreDisplayFixup"            #PMheart
git_clone https://github.com/PMheart/CPUFriend.git "CPUFriend"                          #PMheart
git_clone https://github.com/syscl/EnableLidWake.git "EnableLidWake"                    #syscl
git_clone https://github.com/lvs1974/HibernationFixup.git "HibernationFixup"            #lvs1974
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
git_checkout https://github.com/tianocore/edk2.git edk2 "a35918caae4d0b9bb51d0d4765117d7ca9a4d641" "EDK2"   #Tianocore
#git_clone https://git.code.sf.net/p/tianocore/edk2 "EDK2"
#
svn_co https://svn.code.sf.net/p/cloverefiboot/code edk2/Clover "Clover EFI Bootloader"                     #CloverTeam
# UEFI useful packages
git_clone2 https://github.com/CupertinoNet/CupertinoModulePkg edk2/CupertinoModulePkg "CupertinoModulePkg"  #CupertinoNet
git_clone2 https://github.com/CupertinoNet/EfiMiscPkg edk2/EfiMiscPkg "EfiMiscPkg"                          #CupertinoNet
git_clone2 https://github.com/CupertinoNet/EfiPkg edk2/EfiPkg "EfiPkg"                                      #CupertinoNet
#
git_clone2 https://github.com/vit9696/AptioFixPkg.git edk2/AptioFixPkg "AptioFixPkg"                        #vit9696

echo -e "\n# Check and Download missing tools"

# Check NASM by vit9696
NASMVER="2.13.02"
if [ "$(nasm -v | grep Apple)" != "" ]; then
    echo "1. nasm - $(tput bold)FAILED$(tput sgr0)"
    rm -rf "nasm-${NASMVER}-macosx.zip" "nasm-${NASMVER}"
    curl -O "http://www.nasm.us/pub/nasm/releasebuilds/${NASMVER}/macosx/nasm-${NASMVER}-macosx.zip" || exit 1
else
    echo "1. nasm - $(tput bold)PASSED$(tput sgr0)"
fi

# Check MTOCK by vit9696
if [ "$(which mtoc.NEW)" == "" ] || [ "$(which mtoc)" == "" ]; then
    echo "2. mtoc - $(tput bold)FAILED$(tput sgr0)"
else
    echo "2. mtoc - $(tput bold)PASSED$(tput sgr0)"
fi

# Check qmake
echo "3. qmake - $(tput bold)UNKNOWN$(tput sgr0). Set qmake location to build.sh manually!"
