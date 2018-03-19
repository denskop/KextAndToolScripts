#!/bin/bash

SELF_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

qmake=/Applications/Qt/5.9.2/clang_64/bin/qmake

if [ "$1" == "clean" ]; then
    echo "Start cleaning"
    build_cmd="clean"
else
	build_cmd="build"
fi

function xcode_build()
{
    if [ "$4" != "plugin" ]; then
    	echo "🔹 $(tput bold)$2$(tput sgr0) ($3)"
    else
        echo "    ➕ $(tput bold)$2$(tput sgr0) ($3)"
    fi

    if [ "$4" == "force" ] || [ "$5" == "force" ]; then
    	xcodebuild -project "$1"  -target "$2" -configuration "$3" -sdk macosx -quiet $build_cmd
    else
        xcodebuild -project "$1"  -target "$2" -configuration "$3" -quiet $build_cmd
    fi
}

function xcode_build2()
{
	if [ "$build_cmd" != "clean" ]; then
    	cp -R Lilu/build/Debug/Lilu.kext $2/
    else
    	rm -R $2/Lilu.kext
       #rm -R $2/build/Release/*.zip
    fi
    xcode_build "$1" "$2" "$3" "$4" "$5"
}

function xcode_build3()
{
    if [ "$4" != "plugin" ]; then
        echo "🔹 $(tput bold)$2$(tput sgr0) ($3)"
    else
        echo "    ➕ $(tput bold)$2$(tput sgr0) ($3)"
    fi

    if [ "$4" == "force" ] || [ "$5" == "force" ]; then
        xcodebuild -workspace "$1"  -scheme "$2" -configuration "$3" -sdk macosx -quiet $build_cmd
    else
        xcodebuild -workspace "$1"  -scheme "$2" -configuration "$3" -quiet $build_cmd
    fi
}

function make_build()
{
    if [ -z "$2" ]; then
    	echo "🔹 $(tput bold)$1$(tput sgr0)"
    else
        echo "🔹 $(tput bold)$2$(tput sgr0)"
    fi

    if [ "$build_cmd" != "clean" ]; then
    	make -C "$1" >/dev/null | grep -e "error|warning"
    else
    	make -C "$1" clean >/dev/null | grep -e "error|warning"
    fi 
}

function qt_build()
{
    echo "🔹 $(tput bold)$1$(tput sgr0)"
    cd $1

    if [ "$build_cmd" != "clean" ]; then
    	$qmake "$2" >/dev/null | grep -e "error|warning"
    	make >/dev/null | grep -e "error|warning"
	else
		make clean >/dev/null | grep -e "error|warning"
	fi
    cd ..
}

function edk2_build()
{
    echo "🔹 $(tput bold)$4$(tput sgr0) (X64, $1)"
    if [ "$build_cmd" != "clean" ]; then
        build -a X64 -b "$1" -t "$2" -p "$3" >/dev/null | grep -e "error|warning"
    else
        build clean -a X64 -b "$1" -t "$2" -p "$3" >/dev/null | grep -e "error|warning"
    fi  
}

function print()
{
    echo "🔹 $(tput bold)$1$(tput sgr0) (X64, $2)" 
}

echo -e "\n# $build_cmd ACPI Component Architecture"
make_build acpica "ACPICA"
# Copy iasl
mkdir -p "OS-X-MaciASL-patchmatic/build/Release/MaciASL.app/Contents/MacOS"
cp "acpica/generate/unix/bin/iasl" "OS-X-MaciASL-patchmatic/iasl4"
cp "acpica/generate/unix/bin/iasl" "OS-X-MaciASL-patchmatic/iasl61"

echo -e "\n# $build_cmd Kozlek kexts"
xcode_build3 HWSensors/HWSensors.xcworkspace "Build Kexts" Release
xcode_build3 HWSensors/HWSensors.xcworkspace "HWMonitor" Release
xcode_build3 HWSensors/HWSensors.xcworkspace "org.hwsensors.HWMonitorHelper" Release

echo -e "\n# $build_cmd Mieze kexts"
if [[ ${OSTYPE:6} -le 16 ]]; then # if [macOS < 10.12]; then
    xcode_build AtherosE2200Ethernet/AtherosE2200Ethernet.xcodeproj AtherosE2200Ethernet Release
