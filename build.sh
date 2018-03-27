#!/bin/bash

SELF_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_PATH="$SELF_PATH/SourceCode"

xcode_installed="false"
if [ "$1" == "clean" ]; then
    echo "Start cleaning"
    build_cmd="clean"
else
    build_cmd="build"
fi

# xcode_build
# args: <project> <target> <release/debug> optional: <plugin> <force>
# plugin - display project as a plugin of parent project
# force - setup project SDK to last version. It helps build old projects
function xcode_build()
{
    if [ ! -f "$SOURCE_PATH/$1" ]; then
        return 1
    fi

    if [ "$4" != "plugin" ]; then
        echo "🔹 $(tput bold)$2$(tput sgr0) ($3)"
    else
        echo "    ➕ $(tput bold)$2$(tput sgr0) ($3)"
    fi

    if [ "$xcode_installed" == "false" ]; then
        echo "Skipping..."
        return 1
    fi

    if [ "$4" == "force" ] || [ "$5" == "force" ]; then
        xcodebuild -project "$SOURCE_PATH/$1"  -target "$2" -configuration "$3" -sdk macosx -quiet $build_cmd
    else
        xcodebuild -project "$SOURCE_PATH/$1"  -target "$2" -configuration "$3" -quiet $build_cmd
    fi
}

# xcode_build2
# args: <project> <target> <release/debug> optional: <plugin> <force>
# plugin - display project as a plugin of parent project
# force - setup project SDK to last version. It helps build old projects
# note: call for Lilu based projects
function xcode_build2()
{
    if [ ! -f "$SOURCE_PATH/$1" ]; then
        return 1
    fi

    if [ "$build_cmd" != "clean" ]; then
        cp -R "$SOURCE_PATH/Lilu/build/Debug/Lilu.kext" "$SOURCE_PATH/$2/"
    else
        rm -R "$SOURCE_PATH/$2/Lilu.kext"
        #rm -R "$SOURCE_PATH/$2/build/Release/*.zip"
    fi
    xcode_build "$1" "$2" "$3" "$4" "$5"
}

# xcode_build3
# args: <workspace> <scheme> <release/debug> optional: <plugin> <force>
# plugin - display workspace as a plugin of parent workspace. Useless?
# force - setup workspace SDK to last version. It helps build old workspaces
# note: call for Lilu based projects
function xcode_build3()
{
    if [ ! -f "$SOURCE_PATH/$1" ]; then
        return 1
    fi

    if [ "$4" != "plugin" ]; then
        echo "🔹 $(tput bold)$2$(tput sgr0) ($3)"
    else
        echo "    ➕ $(tput bold)$2$(tput sgr0) ($3)"
    fi

    if [ "$xcode_installed" == "false" ]; then
        echo "Skipping..."
        return 1
    fi

    if [ "$4" == "force" ] || [ "$5" == "force" ]; then
        xcodebuild -workspace "$SOURCE_PATH/$1"  -scheme "$2" -configuration "$3" -sdk macosx -quiet $build_cmd
    else
        xcodebuild -workspace "$SOURCE_PATH/$1"  -scheme "$2" -configuration "$3" -quiet $build_cmd
    fi
}

# make_build
# args: <makefile> optional: <string>
function make_build()
{
    if [ ! -d "$SOURCE_PATH/$1" ]; then
        return 1
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
}

# qt_build
# args: <pro file> <string>
function qt_build()
{
    if [ ! -f "$SOURCE_PATH/$1" ]; then
        return 1
    fi

    echo "🔹 $(tput bold)$2$(tput sgr0)"

    if [ "$qmake_found" == "false" ]; then
        echo "Skipping..."
        return 1
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
}

