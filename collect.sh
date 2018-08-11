#!/bin/bash

SELF_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_PATH="$SELF_PATH/SourceCode"
COLLECT_PATH="$SELF_PATH/Collection"

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

# print
# args: <string> optional: <plugin>
function print()
{
    check_in_blacklist "$1"
    if [ "$?" == "1" ]; then
        return "1"
    fi
    if [ "$2" != "plugin" ]; then
        echo "🔹 $(tput bold)$1$(tput sgr0)"
    else
        echo "    ➕ $(tput bold)$1$(tput sgr0)"
    fi
    return "0"
}

# print_group
# args: <group>
function print_group()
{
    if [ "$1" == "acpica" ]; then
        array=("ACPICA")
        title="\n# Collect ACPI Component Architecture tools"
    elif [ "$1" == "corpnewt" ]; then
        array=("NullCPUPowerManagement")
        title="\n# Collect corpnewt forks"
    elif [ "$1" == "denskop" ]; then
        array=("Universal IFR Extractor" \
               "VoodooTSCSync")
        title="\n# Collect denskop forks"
    elif [ "$1" == "kozlek" ]; then
        array=("HWSensors")
        title="\n# Collect Kozlek kexts"
    elif [ "$1" == "kxproject" ]; then
        array=("kXAudioDriver")
        title="\n# Collect kxproject kexts"
    elif [ "$1" == "longsoft" ]; then
        array=("UEFITool" \
               "UEFITool_NE" \
               "UEFIExtract" \
               "UEFIFind" \
               "UEFIPatch" \
               "UEFIReplace")
        title="\n# Collect LongSoft tools"
    elif [ "$1" == "vulgo" ]; then
        array=("bootoption")
        title="\n# Collect vulgo tools"
    elif [ "$1" == "mieze" ]; then
        array=("AtherosE2200Ethernet" \
               "IntelMausiEthernet" \
               "Realtek RTL8100" \
               "Realtek RTL8111")
        title="\n# Collect Mieze kexts"
    elif [ "$1" == "rehabman" ]; then
        array=("EAPD Codec Commander" \
               "ACPI Battery Driver" \
               "ACPI Debug" \
               "ACPI Keyboard" \
               "BrcmPatchRAM" \
               "FakePCIID" \
               "USBInjectAll" \
               "VoodooPS2")
        title="\n# Collect RehabMan kexts and tools"
    elif [ "$1" == "slice" ]; then
        array=("VoodooHDA")
        title="\n# Collect Slice kexts"
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
        title="\n# Collect acidanthera kexts and plugins"
    elif [ "$1" == "alexandred" ]; then
        array=("VoodooI2C" \
               "VoodooI2CELAN" \
               "VoodooI2CHID" \
               "VoodooI2CSynaptics" \
               "VoodooI2CUPDDEngine" \
               "VoodooI2C ACPI Patches")
        title="\n# Collect alexandred kexts"
    elif [ "$1" == "goodwin" ]; then
        array=("HWPEnable")
        title="\n# Collect goodwin kexts"
    elif [ "$1" == "piker_alpha" ]; then
        array=("AppleIntelInfo" \
               "csrstat" \
               "ssdtPRGen")
        title="\n# Collect Piker-Alpha kexts and tools"
    elif [ "$1" == "uefi" ]; then
        array=("Clover" \
               "AptioFixPkg")
        title="\n# Collect UEFI projects"
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

# Check blacklist file
if [ -f "$SELF_PATH/$blacklist_file" ]; then
    echo "Blacklist file: Exist"
    blacklist_file_exist="true"
else
    echo "Blacklist file: Not exist"
fi

# Cleanup collect folder
if [ -d "$COLLECT_PAT" ]; then
    rm -R "$COLLECT_PATH"
fi

print_group "acpica"
#
print "ACPICA"
if [ "$?" == "0" ]; then
    #
    mkdir -p "$COLLECT_PATH/Tools/ACPICA/Misc"
    cp -R "$SOURCE_PATH/ACPICA/generate/unix/bin/" "$COLLECT_PATH/Tools/ACPICA/Misc/"
    mv "$COLLECT_PATH/Tools/ACPICA/Misc/iasl" "$COLLECT_PATH/Tools/ACPICA/"
    cp -R "$SOURCE_PATH/ACPICA/documents/aslcompiler.pdf" "$COLLECT_PATH/Tools/ACPICA/"
fi

print_group "corpnewt"
#
print "NullCPUPowerManagement"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/CPU"
    cp -R "$SOURCE_PATH/NullCPUPowerManagement/build/Release/NullCPUPowerManagement.kext" "$COLLECT_PATH/CPU/"
fi

print_group "denskop"
#
print "Universal IFR Extractor"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Tools"
    cp -R "$SOURCE_PATH/Universal IFR Extractor/Qt/Universal IFR Extractor.app" "$COLLECT_PATH/Tools/"
fi

print "VoodooTSCSync"
if [ "$?" == "0" ]; then
    # Cleaning
    rm -rf "$COLLECT_PATH/CPU/AMD"
    rm -rf "$COLLECT_PATH/CPU/Intel"

    mkdir -p "$COLLECT_PATH/CPU/AMD"
    mkdir -p "$COLLECT_PATH/CPU/Intel/VoodooTSCSync"

    # Intel
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSync.kext" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync2TH.kext"
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSync.kext" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync4TH.kext"
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSync.kext" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync6TH.kext"
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSync.kext" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync8TH.kext"
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSync.kext" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync12TH.kext"

    # Patch plists
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:VoodooTSCSync:IOPropertyMatch:IOCPUNumber 3" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync4TH.kext/Contents/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:VoodooTSCSync:IOPropertyMatch:IOCPUNumber 5" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync6TH.kext/Contents/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:VoodooTSCSync:IOPropertyMatch:IOCPUNumber 7" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync8TH.kext/Contents/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:VoodooTSCSync:IOPropertyMatch:IOCPUNumber 11" "$COLLECT_PATH/CPU/Intel/VoodooTSCSync/VoodooTSCSync12TH.kext/Contents/Info.plist"

    # AMD
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSyncAMD.kext" "$COLLECT_PATH/CPU/AMD/VoodooTSCSyncAMD2Cores.kext"
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSyncAMD.kext" "$COLLECT_PATH/CPU/AMD/VoodooTSCSyncAMD4Cores.kext"
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSyncAMD.kext" "$COLLECT_PATH/CPU/AMD/VoodooTSCSyncAMD6Cores.kext"
    cp -R "$SOURCE_PATH/VoodooTSCSync/build/Release/VoodooTSCSyncAMD.kext" "$COLLECT_PATH/CPU/AMD/VoodooTSCSyncAMD8Cores.kext"

    # Patch plists
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:VoodooTSCSyncAMD:IOPropertyMatch:IOCPUNumber 3" "$COLLECT_PATH/CPU/AMD/VoodooTSCSyncAMD4Cores.kext/Contents/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:VoodooTSCSyncAMD:IOPropertyMatch:IOCPUNumber 5" "$COLLECT_PATH/CPU/AMD/VoodooTSCSyncAMD6Cores.kext/Contents/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :IOKitPersonalities:VoodooTSCSyncAMD:IOPropertyMatch:IOCPUNumber 7" "$COLLECT_PATH/CPU/AMD/VoodooTSCSyncAMD8Cores.kext/Contents/Info.plist"
fi

print_group "kozlek"
#
print "HWSensors"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/FakeSMC"
    rm -f -R "$COLLECT_PATH/FakeSMC/HWMonitor.app" # To avoid framework overwrite problems
    cp -R "$SOURCE_PATH/HWSensors/Binaries/" "$COLLECT_PATH/FakeSMC/"
    rm -f -R "$COLLECT_PATH/FakeSMC/org.hwsensors.HWMonitorHelper" # This is part of HWMonitor.app
fi

print_group "kxproject"
#
print "kXAudioDriver"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Sound"
    cp -R "$SOURCE_PATH/kXAudioDriver/macosx/build/Deployment/kXAudioDriver.kext" "$COLLECT_PATH/Sound/"
fi

print_group "longsoft"
#
print "UEFITool"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Tools/UEFITool"
    cp -R "$SOURCE_PATH/UEFITool/UEFITool.app" "$COLLECT_PATH/Tools/UEFITool/UEFITool.app"
    #
    cp -R "$SOURCE_PATH/UEFITool/UEFIPatch/UEFIPatch" "$COLLECT_PATH/Tools/UEFITool/UEFIPatch"
    cp -R "$SOURCE_PATH/UEFITool/UEFIReplace/UEFIReplace" "$COLLECT_PATH/Tools/UEFITool/UEFIReplace"
fi
#
print "UEFITool_NE"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Tools/UEFITool"
    cp -R "$SOURCE_PATH/UEFITool_NE/UEFITool/UEFITool.app" "$COLLECT_PATH/Tools/UEFITool/UEFITool_NE.app"
    #
    cp -R "$SOURCE_PATH/UEFITool_NE/UEFIExtract/UEFIExtract" "$COLLECT_PATH/Tools/UEFITool/UEFIExtract"
    cp -R "$SOURCE_PATH/UEFITool_NE/UEFIFind/UEFIFind" "$COLLECT_PATH/Tools/UEFITool/UEFIFind"
fi

print_group "mieze"
#
print "AtherosE2200Ethernet"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/LAN"
    cp -R "$SOURCE_PATH/AtherosE2200Ethernet/build/Release/AtherosE2200Ethernet.kext" "$COLLECT_PATH/LAN/"
fi
#
print "IntelMausiEthernet"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/LAN"
    cp -R "$SOURCE_PATH/IntelMausiEthernet/build/Release/IntelMausiEthernet.kext" "$COLLECT_PATH/LAN/"
fi
#
print "Realtek RTL8100"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/LAN"
    cp -R "$SOURCE_PATH/Realtek RTL8100/build/Release/RealtekRTL8100.kext" "$COLLECT_PATH/LAN/"
fi
#
print "Realtek RTL8111"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/LAN"
    cp -R "$SOURCE_PATH/Realtek RTL8111/build/Release/RealtekRTL8111.kext" "$COLLECT_PATH/LAN/"
fi

print_group "rehabman"
#
print "EAPD Codec Commander"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Sound/CodecCommander"
    cp -R "$SOURCE_PATH/EAPD Codec Commander/build/Products/Release/CodecCommander.kext" "$COLLECT_PATH/Sound/CodecCommander/"
    cp -R "$SOURCE_PATH/EAPD Codec Commander/build/Products/Release/CodecCommanderClient" "$COLLECT_PATH/Sound/CodecCommander/"
fi
#
print "ACPI Battery Driver"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop"
    cp -R "$SOURCE_PATH/ACPI Battery Driver/build/Products/Release/ACPIBatteryManager.kext" "$COLLECT_PATH/Laptop/"
fi
#
print "ACPI Debug"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Debug"
    cp -R "$SOURCE_PATH/ACPI Debug/build/Products/Release/ACPIDebug.kext" "$COLLECT_PATH/Debug/"
fi
#
print "ACPI Keyboard"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop"
    cp -R "$SOURCE_PATH/ACPI Keyboard/build/Products/Release/ACPIKeyboard.kext" "$COLLECT_PATH/Laptop/"
fi
#
print "BrcmPatchRAM"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Bluetooth/BrcmPatchRAM"
    cp -R "$SOURCE_PATH/BrcmPatchRAM/build/Products/Release/" "$COLLECT_PATH/Bluetooth/BrcmPatchRAM/"
fi
#
print "FakePCIID"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/FakePCIID"
    cp -R "$SOURCE_PATH/FakePCIID/build/Release/" "$COLLECT_PATH/FakePCIID/"
fi
#
print "USBInjectAll"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/USB/USBInjectAll"
    cp -R "$SOURCE_PATH/USBInjectAll/build/Products/Release/USBInjectAll.kext" "$COLLECT_PATH/USB/USBInjectAll/"
    cp -R "$SOURCE_PATH/USBInjectAll/config_patches.plist" "$COLLECT_PATH/USB/USBInjectAll/"
    cp -R "$SOURCE_PATH/USBInjectAll/SSDT-UIAC-ALL.dsl" "$COLLECT_PATH/USB/USBInjectAll/"
fi
#
print "VoodooPS2"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop/VoodooPS2"
    cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/VoodooPS2Controller.kext" "$COLLECT_PATH/Laptop/VoodooPS2/"
    cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/VoodooPS2Daemon" "$COLLECT_PATH/Laptop/VoodooPS2/"
    cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/VoodooPS2synapticsPane.prefPane" "$COLLECT_PATH/Laptop/VoodooPS2/"
    cp -R "$SOURCE_PATH/VoodooPS2/build/Products/Release/synapticsconfigload" "$COLLECT_PATH/Laptop/VoodooPS2/"
fi

print_group "slice"
#
print "VoodooHDA"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Sound/VoodooHDA"
    cp -R "$SOURCE_PATH/VoodooHDA/tranc/build/Release/VoodooHDA.kext" "$COLLECT_PATH/Sound/VoodooHDA"
    cp -R "$SOURCE_PATH/VoodooHDA/VoodooHdaSettingsLoader/src/build/Release/VoodooHdaSettingsLoader.app" "$COLLECT_PATH/Sound/VoodooHDA"
    cp -R "$SOURCE_PATH/VoodooHDA/VHDAPrefPane/VoodooHDA/build/Release/VoodooHDA.prefPane" "$COLLECT_PATH/Sound/VoodooHDA"
fi


print_group "acidanthera"
#
print "AirportBrcmFixup"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/AirportBrcmFixup/build/Release/AirportBrcmFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "AppleALC"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/AppleALC/build/Release/AppleALC.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "ATH9KFixup"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/ATH9KFixup/build/Release/ATH9KFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "AzulPatcher4600"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/AzulPatcher4600/build/Release/AzulPatcher4600.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "BT4LEContiunityFixup"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/BT4LEContiunityFixup/build/Release/BT4LEContiunityFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "CPUFriend"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/CPUFriend/build/Release/CPUFriend.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "EnableLidWake"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/EnableLidWake/build/Release/EnableLidWake.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "HibernationFixup"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/HibernationFixup/build/Release/HibernationFixup.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "Lilu"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/Lilu/build/Release/Lilu.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "NightShiftUnlocker"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/NightShiftUnlocker/build/Release/NightShiftUnlocker.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "NoTouchID"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/NoTouchID/build/Release/NoTouchID.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "WhateverGreen"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Lilu+Plugins"
    cp -R "$SOURCE_PATH/WhateverGreen/build/Release/WhateverGreen.kext" "$COLLECT_PATH/Lilu+Plugins"
fi
#
print "MaciASL"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Tools"
    cp -R "$SOURCE_PATH/MaciASL/build/Release/MaciASL.app" "$COLLECT_PATH/Tools/"
fi

print_group "vulgo"
#
print "bootoption"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Tools"
    cp -R "$SOURCE_PATH/bootoption/build/Release/bootoption" "$COLLECT_PATH/Tools/"
fi

print_group "alexandred"
#
print "VoodooI2C"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C/build/Release/VoodooI2C.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
fi
#
print "VoodooI2CELAN"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CELAN/build/Release/VoodooI2CELAN.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
fi
#
print "VoodooI2CHID"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CHID/build/Release/VoodooI2CHID.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
fi
#
print "VoodooI2CSynaptics"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CSynaptics/build/Release/VoodooI2CSynaptics.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
fi
#
print "VoodooI2CUPDDEngine"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C Satellites/VoodooI2CUPDDEngine/build/Release/VoodooI2CUPDDEngine.kext" "$COLLECT_PATH/Laptop/VoodooI2C"
fi
#
print "VoodooI2C ACPI Patches"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C ACPI Patches/Controllers" "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches/"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C ACPI Patches/GPIO" "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches/"
    cp -R "$SOURCE_PATH/VoodooI2C/VoodooI2C ACPI Patches/Windows" "$COLLECT_PATH/Laptop/VoodooI2C/ACPI Patches/"
fi

print_group "goodwin"
#
print "HWPEnable"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/CPU/Intel/HWPEnable"
    cp -R "$SOURCE_PATH/HWPEnable/build/Release/HWPEnabler.kext" "$COLLECT_PATH/CPU/Intel/HWPEnable"
    cp -R "$SOURCE_PATH/HWPEnable/build/Release/hwpenabler" "$COLLECT_PATH/CPU/Intel/HWPEnable"
fi

print_group "piker_alpha"
#
print "AppleIntelInfo"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Debug"
    cp -R "$SOURCE_PATH/AppleIntelInfo/build/Release/AppleIntelInfo.kext" "$COLLECT_PATH/Debug"
fi
#
print "csrstat"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Tools"
    cp -R "$SOURCE_PATH/csrstat/out" "$COLLECT_PATH/Tools/csrstat"
fi
#
print "ssdtPRGen"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/Tools"
    cp -R "$SOURCE_PATH/ssdtPRGen/ssdtPRGen.sh" "$COLLECT_PATH/Tools/"
fi


print_group "uefi"

print "ApfsSupportPkg"
if [ "$?" != "1" ]; then
    mkdir -p "$COLLECT_PATH/UEFI/Drivers"
    cp "$SOURCE_PATH/edk2/Build/ApfsSupportPkg/RELEASE_XCODE5/X64/ApfsDriverLoader.efi" "$COLLECT_PATH/UEFI/Drivers/ApfsDriverLoader-64.efi"
fi

print "AptioFixPkg"
if [ "$?" != "1" ]; then
    mkdir -p "$COLLECT_PATH/UEFI/Drivers"
    mkdir -p "$COLLECT_PATH/UEFI/Tools"

    cp "$SOURCE_PATH/edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/AptioMemoryFix.efi" "$COLLECT_PATH/UEFI/Drivers/AptioMemoryFix-64.efi"
    cp "$SOURCE_PATH/edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/AptioInputFix.efi" "$COLLECT_PATH/UEFI/Drivers/AptioInputFix-64.efi"

    # tools
    cp "$SOURCE_PATH/edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/CleanNvram.efi" "$COLLECT_PATH/UEFI/Tools/CleanNvram-64.efi"
    cp "$SOURCE_PATH/edk2/Build/AptioFixPkg/RELEASE_XCODE5/X64/VerifyMsrE2.efi" "$COLLECT_PATH/UEFI/Tools/VerifyMsrE2-64.efi"
fi

print "Clover"
if [ "$?" == "0" ]; then
    mkdir -p "$COLLECT_PATH/UEFI/BOOT"
    mkdir -p "$COLLECT_PATH/UEFI/Debug"
    mkdir -p "$COLLECT_PATH/UEFI/Drivers"
    mkdir -p "$COLLECT_PATH/UEFI/Tools"

    # bootloader
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/CLOVER.efi" "$COLLECT_PATH/UEFI/BOOT/BOOTX64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/CLOVER.efi" "$COLLECT_PATH/UEFI/CLOVERX64.efi"

    # drivers
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/DataHubDxe.efi" "$COLLECT_PATH/UEFI/Drivers/DataHubDxe-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/AppleImageCodec.efi" "$COLLECT_PATH/UEFI/Drivers/AppleImageCodec-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/AppleKeyAggregator.efi" "$COLLECT_PATH/UEFI/Drivers/AppleKeyAggregator-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/AppleUITheme.efi" "$COLLECT_PATH/UEFI/Drivers/AppleUITheme-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/EmuVariableUefi.efi" "$COLLECT_PATH/UEFI/Drivers/EmuVariableUefi-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/Fat.efi" "$COLLECT_PATH/UEFI/Drivers/Fat-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/FirmwareVolume.efi" "$COLLECT_PATH/UEFI/Drivers/FirmwareVolume-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/FSInject.efi" "$COLLECT_PATH/UEFI/Drivers/FSInject-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/OsxAptioFix2Drv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxAptioFix2Drv-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/OsxAptioFix3Drv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxAptioFix3Drv-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/OsxAptioFixDrv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxAptioFixDrv-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/OsxFatBinaryDrv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxFatBinaryDrv-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/OsxLowMemFixDrv.efi" "$COLLECT_PATH/UEFI/Drivers/OsxLowMemFixDrv-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/PartitionDxe.efi" "$COLLECT_PATH/UEFI/Drivers/PartitionDxe-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/SMCHelper.efi" "$COLLECT_PATH/UEFI/Drivers/SMCHelper-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/VBoxHfs.efi" "$COLLECT_PATH/UEFI/Drivers/VBoxHfs-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/CsmVideoDxe.efi" "$COLLECT_PATH/UEFI/Drivers/CsmVideoDxe-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/UsbKbDxe.efi" "$COLLECT_PATH/UEFI/Drivers/UsbKbDxe-64.efi"
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/UsbMouseDxe.efi" "$COLLECT_PATH/UEFI/Drivers/UsbMouseDxe-64.efi"

    # additinal drivers
    cp "$SOURCE_PATH/edk2/Build/Clover/RELEASE_XCODE8/X64/DumpUefiCalls.efi" "$COLLECT_PATH/UEFI/Debug/DumpUefiCalls-64.efi"

    # tools
    cp "$SOURCE_PATH/edk2/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "$COLLECT_PATH/UEFI/Tools/Shell_Full-64.efi"
    cp "$SOURCE_PATH/edk2/EdkShellBinPkg/MinimumShell/X64/Shell.efi" "$COLLECT_PATH/UEFI/Tools/Shell_Minimum-64.efi"
fi