else
    xcode_build AtherosE2200Ethernet/AtherosE2200Ethernet.xcodeproj AtherosE2200EthernetV2 Release
fi

xcode_build IntelMausiEthernet/IntelMausiEthernet.xcodeproj IntelMausiEthernet Release
xcode_build RealtekRTL8100/RealtekRTL8100.xcodeproj RealtekRTL8100 Release

if [[ ${OSTYPE:6} -le 16 ]]; then # if [macOS < 10.12]; then
    xcode_build RTL8111_driver_for_OS_X/RealtekRTL8111.xcodeproj RealtekRTL8111 Release
else
    xcode_build RTL8111_driver_for_OS_X/RealtekRTL8111.xcodeproj RealtekRTL8111-V2 Release
fi

echo -e "\n# $build_cmd RehabMan kexts and tools"
xcode_build OS-X-ACPI-Battery-Driver/ACPIBatteryManager.xcodeproj ACPIBatteryManager Release force
xcode_build OS-X-ACPI-Debug/ACPIDebug.xcodeproj ACPIDebug Release force
xcode_build OS-X-ACPI-Keyboard/ACPIKeyboard.xcodeproj ACPIKeyboard Release force
xcode_build EAPD-Codec-Commander/CodecCommander.xcodeproj CodecCommander Release force

if [[ ${OSTYPE:6} -le 15 ]]; then # if [macOS < 10.11]; then
    xcode_build OS-X-BrcmPatchRAM/BrcmPatchRAM.xcodeproj BrcmPatchRAM Release force
else
    xcode_build OS-X-BrcmPatchRAM/BrcmPatchRAM.xcodeproj BrcmPatchRAM2 Release force
fi

xcode_build OS-X-BrcmPatchRAM/BrcmPatchRAM.xcodeproj BrcmFirmwareData Release plugin force
xcode_build OS-X-BrcmPatchRAM/BrcmPatchRAM.xcodeproj BrcmFirmwareRepo Release plugin force

if [[ ${OSTYPE:6} -le 15 ]]; then # if [macOS < 10.11]; then
    xcode_build OS-X-BrcmPatchRAM/BrcmPatchRAM.xcodeproj BrcmNonPatchRAM Release plugin force
else
    xcode_build OS-X-BrcmPatchRAM/BrcmPatchRAM.xcodeproj BrcmNonPatchRAM2 Release plugin force
fi

xcode_build OS-X-BrcmPatchRAM/BrcmPatchRAM.xcodeproj BrcmBluetoothInjector Release plugin force

xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID Release force
xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID_Intel_HD_Graphics Release plugin force
xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID_Intel_HDMI_Audio Release plugin force
xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID_AR9280_as_AR946x Release plugin force
xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID_Broadcom_WiFi Release plugin force
xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID_BCM57XX_as_BCM57765 Release plugin force
xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID_Intel_GbX Release plugin force
xcode_build OS-X-Fake-PCI-ID/FakePCIID.xcodeproj FakePCIID_XHCIMux Release plugin force
#
xcode_build OS-X-MaciASL-patchmatic/MaciASL.xcodeproj MaciASL Release force

echo -e "\n# $build_cmd Slice kexts"
xcode_build VoodooHDA/tranc/VoodooHDA.xcodeproj VoodooHDA Release force
xcode_build VoodooHDA/VHDAPrefPane/VoodooHDA/VoodooHDA.xcodeproj VoodooHDA Release force
xcode_build VoodooHDA/VoodooHdaSettingsLoader/src/VoodooHdaSettingsLoader.xcodeproj VoodooHdaSettingsLoader Release force

echo -e "\n# $build_cmd vit9696 kexts and plugins"
xcode_build Lilu/Lilu.xcodeproj Lilu Debug
xcode_build Lilu/Lilu.xcodeproj Lilu Release

