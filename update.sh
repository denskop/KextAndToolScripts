#!/bin/bash

blacklist_file="blacklist.txt"
blacklist_file_exist="false"

# check_in_blacklist
# args: <file>
# return codes: -1, blacklist not found
#                0, file is not listed in blacklist
#                1, file is listed in blacklist
function check_in_blacklist()
{
    if [ "$blacklist_file_exist" == "false" ]; then
        return -1
    fi

    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [ "$1" == "$line" ]; then
            #echo "Found in blacklist: $line"
            return 1
        fi
    done < "$blacklist_file"
    return 0
}

# git_pull
# args: <folder> optional: <string>
function git_pull()
{
    check_in_blacklist "$(basename "$1")"
    if [ "$?" == "1" ]; then
        rm -rf "$1"
        return 1
    fi

    echo "🔸 $(tput bold)$(basename "$1")$(tput sgr0):"
    git -C "$1" pull
}

# svn_update
# args: <folder> optional: <string>
function svn_update()
{
    check_in_blacklist "$(basename "$1")"
    if [ "$?" == "1" ]; then
        rm -rf "$1"
        return 1
    fi

    echo "🔸 $(tput bold)$(basename "$1")$(tput sgr0):"
    pushd "$1" >/dev/null
    svn update
    popd >/dev/null
}

# print_group
# args: <group>
function print_group()
{
    if [ "$1" == "acpica" ]; then
        array=("ACPICA")
        title="\n# Update ACPI Component Architecture"
    elif [ "$1" == "denskop" ]; then
        array=("Universal IFR Extractor")
        title="\n# Update denskop forks"
    elif [ "$1" == "kozlek" ]; then
        array=("HWSensors")
        title="\n# Update Kozlek kexts"
    elif [ "$1" == "longsoft" ]; then
        array=("UEFITool" \
               "UEFITool(NE)")
        title="\n# Update LongSoft tools"
    elif [ "$1" == "vulgo" ]; then
        array=("bootoption")
        title="\n# Update vulgo tools"
    elif [ "$1" == "mieze" ]; then
        array=("AtherosE2200Ethernet" \
               "IntelMausiEthernet" \
               "Realtek RTL8100" \
               "Realtek RTL8111")
        title="\n# Update Mieze kexts"
    elif [ "$1" == "rehabman" ]; then
        array=("EAPD Codec Commander" \
               "ACPI Battery Driver" \
               "ACPI Debug" \
               "ACPI Keyboard" \
               "BrcmPatchRAM" \
               "FakePCIID" \
               "MaciASL" \
               "USBInjectAll" \
               "VoodooPS2")
        title="\n# Update RehabMan kexts and tools"
    elif [ "$1" == "slice" ]; then
        array=("VoodooHDA")
        title="\n# Update Slice kexts"
    elif [ "$1" == "vit9696" ]; then
        array=("AirportBrcmFixup" \
               "AppleALC" \
               "ATH9KFixup" \
               "AzulPatcher4600" \
               "BT4LEContiunityFixup" \
               "CoreDisplayFixup" \
               "CPUFriend" \
               "EnableLidWake" \
               "HibernationFixup" \
               "IntelGraphicsDVMTFixup" \
               "IntelGraphicsFixup" \
               "Lilu" \
               "NightShiftUnlocker" \
               "NvidiaGraphicsFixup" \
               "Shiki" \
               "WhateverGreen")
        title="\n# Update vit9696 kexts and plugins"
    elif [ "$1" == "alexandred" ]; then
        array=("VoodooI2C" \
               "VoodooGPIO" \
               "VoodooI2CELAN" \
               "VoodooI2CHID" \
               "VoodooI2CSynaptics" \
               "VoodooI2CUPDDEngine" \
               "VoodooI2C ACPI Patches")
        title="\n# Update alexandred kexts"
    elif [ "$1" == "piker_alpha" ]; then
        array=("AppleIntelInfo" \
               "csrstat" \
               "ssdtPRGen")
        title="\n# Update Piker-Alpha kexts and tools"
    elif [ "$1" == "uefi" ]; then
        array=("edk2" \
               "Clover" \
               "CupertinoModulePkg" \
               "EfiMiscPkg" \
               "EfiPkg" \
               "AptioFixPkg")
        title="\n# Update UEFI projects"
    else
        array=("nil")
        title="nil"
    fi

    for i in "${array[@]}"; do
        check_in_blacklist "$(basename "${i}")"
        ret="$?"

        if [ "$ret" == "0" ] || [ "$ret" == "-1" ]; then
            echo -e "$title"
            return 1
        fi
    done
    return 0
}

