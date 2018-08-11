#!/bin/bash

SELF_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_PATH="$SELF_PATH/SourceCode"
HELPERS_PATH="$SELF_PATH/Helpers"

xcode_installed="false"
if [ "$1" == "clean" ]; then
    echo "Start cleaning"
    build_cmd="clean"
else
    build_cmd="build"
fi

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

# xcode_build
# args: <project> <target> <release/debug> optional: <plugin> <force>
# plugin - display project as a plugin of parent project
# force - setup project SDK to last version. It helps build old projects
function xcode_build()
{
    check_in_blacklist "$(basename "$(dirname "$1")")"
    if [ "$?" == "1" ]; then
        return "1"
    else
        check_in_blacklist "${1%%/*}"
        if [ "$?" == "1" ]; then
            return "1"
        fi
    fi

    if [ "$4" != "plugin" ]; then
        echo "🔹 $(tput bold)$2$(tput sgr0) ($3)"
    else
        echo "    ➕ $(tput bold)$2$(tput sgr0) ($3)"
    fi

    if [ "$xcode_installed" == "false" ]; then
        echo "Skipping..."
        return "1"
    fi

    # try to patch
    if [ "$build_cmd" != "clean" ]; then
        patch "$1"
    fi

    target="$(xcodebuild -project "$SOURCE_PATH/$1" -showBuildSettings | grep "MACOSX_DEPLOYMENT_TARGET = ")"
    target_ver=${target##*.}
    if [ "$target_ver" == "" ]; then
        target="$(xcodebuild -project "$SOURCE_PATH/$1" -showBuildSettings | grep "SDKROOT = ")"
        target_ver=${target##*.}
    fi
    lib_path="$HELPERS_PATH/SDK-10.$target_ver/"

    if [ "$4" == "force" ] || [ "$5" == "force" ]; then
        xcodebuild -project "$SOURCE_PATH/$1"  -target "$2" -configuration "$3" -sdk macosx LIBRARY_SEARCH_PATHS="$lib_path" -quiet $build_cmd
    else
        xcodebuild -project "$SOURCE_PATH/$1"  -target "$2" -configuration "$3" LIBRARY_SEARCH_PATHS="$lib_path" -quiet $build_cmd
    fi
    return "0"
}

# xcode_build2
# args: <project> <target> <release/debug> optional: <plugin> <force>
# plugin - display project as a plugin of parent project
# force - setup project SDK to last version. It helps build old projects
# note: call for Lilu based projects
function xcode_build2()
{
    check_in_blacklist "$(basename "$(dirname "$1")")"
    if [ "$?" == "1" ]; then
        return "1"
    fi

    if [ "$build_cmd" != "clean" ]; then
        cp -R "$SOURCE_PATH/Lilu/build/Debug/Lilu.kext" "$SOURCE_PATH/$2/"
    else
        rm -R "$SOURCE_PATH/$2/Lilu.kext"
        #rm -R "$SOURCE_PATH/$2/build/Release/*.zip"
    fi
    xcode_build "$1" "$2" "$3" "$4" "$5"
    return "$?"
}

# xcode_build3
# args: <workspace> <scheme> <release/debug> optional: <plugin> <force>
# plugin - display workspace as a plugin of parent workspace. Useless?
# force - setup workspace SDK to last version. It helps build old workspaces
# note: call for Lilu based projects
function xcode_build3()
{
    check_in_blacklist "$(basename "$(dirname "$1")")"
    if [ "$?" == "1" ]; then
        return "1"
    fi

    if [ "$4" != "plugin" ]; then
        echo "🔹 $(tput bold)$2$(tput sgr0) ($3)"
    else
        echo "    ➕ $(tput bold)$2$(tput sgr0) ($3)"
    fi

    if [ "$xcode_installed" == "false" ]; then
        echo "Skipping..."
        return "1"
    fi

    # try to patch
    if [ "$build_cmd" != "clean" ]; then
        patch "$1"
    fi

    target="$(xcodebuild -workspace "$SOURCE_PATH/$1" -scheme "$2" -showBuildSettings | grep "MACOSX_DEPLOYMENT_TARGET = ")"
    target_ver=${target##*.}

    if [ "$target_ver" == "" ]; then
        target="$(xcodebuild -workspace "$SOURCE_PATH/$1" -scheme "$2" -showBuildSettings | grep "SDKROOT = ")"
        target_ver=${target##*.}
    fi
    lib_path="$HELPERS_PATH/SDK-10.$target_ver/"

    if [ "$4" == "force" ] || [ "$5" == "force" ]; then
        xcodebuild -workspace "$SOURCE_PATH/$1"  -scheme "$2" -configuration "$3" -sdk macosx LIBRARY_SEARCH_PATHS="$lib_path" -quiet $build_cmd
    else
        xcodebuild -workspace "$SOURCE_PATH/$1"  -scheme "$2" -configuration "$3" LIBRARY_SEARCH_PATHS="$lib_path" -quiet $build_cmd
    fi
    return "0"
}

# make_build
# args: <makefile> optional: <string>
function make_build()
{
    check_in_blacklist "$(basename "$2")"
    if [ "$?" == "1" ]; then
        return "1"
    fi

    if [ -z "$2" ]; then
        echo "🔹 $(tput bold)$1$(tput sgr0)"
    else
        echo "🔹 $(tput bold)$2$(tput sgr0)"
    fi
    
    if [ "$build_cmd" != "clean" ]; then
        make -C "$SOURCE_PATH/$1" >/dev/null | grep -e "error|warning"
    else
        make -C "$SOURCE_PATH/$1" clean >/dev/null | grep -e "error|warning"
    fi
    return "0"
}

# qt_build
# args: <pro file> <string>
function qt_build()
{
    check_in_blacklist "$2"
    if [ "$?" == "1" ]; then
        return "1"
    fi

    echo "🔹 $(tput bold)$2$(tput sgr0)"

    if [ "$qmake_found" == "false" ]; then
        echo "Skipping..."
        return "1"
    fi

    # try to patch
    if [ "$build_cmd" != "clean" ]; then
        patch "$1"
    fi

    path=$(dirname "$SOURCE_PATH/$1}")
    name=$(basename "$1")
    pushd "$path" >/dev/null

    if [ "$build_cmd" != "clean" ]; then
        $qmake "$name" >/dev/null | grep -e "error|warning"
        make >/dev/null | grep -e "error|warning"
    else
        make clean >/dev/null | grep -e "error|warning"
    fi
    popd >/dev/null
    return "0"
}

# edk2_build
# args: <package> <toolchain> <debug/release> <string>
function edk2_build()
{
    check_in_blacklist "$(basename "$(dirname "$1")")"
    if [ "$?" == "1" ]; then
        return "1"
    fi

    echo "🔹 $(tput bold)$(basename "$1" | cut -d. -f1)$(tput sgr0) (X64, $1)"
    if [ "$build_cmd" != "clean" ]; then
        build -a X64 -p "$1" -t "$2" -b "$3" >/dev/null | grep -e "error|warning"
    else
        build clean -a X64 -p "$1" -t "$2" -b "$3" >/dev/null | grep -e "error|warning"
    fi
    return "0"
}

# cmake_build
# args: <folder> optional: <string>
function cmake_build()
{
    if [ -z "$2" ]; then
        check_in_blacklist "$(basename "$1")"
    else
        check_in_blacklist "$2"
    fi

    if [ "$?" == "1" ]; then
        return "1"
    fi

    if [ -z "$2" ]; then
        echo "🔹 $(tput bold)$1$(tput sgr0)"
    else
        echo "🔹 $(tput bold)$2$(tput sgr0)"
    fi

    if [ "$cmake_found" == "false" ]; then
        echo "Skipping..."
        return "1"
    fi

    pushd "$SOURCE_PATH/$1" >/dev/null

    cmake .
    make

    popd >/dev/null
    return "0"
}


# gcc_build
# args: <folder> optional: <string>
function gcc_build()
{
check_in_blacklist "$(basename "$1")"
if [ "$?" == "1" ]; then
    return "1"
fi

cat << "EOT" > "$SOURCE_PATH/$1/Makefile"
CC := gcc
SRCS := $(shell find . -name *.c)
OBJS := $(addsuffix .o,$(basename $(SRCS)))
all: out
out: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@
.PHONY: clean
clean:
	$(RM) out $(OBJS)
EOT

if [ -z "$2" ]; then
make_build "$1" # SOURCE_PATH not needed here!
else
make_build "$1" "$2" # SOURCE_PATH not needed here!
fi
return "$?"
}

# print
# args: <string> <debug/release>
function print()
{
    check_in_blacklist "$1"
    if [ "$?" == "1" ]; then
        return "1"
    fi
    
    echo "🔹 $(tput bold)$1$(tput sgr0) (X64, $2)"
    return "0"
}

# print_group
# args: <group>
function print_group()
{
    if [ "$1" == "acpica" ]; then
        array=("ACPICA")
        title="\n# $build_cmd ACPI Component Architecture tools"
    elif [ "$1" == "corpnewt" ]; then
        array=("NullCPUPowerManagement")
        title="\n# $build_cmd corpnewt forks"
    elif [ "$1" == "denskop" ]; then
        array=("Universal IFR Extractor" \
               "VoodooTSCSync")
        title="\n# $build_cmd denskop forks"
    elif [ "$1" == "kozlek" ]; then
        array=("HWSensors")
        title="\n# $build_cmd Kozlek kexts"
    elif [ "$1" == "kxproject" ]; then
        array=("kXAudioDriver")
        title="\n# $build_cmd kxproject kexts"
    elif [ "$1" == "longsoft" ]; then
        array=("UEFITool" \
               "UEFITool_NE" \
               "UEFIExtract" \
               "UEFIFind" \
               "UEFIPatch" \
               "UEFIReplace")
        title="\n# $build_cmd LongSoft tools"
    elif [ "$1" == "vulgo" ]; then
        array=("bootoption")
        title="\n# $build_cmd vulgo tools"
    elif [ "$1" == "mieze" ]; then
        array=("AtherosE2200Ethernet" \
               "IntelMausiEthernet" \
               "Realtek RTL8100" \
               "Realtek RTL8111")
        title="\n# $build_cmd Mieze kexts"
    elif [ "$1" == "rehabman" ]; then
        array=("EAPD Codec Commander" \
               "ACPI Battery Driver" \
               "ACPI Debug" \
               "ACPI Keyboard" \
               "BrcmPatchRAM" \
               "FakePCIID" \
               "USBInjectAll" \
               "VoodooPS2")
        title="\n# $build_cmd RehabMan kexts and tools"
    elif [ "$1" == "slice" ]; then
        array=("VoodooHDA")
        title="\n# $build_cmd Slice kexts"
    elif [ "$1" == "acidanthera" ]; then
        array=("AirportBrcmFixup" \
               "AppleALC" \
               "ATH9KFixup" \
               "AzulPatcher4600" \
               "BT4LEContiunityFixup" \
               "CPUFriend" \
               "EnableLidWake" \
               "HibernationFixup" \
               "Lilu" \
               "NightShiftUnlocker" \
               "NoTouchID" \
               "WhateverGreen" \
               "MaciASL")
        title="\n# $build_cmd acidanthera kexts and plugins"
    elif [ "$1" == "alexandred" ]; then
        array=("VoodooI2C" \
               "VoodooGPIO" \
               "VoodooI2CELAN" \
               "VoodooI2CHID" \
               "VoodooI2CSynaptics" \
               "VoodooI2CUPDDEngine" \
               "VoodooI2C ACPI Patches")
        title="\n# $build_cmd alexandred kexts"
    elif [ "$1" == "goodwin" ]; then
        array=("HWPEnable")
        title="\n# Clone goodwin kexts"
    elif [ "$1" == "piker_alpha" ]; then
        array=("AppleIntelInfo" \
               "csrstat" \
               "ssdtPRGen")
        title="\n# $build_cmd Piker-Alpha kexts and tools"
    elif [ "$1" == "uefi" ]; then
        array=("edk2" \
               "Clover" \
               "CupertinoModulePkg" \
               "EfiMiscPkg" \
               "EfiPkg" \
               "AptioFixPkg" \
               "ApfsSupportPkg")
        title="\n# $build_cmd UEFI projects"
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

echo -e "\n# Checking build tools"

# Check path
if [ "$SELF_PATH" != "$(printf "%s\n" $SELF_PATH)" ]; then
    echo "Scripts location path contains spaces, aborting..."
    exit 1
fi

# Check Command Line Tools
if [ "$(xcodebuild -v 2>&1 | grep "no developer")" != "" ]; then
    echo "1. Command Line Tools: Not Installed or Not Selected, aborting..."
    exit 1
else
    echo "1. Command Line Tools: Installed"
fi

# Check Xcode
if [ "$(xcodebuild -v 2>&1 | grep "requires Xcode")" != "" ]; then
    if [ -d "/Applications/Xcode.app" ]; then
        echo "2. Xcode: Not Selected, skipping kext building..."
    else
        echo "2. Xcode: Not Installed, skipping kext building..."
    fi
else
    echo "2. Xcode: Installed"
    xcode_installed="true"
fi

# Check NASM by acidanthera
NASMVER="2.13.02"
if [ "$(nasm -v | grep Apple)" != "" ]; then
    echo "3. nasm: Installing..."
    unzip -q "$SELF_PATH/nasm-${NASMVER}-macosx.zip" "nasm-${NASMVER}/nasm" "nasm-${NASMVER}/ndisasm" -d "$SELF_PATH" || exit 1
    sudo mkdir -p /usr/local/bin || exit 1
    sudo mv "$SELF_PATH/nasm-${NASMVER}/nasm" /usr/local/bin/ || exit 1
    sudo mv "$SELF_PATH/nasm-${NASMVER}/ndisasm" /usr/local/bin/ || exit 1
    rm -rf "$SELF_PATH/nasm-${NASMVER}-macosx.zip" "$SELF_PATH/nasm-${NASMVER}"
else
    echo "3. nasm: Installed"
fi

# Check MTOCK by acidanthera
if [ "$(which mtoc.NEW)" == "" ] || [ "$(which mtoc)" == "" ]; then
    echo "4. mtoc: Installing..."
    sudo mkdir -p /usr/local/bin || exit 1
    sudo cp "$HELPERS_PATH/mtoc/mtoc.NEW" /usr/local/bin/mtoc || exit 1
    sudo cp "$HELPERS_PATH/mtoc/mtoc.NEW" /usr/local/bin/ || exit 1
else
    echo "4. mtoc: Installed"
fi

# Check cmake
cmake_found="false"

if [ "$(which cmake)" == "" ]; then
    echo "5. cmake: Not Installed, skip building CMake-based tools..."
else
    echo "5. cmake: Installed"
    cmake_found="true"
fi

# Check qmake
qmake_found="false"

if [ -f "$SELF_PATH/.qmake_path" ]; then
    source "$SELF_PATH/.qmake_path"
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

if [ "$qmake_found" == "false" ]; then
    echo "6. qmake: Not Installed, skipping Qt apps building..."
else
    echo "6. qmake: Installed"
    qmake=$QMAKEPATH
fi

# Check blacklist file
if [ -f "$SELF_PATH/$blacklist_file" ]; then
    echo "Blacklist file: Exist"
    blacklist_file_exist="true"
else
    echo "Blacklist file: Not exist"
fi

# Detect macOS version
macos_ver=${1-:$(sw_vers -productVersion)}
minor_ver=$(echo "$macos_ver" | awk -F. '{ print $2; }')

# Patch
# args: <filename>
function patch()
{
    diffs=()
    root_folder="${1%%/*}"
    proj_folder="$(dirname "$1")"

    if [ ! -d "$HELPERS_PATH/$root_folder" ]; then
        return "0"
    fi

    diffs=($(ls "$HELPERS_PATH/$root_folder/Diff" 2>/dev/null))
    for diff in "${diffs[@]}"; do
        if [ -f "$HELPERS_PATH/$root_folder/git" ]; then
            if [ "$(ls -a "$SOURCE_PATH/$proj_folder" | grep .git)" != "" ]; then
                git -C "$SOURCE_PATH/$proj_folder" apply "$HELPERS_PATH/$root_folder/Diff/$diff" >/dev/null 2>&1
            else
                git -C "$SOURCE_PATH/$root_folder" apply "$HELPERS_PATH/$root_folder/Diff/$diff" >/dev/null 2>&1
            fi
        elif [ -f "$HELPERS_PATH/$root_folder/svn" ]; then
            if [ "$(ls -a "$SOURCE_PATH/$proj_folder" | grep .svn)" != "" ]; then
                svn patch "$HELPERS_PATH/$root_folder/Diff/$diff" "$SOURCE_PATH/$proj_folder/" >/dev/null 2>&1
            else
                svn patch "$HELPERS_PATH/$root_folder/Diff/$diff" "$SOURCE_PATH/$root_folder/" >/dev/null 2>&1
            fi
        else
            return "0"
        fi
    done

    things=($(ls "$HELPERS_PATH/$root_folder/Replace" 2>/dev/null))
    for thing in "${things[@]}"; do
        if [ ! -f "$HELPERS_PATH/$root_folder/Replace/$thing" ]; then
            cp -v -R "$HELPERS_PATH/$root_folder/Replace/$thing/." "$SOURCE_PATH/$root_folder/$thing/" >/dev/null 2>&1
        else
            cp -v "$HELPERS_PATH/$root_folder/Replace/$thing" "$SOURCE_PATH/$root_folder/" >/dev/null 2>&1
        fi
    done
    return "1"
}

print_group "acpica"
make_build acpica "ACPICA"
if [ "$?" != "1" ]; then
    mkdir -p "$SOURCE_PATH/MaciASL/build/Release/MaciASL.app/Contents/MacOS"
    cp "$SOURCE_PATH/ACPICA/generate/unix/bin/iasl" "$SOURCE_PATH/MaciASL/Dist/iasl62"
fi

print_group "corpnewt"
xcode_build "NullCPUPowerManagement/NullCPUPowerManagement.xcodeproj" "NullCPUPowerManagement" Release force

print_group "denskop"
qt_build "Universal IFR Extractor/Qt/Universal_IFR_Extractor.pro" "Universal IFR Extractor"
xcode_build "VoodooTSCSync/VoodooTSCSync.xcodeproj" "VoodooTSCSync" Release
xcode_build "VoodooTSCSync/VoodooTSCSync.xcodeproj" "VoodooTSCSyncAMD" Release

print_group "kozlek"
xcode_build3 "HWSensors/HWSensors.xcworkspace" "Build Kexts" Release
xcode_build3 "HWSensors/HWSensors.xcworkspace" "HWMonitor" Release
xcode_build3 "HWSensors/HWSensors.xcworkspace" "org.hwsensors.HWMonitorHelper" Release

print_group "kxproject"
xcode_build "kXAudioDriver/macosx/10kx driver.xcodeproj" "kXAudioDriver" Deployment

print_group "longsoft"
qt_build "UEFITool/uefitool.pro" "UEFITool"
qt_build "UEFITool/UEFIPatch/uefipatch.pro" "UEFIPatch"
qt_build "UEFITool/UEFIReplace/uefireplace.pro" "UEFIReplace"
#
qt_build "UEFITool_NE/UEFITool/uefitool.pro" "UEFITool_NE"
cmake_build "UEFITool_NE/UEFIExtract" "UEFIExtract"
cmake_build "UEFITool_NE/UEFIFind" "UEFIFind"

print_group "mieze"
if  [[ $minor_ver < 12 ]]; then # if [macOS < 10.12]; then
    xcode_build "AtherosE2200Ethernet/AtherosE2200Ethernet.xcodeproj" "AtherosE2200Ethernet" Release
else
    xcode_build "AtherosE2200Ethernet/AtherosE2200Ethernet.xcodeproj" "AtherosE2200EthernetV2" Release
fi

xcode_build "IntelMausiEthernet/IntelMausiEthernet.xcodeproj" "IntelMausiEthernet" Release
xcode_build "Realtek RTL8100/RealtekRTL8100.xcodeproj" "RealtekRTL8100" Release

if [[ $minor_ver < 12 ]]; then # if [macOS < 10.12]; then
    xcode_build "Realtek RTL8111/RealtekRTL8111.xcodeproj" "RealtekRTL8111" Release
else
    xcode_build "Realtek RTL8111/RealtekRTL8111.xcodeproj" "RealtekRTL8111-V2" Release
fi

print_group "rehabman"
xcode_build "ACPI Battery Driver/ACPIBatteryManager.xcodeproj" "ACPIBatteryManager" Release force
xcode_build "ACPI Debug/ACPIDebug.xcodeproj" "ACPIDebug" Release force
xcode_build "ACPI Keyboard/ACPIKeyboard.xcodeproj" "ACPIKeyboard" Release force
xcode_build "EAPD Codec Commander/CodecCommander.xcodeproj" "CodecCommander" Release force
xcode_build "EAPD Codec Commander/CodecCommander.xcodeproj" "CodecCommanderClient" Release force

if [[ $minor_ver < 11 ]]; then # if [macOS < 10.11]; then
    xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmPatchRAM" Release force
else
    xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmPatchRAM2" Release force
fi

xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmFirmwareData" Release plugin force
xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmFirmwareRepo" Release plugin force

if [[ $minor_ver < 11 ]]; then # if [macOS < 10.11]; then
    xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmNonPatchRAM" Release plugin force
else
    xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmNonPatchRAM2" Release plugin force
fi

xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmBluetoothInjector" Release plugin force

xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID" Release force
xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID_Intel_HD_Graphics" Release plugin force
xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID_Intel_HDMI_Audio" Release plugin force
xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID_AR9280_as_AR946x" Release plugin force
xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID_Broadcom_WiFi" Release plugin force
xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID_BCM57XX_as_BCM57765" Release plugin force
xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID_Intel_GbX" Release plugin force
xcode_build "FakePCIID/FakePCIID.xcodeproj" "FakePCIID_XHCIMux" Release plugin force
xcode_build "USBInjectAll/USBInjectAll.xcodeproj" "USBInjectAll" Release force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Controller" Release force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Keyboard" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Mouse" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Trackpad" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Daemon" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2synapticsPane" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "synapticsconfigload" Release plugin force

# requires workaround
print_group "slice"
check_in_blacklist "VoodooHDA"
if [ "$?" != "1" ]; then
    xcode_build "VoodooHDA/VHDAPrefPane/VoodooHDA/VoodooHDA.xcodeproj" "VoodooHDA" Release force
    xcode_build "VoodooHDA/tranc/VoodooHDA.xcodeproj" "VoodooHDA" Release force
    xcode_build "VoodooHDA/VoodooHdaSettingsLoader/src/VoodooHdaSettingsLoader.xcodeproj" "VoodooHdaSettingsLoader" Release force
fi

print_group "acidanthera"
xcode_build "Lilu/Lilu.xcodeproj" "Lilu" Debug
xcode_build "Lilu/Lilu.xcodeproj" "Lilu" Release

xcode_build2 "AirportBrcmFixup/AirportBrcmFixup.xcodeproj" "AirportBrcmFixup" Release plugin                    #lvs1974
xcode_build2 "AppleALC/AppleALC.xcodeproj" "AppleALC" Release plugin
xcode_build2 "ATH9KFixup/ATH9KFixup.xcodeproj" "ATH9KFixup" Release plugin                                      #chunnann
xcode_build2 "AzulPatcher4600/AzulPatcher4600.xcodeproj" "AzulPatcher4600" Release plugin                       #coderobe
xcode_build2 "BT4LEContiunityFixup/BT4LEContiunityFixup.xcodeproj" "BT4LEContiunityFixup" Release plugin        #lvs1974
xcode_build2 "CPUFriend/CPUFriend.xcodeproj" "CPUFriend" Release plugin                                         #PMheart
xcode_build2 "EnableLidWake/EnableLidWake.xcodeproj" "EnableLidWake" Release plugin                             #syscl
xcode_build2 "HibernationFixup/HibernationFixup.xcodeproj" "HibernationFixup" Release plugin                    #lvs1974
xcode_build2 "NightShiftUnlocker/NightShiftUnlocker.xcodeproj" "NightShiftUnlocker" Release plugin              #Austere-J
xcode_build2 "NoTouchID/NoTouchID.xcodeproj" "NoTouchID" Release plugin                                         #al3xtjames
xcode_build2 "WhateverGreen/WhateverGreen.xcodeproj" "WhateverGreen" Release plugin

xcode_build "MaciASL/MaciASL.xcodeproj" "MaciASL" Release

print_group "vulgo"
xcode_build "bootoption/bootoption.xcodeproj" "bootoption" Release

print_group "alexandred"
#
check_in_blacklist "VoodooGPIO"
xcode_build "VoodooI2C/Dependencies/VoodooGPIO/VoodooGPIO.xcodeproj" "VoodooGPIO" Release plugin force
xcode_build "VoodooI2C/Dependencies/VoodooI2CServices/VoodooI2CServices.xcodeproj" "VoodooI2CServices" Release plugin force
check_in_blacklist "VoodooI2CUPDDEngine"
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine/VoodooI2CUPDDEngine.xcodeproj" "VoodooI2CUPDDEngine" Release plugin force
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN/VoodooI2CELAN.xcodeproj" "VoodooI2CELAN" Release plugin force
check_in_blacklist "VoodooI2CHID"
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID/VoodooI2CHID.xcodeproj" "VoodooI2CHID" Release plugin force
check_in_blacklist "VoodooI2CSynaptics"
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics/VoodooI2CSynaptics.xcodeproj" "VoodooI2CSynaptics" Release plugin force
#
# Copy kexts
check_in_blacklist "VoodooGPIO"
check1="$?"

check_in_blacklist "VoodooI2CServices"
check2="$?"

if [ "$build_cmd" != "clean" ] && [ "$check1" != "1" ] && [ "$check2" != "1" ]; then
    mkdir -p "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release"
    cp -R "$SOURCE_PATH/VoodooI2C/Dependencies/VoodooGPIO/build/Release/VoodooGPIO.kext" "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release/"
    cp -R "$SOURCE_PATH/VoodooI2C/Dependencies/VoodooI2CServices/build/Release/VoodooI2CServices.kext" "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release/"
fi
#
xcode_build "VoodooI2C/VoodooI2C/VoodooI2C.xcodeproj" "VoodooI2C" Release force

print_group "goodwin"
xcode_build "HWPEnable/HWPEnabler.xcodeproj" "HWPEnabler" Release
# HWP check util
xcode_build "HWPEnable/HWPEnabler.xcodeproj" "hwpenabler" Release

print_group "piker_alpha"
xcode_build "AppleIntelInfo/AppleIntelInfo.xcodeproj" "AppleIntelInfo" Release
gcc_build "csrstat"

check_in_blacklist "edk2"
if [ "$?" != "1" ]; then
    print_group "uefi"
    # Setup EDK2
    make_build "edk2/BaseTools" "edk2 BaseTools"

    pushd "$SOURCE_PATH/edk2" >/dev/null
    source "edksetup.sh"

    # Patch edk2
    check_in_blacklist "Clover"
    if [ "$?" != "1" ]; then
        cp -R Clover/Patches_for_EDK2/* .
    fi

    # Build AptioFixPkg
    edk2_build "AptioFixPkg/AptioFixPkg.dsc" XCODE5 RELEASE

    # Build ApfsSupportPkg
    edk2_build "ApfsSupportPkg/ApfsSupportPkg.dsc" XCODE5 RELEASE

    # Build Clover
    check_in_blacklist "Clover"
    if [ "$?" != "1" ]; then
        print "Clover EFI Bootloader" "RELEASE"
        if [ "$build_cmd" != "clean" ]; then
            ./Clover/ebuild.sh -fr -x64 >/dev/null | grep -e "error|warning"
        else
            ./Clover/ebuild.sh clean >/dev/null | grep -e "error|warning"
        fi
    fi
    popd >/dev/null
fi
