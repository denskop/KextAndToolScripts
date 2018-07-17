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

# git_clone
# args: <url> <folder> optional: <branch>
function git_clone()
{
    check_in_blacklist "$(basename "$2")"
    if [ "$?" == "1" ]; then
        rm -rf "$SOURCE_PATH/$2"
        return "1"
    fi
    echo "🔸 $(tput bold)$(basename "$2")$(tput sgr0):"

    if [ -d "$SOURCE_PATH/$2" ]; then
        if [ "$(ls "$SOURCE_PATH/$2")" == "" ]; then
            rm -rf "$SOURCE_PATH/$2"
        else
            echo "Already cloned."
            return "0"
        fi
    fi

    echo -e "\033[0;32m########################\033[0m"
    if [ -z "$3" ]; then
        git clone "$1" "$SOURCE_PATH/$2"
    else
        git clone "$1" "$SOURCE_PATH/$2" -b "$3"
    fi
    echo -e "\033[0;32m########################\033[0m"

    return "0"
}

# git_checkout
# args: <url> <folder> <sha>
function git_checkout()
{
    git_clone "$1" "$2"
    if [ "$?" == "1" ]; then
        rm -rf "$2"
        return "1"
    fi

    result="$(git -C "$SOURCE_PATH/$2" checkout "$3" 2>&1 >/dev/null)"
    #echo "$result"
    return "0"
}

# svn_co
# args: <url> <folder>
function svn_co()
{
    check_in_blacklist "$(basename "$2")"
    if [ "$?" == "1" ]; then
        rm -rf "$SOURCE_PATH/$2"
        return "1"
    fi
    echo "🔸 $(tput bold)$(basename "$2")$(tput sgr0):"

    if [ -d "$SOURCE_PATH/$2" ]; then
        if [ "$(ls "$SOURCE_PATH/$2")" == "" ]; then
            rm -rf "$SOURCE_PATH/$2"
        else
            echo "Already cloned."
            return "0"
        fi
    fi

    echo -e "\033[0;32m########################\033[0m"
    svn checkout "$1" "$SOURCE_PATH/$2"
    echo -e "\033[0;32m########################\033[0m"
}

# print_group
# args: <group>
function print_group()
{
    if [ "$1" == "acpica" ]; then
        array=("ACPICA")
        title="\n# Clone ACPI Component Architecture tools"
    elif [ "$1" == "kozlek" ]; then
        array=("HWSensors")
        title="\n# Clone Kozlek kexts"
    elif [ "$1" == "kxproject" ]; then
        array=("kXAudioDriver")
        title="\n# Clone kxproject kexts"
    elif [ "$1" == "corpnewt" ]; then
        array=("NullCPUPowerManagement")
        title="\n# Clone corpnewt forks"
    elif [ "$1" == "denskop" ]; then
        array=("Universal IFR Extractor" \
               "VoodooTSCSync")
        title="\n# Clone denskop forks"
    elif [ "$1" == "longsoft" ]; then
        array=("UEFITool" \
               "UEFITool_NE")
        title="\n# Clone LongSoft tools"
    elif [ "$1" == "vulgo" ]; then
        array=("bootoption")
        title="\n# Clone vulgo tools"
    elif [ "$1" == "mieze" ]; then
        array=("AtherosE2200Ethernet" \
               "IntelMausiEthernet" \
               "Realtek RTL8100" \
               "Realtek RTL8111")
        title="\n# Clone Mieze kexts"
    elif [ "$1" == "rehabman" ]; then
        array=("EAPD Codec Commander" \
               "ACPI Battery Driver" \
               "ACPI Debug" \
               "ACPI Keyboard" \
               "BrcmPatchRAM" \
               "FakePCIID" \
               "MaciASL" \
               "USBInjectAll" \
               "VoodooPS2") \
        title="\n# Clone RehabMan kexts and tools"
    elif [ "$1" == "slice" ]; then
        array=("VoodooHDA")
        title="\n# Clone Slice kexts"
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
               "Lilu" \
               "NightShiftUnlocker" \
               "NoTouchID" \
               "WhateverGreen")
        title="\n# Clone vit9696 kexts and plugins"
    elif [ "$1" == "alexandred" ]; then
        array=("VoodooI2C" \
               "VoodooGPIO" \
               "VoodooI2CELAN" \
               "VoodooI2CHID" \
               "VoodooI2CSynaptics" \
               "VoodooI2CUPDDEngine" \
               "VoodooI2C ACPI Patches")
        title="\n# Clone alexandred kexts"
    elif [ "$1" == "piker_alpha" ]; then
        array=("AppleIntelInfo" \
               "csrstat" \
               "ssdtPRGen")
        title="\n# Clone Piker-Alpha kexts and tools"
    elif [ "$1" == "uefi" ]; then
        array=("edk2" \
               "Clover" \
               "CupertinoModulePkg" \
               "EfiMiscPkg" \
               "EfiPkg" \
               "AptioFixPkg" \
               "ApfsSupportPkg")
        title="\n# Clone UEFI projects"
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
git_clone https://github.com/acpica/acpica.git "ACPICA"