# Check git svn tools
if [ "$(git -v 2>&1 | grep "no developer")" != "" ] || [ "$(svn -v 2>&1 | grep "no developer")" != "" ]; then
    echo "Command Line Tools: Not Installed or Not Selected, aborting..."
    exit 1
else
    echo "Command Line Tools: Installed"
fi

# Check blacklist file
if [ -f "$blacklist_file" ]; then
    echo "Blacklist file: Exist"
    blacklist_file_exist="true"
else
    echo "Blacklist file: Not exist"
fi

print_group "acpica"
git_pull "ACPICA"

print_group "denskop"
git_pull "Universal IFR Extractor"

print_group "kozlek"
git_pull "HWSensors"

print_group "longsoft"
git_pull "UEFITool"
git_pull "UEFITool(NE)"

print_group "mieze"
git_pull "AtherosE2200Ethernet"
git_pull "IntelMausiEthernet"
git_pull "Realtek RTL8100"
git_pull "Realtek RTL8111"

print_group "rehabman"
git_pull "EAPD Codec Commander"
git_pull "ACPI Battery Driver"
git_pull "ACPI Debug"
git_pull "ACPI Keyboard"
git_pull "BrcmPatchRAM"
git_pull "FakePCIID"
git_pull "MaciASL"
git_pull "USBInjectAll"
git_pull "VoodooPS2"

print_group "slice"
svn_update "VoodooHDA"

print_group "vit9696"
git_pull "AirportBrcmFixup"         #lvs1974
git_pull "AppleALC"
git_pull "ATH9KFixup"               #chunnann
git_pull "AzulPatcher4600"          #coderobe
git_pull "BT4LEContiunityFixup"     #lvs1974
git_pull "CoreDisplayFixup"         #PMheart
git_pull "CPUFriend"                #PMheart
git_pull "EnableLidWake"            #syscl
git_pull "HibernationFixup"         #lvs1974
git_pull "IntelGraphicsDVMTFixup"   #BarbaraPalvin
git_pull "IntelGraphicsFixup"       #lvs1974
git_pull "Lilu"
git_pull "NightShiftUnlocker"       #Austere-J
git_pull "NvidiaGraphicsFixup"      #lvs1974
git_pull "Shiki"
git_pull "WhateverGreen"

print_group "vulgo"
git_pull "bootoption"

print_group "alexandred"
git_pull "VoodooI2C"
git_pull "VoodooI2C/Dependencies/VoodooGPIO"
#
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics"
git_pull "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine"
#
git_pull "VoodooI2C/VoodooI2C ACPI Patches"

print_group "piker_alpha"
git_pull "AppleIntelInfo"
git_pull "csrstat"
git_pull "ssdtPRGen"

print_group "uefi"
#git_pull edk2                                          #TianoCore
#svn_update edk2
svn_update "edk2/Clover"                                #CloverTeam
git_pull "edk2/AptioFixPkg"                             #vit9696
# UEFI useful packages
git_pull "edk2/CupertinoModulePkg"                      #CupertinoNet
git_pull "edk2/EfiMiscPkg"                              #CupertinoNet
git_pull "edk2/EfiPkg"                                  #CupertinoNet
