#!/bin/bash

SELF_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_PATH="$SELF_PATH/SourceCode"

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
        return "-1"
    fi

    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [ "$1" == "$line" ]; then
            #echo "Found in blacklist: $line"
            return "1"
        fi
    done < "$SELF_PATH/$blacklist_file"
    return "0"
}

# git_pull
# args: <folder> optional: <string>
function git_pull()
{
    check_in_blacklist "$(basename "$1")"
    if [ "$?" == "1" ]; then
        rm -rf "$SOURCE_PATH/$1"
        return "1"
    fi

    echo "🔸 $(tput bold)$(basename "$1")$(tput sgr0):"
    result="$(git -C "$SOURCE_PATH/$1" reset --hard 2>&1)"
    result="$(git -C "$SOURCE_PATH/$1" pull 2>&1)"

    if [[ "$result" =~ .*"Updating ".* ]] || [[ "$result" =~ .*"remote: Counting objects: ".* ]]; then
        echo -e "\033[0;32m########################\033[0m"
        echo "$result"
        echo -e "\033[0;32m########################\033[0m"
    else
        echo "$result"
    fi

    if [ ! -z "$2" ]; then
        git -C "$SOURCE_PATH/$1" reset --hard head
        result="$(git -C "$SOURCE_PATH/$1" checkout "$2" 2>&1 >/dev/null)"
        #echo "$result"
    fi
}

# svn_update
# args: <folder> optional: <string>
function svn_update()
{
    check_in_blacklist "$(basename "$1")"
    if [ "$?" == "1" ]; then
        rm -rf "$SOURCE_PATH/$1"
        return "1"
    fi

    echo "🔸 $(tput bold)$(basename "$1")$(tput sgr0):"
    pushd "$SOURCE_PATH/$1" >/dev/null

    result="$(svn revert --recursive . 2>&1)"
    result="$(svn update 2>&1)"
    if [[ "$result" =~ .*[ABCDEGU][[:space:]].* ]]; then
        echo -e "\033[0;32m########################\033[0m"
        echo "$result"
        echo -e "\033[0;32m########################\033[0m"
    elif [[ "$result" =~ .*"At revision ".*. ]]; then
        echo "Already up to date."
    else
        echo "$result"
    fi
    popd >/dev/null
}

# print_group
# args: <group>
function print_group()
{
    if [ "$1" == "acpica" ]; then
        array=("ACPICA")
        title="\n# Update ACPI Component Architecture tools"
    elif [ "$1" == "corpnewt" ]; then
        array=("NullCPUPowerManagement")
        title="\n# Update corpnewt forks"
    elif [ "$1" == "denskop" ]; then
        array=("Universal IFR Extractor" \
               "VoodooTSCSync")
        title="\n# Update denskop forks"
    elif [ "$1" == "kozlek" ]; then
        array=("HWSensors")
        title="\n# Update Kozlek kexts"
    elif [ "$1" == "kxproject" ]; then
        array=("kXAudioDriver")
        title="\n# Update kxproject kexts"
    elif [ "$1" == "longsoft" ]; then
        array=("UEFITool" \
               "UEFITool_NE")
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
    elif [ "$1" == "acidanthera" ]; then
        array=("AirportBrcmFixup" \
               "AppleALC" \
               "ATH9KFixup" \
               "AzulPatcher4600" \
               "BT4LEContiunityFixup" \
               "CPUFriend" \
               "EnableLidWake" \
               "HibernationFixup" \
               "IntelGraphicsDVMTFixup" \
               "Lilu" \
               "NightShiftUnlocker" \
               "NoTouchID" \
               "WhateverGreen")
        title="\n# Update acidanthera kexts and plugins"
    elif [ "$1" == "alexandred" ]; then
        array=("VoodooI2C" \
               "VoodooGPIO" \
               "VoodooI2CELAN" \
               "VoodooI2CHID" \
               "VoodooI2CSynaptics" \
               "VoodooI2CUPDDEngine" \
               "VoodooI2C ACPI Patches")
        title="\n# Update alexandred kexts"
    elif [ "$1" == "goodwin" ]; then
        array=("HWPEnable")
        title="\n# Update goodwin kexts"
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
               "AptioFixPkg" \
               "ApfsSupportPkg")
        title="\n# Update UEFI projects"
    else
        array=("nil")
        title="nil"
    fi

    for i in "${array[@]}"; do
        check_in_blacklist "$(basename "${i}")"
        ret="$?"

        if [ "$ret" != "1" ]; then
            echo -e "$title"
            return "1"
        fi
    done
    return "0"
}

# Check git svn tools
if [ "$(git -v 2>&1 | grep "no developer")" != "" ] || [ "$(svn -v 2>&1 | grep "no developer")" != "" ]; then
    echo "Command Line Tools: Not Installed or Not Selected, aborting..."
    exit 1
else
    echo "Command Line Tools: Installed"
fi

# Check blacklist file
if [ -f "$SELF_PATH/$blacklist_file" ]; then
    echo "Blacklist file: Exist"
    blacklist_file_exist="true"
else
    echo "Blacklist file: Not exist"
fi

print_group "acpica"
git_pull "ACPICA"

print_group "corpnewt"
git_pull "NullCPUPowerManagement"

print_group "denskop"
git_pull "Universal IFR Extractor"
git_pull "VoodooTSCSync"

print_group "kozlek"
git_pull "HWSensors"

print_group "kxproject"
git_pull "kXAudioDriver"

print_group "longsoft"
git_pull "UEFITool"
git_pull "UEFITool_NE"

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

print_group "acidanthera"
git_pull "AirportBrcmFixup"         #lvs1974
git_pull "AppleALC"
git_pull "ATH9KFixup"               #chunnann
git_pull "AzulPatcher4600"          #coderobe
git_pull "BT4LEContiunityFixup"     #lvs1974
git_pull "CPUFriend"                #PMheart
git_pull "EnableLidWake"            #syscl
git_pull "HibernationFixup"         #lvs1974
git_pull "IntelGraphicsDVMTFixup"   #BarbaraPalvin
git_pull "Lilu"
git_pull "NightShiftUnlocker"       #Austere-J
git_pull "NoTouchID"                #al3xtjames
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

print_group "goodwin"
git_pull "HWPEnable"

print_group "piker_alpha"
git_pull "AppleIntelInfo"
git_pull "csrstat"
git_pull "ssdtPRGen"

print_group "uefi"
git_pull "edk2" "77ca824c652443bdf3edaa0bb109fd8225a71cd3"  #TianoCore
#git_pull "edk2" "333f32ec23ddf87530aff58a10430871e5bea6e9"
#git_pull "edk2" "3f34e36d04a8de4992a696f738643b5a11261469"
#git_pull "edk2" "13e3f8c03339ebc8cd25c454fca1abde098fe7ed"
#git_pull "edk2" "0c9f2cb10b7ddec56a3440e77219fd3ab1725e5c"
#svn_update "edk2"
svn_update "edk2/Clover"                                    #CloverTeam
git_pull "edk2/AptioFixPkg"                                 #acidanthera
git_pull "edk2/ApfsSupportPkg"                              #savvas, acidanthera
# UEFI useful packages
git_pull "edk2/CupertinoModulePkg"                          #CupertinoNet
git_pull "edk2/EfiMiscPkg"                                  #CupertinoNet
git_pull "edk2/EfiPkg"                                      #CupertinoNet