print_group "corpnewt"
git_clone https://github.com/corpnewt/NullCPUPowerManagement.git "NullCPUPowerManagement"

print_group "denskop"
git_clone https://github.com/denskop/Universal-IFR-Extractor.git "Universal IFR Extractor"
git_clone https://github.com/denskop/VoodooTSCSync.git "VoodooTSCSync"

print_group "kozlek"
git_clone https://github.com/kozlek/HWSensors.git "HWSensors"

print_group "kxproject"
git_clone https://github.com/kxproject/kx-audio-driver.git "kXAudioDriver"

print_group "longsoft"
git_clone https://github.com/LongSoft/UEFITool.git "UEFITool"
git_clone https://github.com/LongSoft/UEFITool.git "UEFITool_NE" new_engine

print_group "mieze"
git_clone https://github.com/Mieze/AtherosE2200Ethernet.git "AtherosE2200Ethernet"
git_clone https://github.com/Mieze/IntelMausiEthernet.git "IntelMausiEthernet"
git_clone https://github.com/Mieze/RealtekRTL8100.git "Realtek RTL8100"
git_clone https://github.com/Mieze/RTL8111_driver_for_OS_X.git "Realtek RTL8111"

print_group "rehabman"
git_clone https://github.com/RehabMan/EAPD-Codec-Commander.git "EAPD Codec Commander"
git_clone https://github.com/RehabMan/OS-X-ACPI-Battery-Driver.git "ACPI Battery Driver"
git_clone https://github.com/RehabMan/OS-X-ACPI-Debug.git "ACPI Debug"
git_clone https://github.com/RehabMan/OS-X-ACPI-Keyboard.git "ACPI Keyboard"
git_clone https://github.com/RehabMan/OS-X-BrcmPatchRAM.git "BrcmPatchRAM"
git_clone https://github.com/RehabMan/OS-X-Fake-PCI-ID.git "FakePCIID"
git_clone https://github.com/RehabMan/OS-X-MaciASL-patchmatic.git "MaciASL"
git_clone https://github.com/RehabMan/OS-X-USB-Inject-All.git "USBInjectAll"
git_clone https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller.git "VoodooPS2"

print_group "slice"
svn_co https://svn.code.sf.net/p/voodoohda/code "VoodooHDA"

print_group "vit9696"
git_clone https://github.com/lvs1974/AirportBrcmFixup.git "AirportBrcmFixup"                    #lvs1974
git_clone https://github.com/vit9696/AppleALC.git "AppleALC"
git_clone https://github.com/chunnann/ATH9KFixup.git "ATH9KFixup"                               #chunnann
git_clone https://github.com/coderobe/AzulPatcher4600.git "AzulPatcher4600"                     #coderobe
git_clone https://github.com/lvs1974/BT4LEContiunityFixup.git "BT4LEContiunityFixup"            #lvs1974
git_clone https://github.com/PMheart/CoreDisplayFixup.git "CoreDisplayFixup"                    #PMheart
git_clone https://github.com/PMheart/CPUFriend.git "CPUFriend"                                  #PMheart
git_clone https://github.com/syscl/EnableLidWake.git "EnableLidWake"                            #syscl
git_clone https://github.com/lvs1974/HibernationFixup.git "HibernationFixup"                    #lvs1974
git_clone https://github.com/BarbaraPalvin/IntelGraphicsDVMTFixup.git "IntelGraphicsDVMTFixup"  #BarbaraPalvin
git_clone https://github.com/vit9696/Lilu.git "Lilu"
git_clone https://github.com/Austere-J/NightShiftUnlocker.git "NightShiftUnlocker"              #Austere-J
git_clone https://github.com/al3xtjames/NoTouchID.git "NoTouchID"                               #al3xtjames
git_clone https://github.com/vit9696/WhateverGreen.git "WhateverGreen"

print_group "vulgo"
git_clone https://github.com/vulgo/bootoption.git "bootoption"

print_group "alexandred"
git_clone https://github.com/alexandred/VoodooI2C.git "VoodooI2C"

# Dependencies
git_clone https://github.com/coolstar/VoodooGPIO.git "VoodooI2C/Dependencies/VoodooGPIO"

# Satellites
git_clone https://github.com/kprinssu/VoodooI2CELAN.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN"
git_clone https://github.com/alexandred/VoodooI2CHID.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID"
git_clone https://github.com/alexandred/VoodooI2CSynaptics.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics"
git_clone https://github.com/blankmac/VoodooI2CUPDDEngine.git "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine"