xcode_build2 AirportBrcmFixup/AirportBrcmFixup.xcodeproj	AirportBrcmFixup Release plugin                #lvs1974
xcode_build2 AppleALC/AppleALC.xcodeproj AppleALC Release plugin
xcode_build2 ATH9KFixup/ATH9KFixup.xcodeproj ATH9KFixup Release plugin 									   #chunnann
xcode_build2 AzulPatcher4600/AzulPatcher4600.xcodeproj AzulPatcher4600 Release plugin                      #coderobe
xcode_build2 BT4LEContiunityFixup/BT4LEContiunityFixup.xcodeproj	BT4LEContiunityFixup Release plugin	   #lvs1974
xcode_build2 CoreDisplayFixup/CoreDisplayFixup.xcodeproj	CoreDisplayFixup Release plugin			       #PMheart
xcode_build2 CPUFriend/CPUFriend.xcodeproj CPUFriend Release plugin	 					                   #PMheart
xcode_build2 EnableLidWake/EnableLidWake.xcodeproj EnableLidWake Release plugin					           #syscl
xcode_build2 HibernationFixup/HibernationFixup.xcodeproj HibernationFixup Release plugin			       #lvs1974	
xcode_build2 IntelGraphicsFixup/IntelGraphicsFixup.xcodeproj IntelGraphicsFixup Release plugin			   #lvs1974
xcode_build2 NvidiaGraphicsFixup/NvidiaGraphicsFixup.xcodeproj NvidiaGraphicsFixup Release plugin		   #lvs1974
xcode_build2 Shiki/Shiki.xcodeproj Shiki Release plugin
xcode_build2 WhateverGreen/WhateverGreen.xcodeproj WhateverGreen Release plugin

echo -e "\n# $build_cmd alexandred kexts"
xcode_build "VoodooI2C/Dependencies/VoodooGPIO/VoodooGPIO.xcodeproj" VoodooGPIO Release plugin force
xcode_build "VoodooI2C/Dependencies/VoodooI2CServices/VoodooI2CServices.xcodeproj" VoodooI2CServices Release plugin force
#
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine/VoodooI2CUPDDEngine.xcodeproj" VoodooI2CUPDDEngine Release plugin force
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN/VoodooI2CELAN.xcodeproj" VoodooI2CELAN Release plugin force
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CHID/VoodooI2CHID.xcodeproj" VoodooI2CHID Release plugin force
xcode_build "VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics/VoodooI2CSynaptics.xcodeproj" VoodooI2CSynaptics Release plugin force
#
# Copy kexts
mkdir -p "VoodooI2C/VoodooI2C/build/Release"
if [ "$build_cmd" != "clean" ]; then
    cp -R "VoodooI2C/Dependencies/VoodooGPIO/build/Release/VoodooGPIO.kext"  "VoodooI2C/VoodooI2C/build/Release/"
    cp -R "VoodooI2C/Dependencies/VoodooI2CServices/build/Release/VoodooI2CServices.kext"  "VoodooI2C/VoodooI2C/build/Release/"
fi
#
xcode_build "VoodooI2C/VoodooI2C/VoodooI2C.xcodeproj" VoodooI2C Release force

echo -e "\n# $build_cmd Piker-Alpha kexts and tools"
xcode_build "AppleIntelInfo/AppleIntelInfo.xcodeproj" AppleIntelInfo Release

echo -e "\n# $build_cmd LongSoft tools"
qt_build UEFITool uefitool.pro
#qt_build UEFITool_NE UEFIExtract/uefiextract.pro
#qt_build UEFITool_NE UEFIFind/uefifind.pro
qt_build "UEFITool(NE)" UEFITool/uefitool.pro

echo -e "\n# $build_cmd UEFI projects"
# Setup EDK2
cd edk2
make_build BaseTools "EDK2 BaseTools"
source edksetup.sh 

# Build AptioFixPkg
edk2_build RELEASE XCODE5 AptioFixPkg/AptioFixPkg.dsc "AptioFixPkg"

# Build Clover
print "Clover EFI Bootloader" "RELEASE"
cp -R Clover/Patches_for_EDK2/* .
if [ "$build_cmd" != "clean" ]; then
    ./Clover/ebuild.sh -fr -x64 >/dev/null | grep -e "error|warning"
else
    ./Clover/ebuild.sh clean >/dev/null | grep -e "error|warning"
fi