# edk2_build
# args: <package> <toolchain> <debug/release> <string>
function edk2_build()
{
    if [ ! -f "$1" ]; then
        return 1
    fi

    echo "🔹 $(tput bold)$(basename "$1" | cut -d. -f1)$(tput sgr0) (X64, $1)"
    if [ "$build_cmd" != "clean" ]; then
        build -a X64 -p "$1" -t "$2" -b "$3" >/dev/null | grep -e "error|warning"
    else
        build clean -a X64 -p "$1" -t "$2" -b "$3" >/dev/null | grep -e "error|warning"
    fi  
}

# gcc_build
# args: <folder> optional: <string>
function gcc_build()
{
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

make_build "$1" # SOURCE_PATH not needed here!
}

# print
# args: <string> <debug/release>
function print()
{
    echo "🔹 $(tput bold)$1$(tput sgr0) (X64, $2)" 
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

# Check NASM by vit9696
NASMVER="2.13.02"
if [ "$(nasm -v | grep Apple)" != "" ]; then
    echo "3. nasm: Installing..."
    unzip -q "nasm-${NASMVER}-macosx.zip" "nasm-${NASMVER}/nasm" "nasm-${NASMVER}/ndisasm" || exit 1
    sudo mkdir -p /usr/local/bin || exit 1
    sudo mv "nasm-${NASMVER}/nasm" /usr/local/bin/ || exit 1
    sudo mv "nasm-${NASMVER}/ndisasm" /usr/local/bin/ || exit 1
    rm -rf "nasm-${NASMVER}-macosx.zip" "nasm-${NASMVER}"
else
    echo "3. nasm: Installed"
fi

# Check MTOCK by vit9696
if [ "$(which mtoc.NEW)" == "" ] || [ "$(which mtoc)" == "" ]; then
    echo "4. mtoc: Installing..."
    rm -f mtoc mtoc.NEW
    unzip -q edk2/AptioFixPkg/external/mtoc-mac64.zip mtoc mtoc.NEW || exit 1
    sudo mkdir -p /usr/local/bin || exit 1
    sudo mv mtoc /usr/local/bin/ || exit 1
    sudo mv mtoc.NEW /usr/local/bin/ || exit 1
else
    echo "4. mtoc: Installed"
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
    echo "5. qmake: Not Installed, skipping Qt apps building..."
else
    echo "5. qmake: Installed"
    qmake=$QMAKEPATH
fi

echo -e "\n# $build_cmd ACPI Component Architecture"
make_build acpica "ACPICA"
# Copy iasl
mkdir -p "$SOURCE_PATH/MaciASL/build/Release/MaciASL.app/Contents/MacOS"
cp "$SOURCE_PATH/ACPICA/generate/unix/bin/iasl" "$SOURCE_PATH/MaciASL/iasl4"
cp "$SOURCE_PATH/ACPICA/generate/unix/bin/iasl" "$SOURCE_PATH/MaciASL/iasl61"

echo -e "\n# $build_cmd Kozlek kexts"
xcode_build3 "HWSensors/HWSensors.xcworkspace" "Build Kexts" Release
xcode_build3 "HWSensors/HWSensors.xcworkspace" "HWMonitor" Release
xcode_build3 "HWSensors/HWSensors.xcworkspace" "org.hwsensors.HWMonitorHelper" Release

echo -e "\n# $build_cmd Mieze kexts"
if [[ ${OSTYPE:6} -lt 16 ]]; then # if [macOS < 10.12]; then
    xcode_build "AtherosE2200Ethernet/AtherosE2200Ethernet.xcodeproj" "AtherosE2200Ethernet" Release
else
    xcode_build "AtherosE2200Ethernet/AtherosE2200Ethernet.xcodeproj" "AtherosE2200EthernetV2" Release
fi

xcode_build "IntelMausiEthernet/IntelMausiEthernet.xcodeproj" "IntelMausiEthernet" Release
xcode_build "Realtek RTL8100/RealtekRTL8100.xcodeproj" "RealtekRTL8100" Release

if [[ ${OSTYPE:6} -lt 16 ]]; then # if [macOS < 10.12]; then
    xcode_build "Realtek RTL8111/RealtekRTL8111.xcodeproj" "RealtekRTL8111" Release
else
    xcode_build "Realtek RTL8111/RealtekRTL8111.xcodeproj" "RealtekRTL8111-V2" Release
fi

echo -e "\n# $build_cmd RehabMan kexts and tools"
xcode_build "ACPI Battery Driver/ACPIBatteryManager.xcodeproj" "ACPIBatteryManager" Release force
xcode_build "ACPI Debug/ACPIDebug.xcodeproj" "ACPIDebug" Release force
xcode_build "ACPI Keyboard/ACPIKeyboard.xcodeproj" "ACPIKeyboard" Release force
xcode_build "EAPD Codec Commander/CodecCommander.xcodeproj" "CodecCommander" Release force

if [[ ${OSTYPE:6} -lt 15 ]]; then # if [macOS < 10.11]; then
    xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmPatchRAM" Release force
else
    xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmPatchRAM2" Release force
fi

xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmFirmwareData" Release plugin force
xcode_build "BrcmPatchRAM/BrcmPatchRAM.xcodeproj" "BrcmFirmwareRepo" Release plugin force

if [[ ${OSTYPE:6} -lt 15 ]]; then # if [macOS < 10.11]; then
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
xcode_build "MaciASL/MaciASL.xcodeproj" "MaciASL" Release force
xcode_build "USBInjectAll/USBInjectAll.xcodeproj" "USBInjectAll" Release force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Controller" Release force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Keyboard" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Mouse" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Trackpad" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2Daemon" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "VoodooPS2synapticsPane" Release plugin force
xcode_build "VoodooPS2/VoodooPS2Controller.xcodeproj" "synapticsconfigload" Release plugin force

echo -e "\n# $build_cmd Slice kexts"
xcode_build "VoodooHDA/tranc/VoodooHDA.xcodeproj" "VoodooHDA" Release force
xcode_build "VoodooHDA/VHDAPrefPane/VoodooHDA/VoodooHDA.xcodeproj" "VoodooHDA" Release force
xcode_build "VoodooHDA/VoodooHdaSettingsLoader/src/VoodooHdaSettingsLoader.xcodeproj" "VoodooHdaSettingsLoader" Release force

echo -e "\n# $build_cmd vit9696 kexts and plugins"
xcode_build "Lilu/Lilu.xcodeproj" "Lilu" Debug
xcode_build "Lilu/Lilu.xcodeproj" "Lilu" Release

xcode_build2 "AirportBrcmFixup/AirportBrcmFixup.xcodeproj" "AirportBrcmFixup" Release plugin                    #lvs1974
xcode_build2 "AppleALC/AppleALC.xcodeproj" "AppleALC" Release plugin
xcode_build2 "ATH9KFixup/ATH9KFixup.xcodeproj" "ATH9KFixup" Release plugin                                      #chunnann
xcode_build2 "AzulPatcher4600/AzulPatcher4600.xcodeproj" "AzulPatcher4600" Release plugin                       #coderobe
xcode_build2 "BT4LEContiunityFixup/BT4LEContiunityFixup.xcodeproj" "BT4LEContiunityFixup" Release plugin        #lvs1974
xcode_build2 "CoreDisplayFixup/CoreDisplayFixup.xcodeproj" "CoreDisplayFixup" Release plugin                    #PMheart
xcode_build2 "CPUFriend/CPUFriend.xcodeproj" "CPUFriend" Release plugin                                         #PMheart
xcode_build2 "EnableLidWake/EnableLidWake.xcodeproj" "EnableLidWake" Release plugin                             #syscl
xcode_build2 "HibernationFixup/HibernationFixup.xcodeproj" "HibernationFixup" Release plugin                    #lvs1974
xcode_build2 "IntelGraphicsDVMTFixup/IntelGraphicsDVMTFixup.xcodeproj" "IntelGraphicsDVMTFixup" Release plugin  #lvs1974
xcode_build2 "IntelGraphicsFixup/IntelGraphicsFixup.xcodeproj" "IntelGraphicsFixup" Release plugin              #lvs1974
xcode_build2 "NightShiftUnlocker/NightShiftUnlocker.xcodeproj" "NightShiftUnlocker" Release plugin              #Austere-J
xcode_build2 "NvidiaGraphicsFixup/NvidiaGraphicsFixup.xcodeproj" "NvidiaGraphicsFixup" Release plugin           #lvs1974
xcode_build2 "Shiki/Shiki.xcodeproj" "Shiki" Release plugin
xcode_build2 "WhateverGreen/WhateverGreen.xcodeproj" "WhateverGreen" Release plugin

echo -e "\n# $build_cmd vulgo tools"
xcode_build "bootoption/bootoption.xcodeproj" "bootoption" Release

echo -e "\n# $build_cmd alexandred kexts"
xcode_build "VoodooI2C/Dependencies/VoodooGPIO/VoodooGPIO.xcodeproj" "VoodooGPIO" Release plugin force
xcode_build "VoodooI2C/Dependencies/VoodooI2CServices/VoodooI2CServices.xcodeproj" "VoodooI2CServices" Release plugin force
#
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine/VoodooI2CUPDDEngine.xcodeproj" "VoodooI2CUPDDEngine" Release plugin force
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN/VoodooI2CELAN.xcodeproj" "VoodooI2CELAN" Release plugin force
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID/VoodooI2CHID.xcodeproj" "VoodooI2CHID" Release plugin force
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics/VoodooI2CSynaptics.xcodeproj" "VoodooI2CSynaptics" Release plugin force
#
# Copy kexts
mkdir -p "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release"
if [ "$build_cmd" != "clean" ]; then
    cp -R "$SOURCE_PATH/VoodooI2C/Dependencies/VoodooGPIO/build/Release/VoodooGPIO.kext" "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release/"
    cp -R "$SOURCE_PATH/VoodooI2C/Dependencies/VoodooI2CServices/build/Release/VoodooI2CServices.kext" "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release/"
fi
#
xcode_build "VoodooI2C/VoodooI2C/VoodooI2C.xcodeproj" "VoodooI2C" Release force

echo -e "\n# $build_cmd Piker-Alpha kexts and tools"
xcode_build "AppleIntelInfo/AppleIntelInfo.xcodeproj" "AppleIntelInfo" Release
gcc_build "csrstat"

echo -e "\n# $build_cmd denskop forks"
qt_build "Universal IFR Extractor/Qt/Universal_IFR_Extractor.pro" "Universal IFR Extractor"

echo -e "\n# $build_cmd LongSoft tools"
qt_build "UEFITool/uefitool.pro" "UEFITool"
#qt_build "UEFIExtract/uefiextract.pro" "UEFIExtract"
#qt_build "UEFIFind/uefifind.pro" "UEFIFind"
qt_build "UEFITool(NE)/UEFITool/uefitool.pro" "UEFITool(NE)"

echo -e "\n# $build_cmd UEFI projects"

# Setup EDK2
make_build "edk2/BaseTools" "edk2 BaseTools"

pushd "$SOURCE_PATH/edk2" >/dev/null

source "edksetup.sh"

# Build AptioFixPkg
edk2_build "AptioFixPkg/AptioFixPkg.dsc" XCODE5 RELEASE

# Build Clover
print "Clover EFI Bootloader" "RELEASE"
cp -R Clover/Patches_for_EDK2/* .
if [ "$build_cmd" != "clean" ]; then
    ./Clover/ebuild.sh -fr -x64 >/dev/null | grep -e "error|warning"
else
    ./Clover/ebuild.sh clean >/dev/null | grep -e "error|warning"
fi
popd >/dev/null