# Patches
git_clone https://github.com/alexandred/VoodooI2C-Patches.git "VoodooI2C/VoodooI2C ACPI Patches"

print_group "piker_alpha"
git_clone https://github.com/Piker-Alpha/AppleIntelInfo.git "AppleIntelInfo"
git_clone https://github.com/Piker-Alpha/csrstat.git "csrstat"
git_clone https://github.com/Piker-Alpha/ssdtPRGen.sh.git "ssdtPRGen"

print_group "uefi"
git_checkout https://github.com/tianocore/edk2.git "edk2" "77ca824c652443bdf3edaa0bb109fd8225a71cd3"    #TianoCore
#git_checkout https://github.com/tianocore/edk2.git "edk2" "333f32ec23ddf87530aff58a10430871e5bea6e9"
#git_checkout https://github.com/tianocore/edk2.git "edk2" "3f34e36d04a8de4992a696f738643b5a11261469"
#git_checkout https://github.com/tianocore/edk2.git "edk2" "13e3f8c03339ebc8cd25c454fca1abde098fe7ed"
#git_checkout https://github.com/tianocore/edk2.git "edk2" "0c9f2cb10b7ddec56a3440e77219fd3ab1725e5c"
#git_clone https://git.code.sf.net/p/tianocore/edk2 "edk2"
#
svn_co https://svn.code.sf.net/p/cloverefiboot/code "edk2/Clover"                                       #CloverTeam
# UEFI useful packages
git_clone https://github.com/CupertinoNet/CupertinoModulePkg "edk2/CupertinoModulePkg"                  #CupertinoNet
git_clone https://github.com/CupertinoNet/EfiMiscPkg "edk2/EfiMiscPkg"                                  #CupertinoNet
git_clone https://github.com/CupertinoNet/EfiPkg "edk2/EfiPkg"                                          #CupertinoNet
#
git_clone https://github.com/vit9696/AptioFixPkg.git "edk2/AptioFixPkg"                                 #vit9696
git_clone https://github.com/acidanthera/ApfsSupportPkg.git "edk2/ApfsSupportPkg"                       #savvas, vit9696

echo -e "\n# Check and Download missing tools"

# Check NASM by vit9696
NASMVER="2.13.02"
if [ "$(nasm -v | grep Apple)" != "" ]; then
    echo "1. nasm - $(tput bold)FAILED$(tput sgr0)"
    rm -rf "$SELF_PATH/nasm-${NASMVER}-macosx.zip" "$SELF_PATH/nasm-${NASMVER}"
    curl -o "$SELF_PATH/nasm-${NASMVER}-macosx.zip" "https://www.nasm.us/pub/nasm/releasebuilds/${NASMVER}/macosx/nasm-${NASMVER}-macosx.zip" || exit 1
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
qmake_found="false"

if [ -f "$SELF_PATH/.qmake_path" ]; then
    source "$SELF_PATH/.qmake_path"
    #echo "qmake path: $QMAKEPATH"
    qmake_found="true"
fi

# Bad qmake location
if [ ! -f "$QMAKEPATH" ]; then
    rm -rf "$SELF_PATH/.qmake_path"
    qmake_found="false"
fi

# Find in typical locations
if [ "$qmake_found" == "false" ]; then
    # default style
    qmake_candidates=($(find "$HOME/Qt" -name "qmake" -type f 2>/dev/null))

    # brew style
    qmake_candidates+=($(find "/usr/local/Cellar/qt" -name "qmake" -type f 2>/dev/null))

    # user style
    qmake_candidates+=($(find "/Applications/Qt" -name "qmake" -type f 2>/dev/null))
    qmake_candidates+=($(find "/Applications/Qt5" -name "qmake" -type f 2>/dev/null))
fi

# Check potential qmakes
for candidate in "${qmake_candidates[@]}"; do
    if [ "$($candidate 2>&1 | grep "Usage: ")" ]; then
        echo "QMAKEPATH="$candidate"" > "$SELF_PATH/.qmake_path"
        QMAKEPATH=$candidate
        qmake_found="true"
        break
    fi
done

if [ "$qmake_found" == "true" ]; then
    echo "3. qmake - $(tput bold)PASSED$(tput sgr0). Found at: $QMAKEPATH"
else
    echo "3. qmake - $(tput bold)FAILED$(tput sgr0)."
    if [ "$(brew -v 2>&1 | grep Homebrew)" == "" ]; then
        echo -e "\nInstalling Homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        echo -e "\nInstalling Qt5..."
        brew install qt5
        echo "QMAKEPATH="/usr/local/Cellar/qt"" > "$SELF_PATH/.qmake_path"
    fi
fi
