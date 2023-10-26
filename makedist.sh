#!/bin/bash

bundle=IPlugExample

if [ $# -eq 1 ] && [ "$1" == "--clean" ]
then
	rm -rf build
	exit
fi

if [ $# -ne 0 ]
then
	echo "Usage: $0 [--clean]"
	exit 1
fi

aaxplugin=/Library/Application\ Support/Avid/Audio/Plug-Ins/$bundle.aaxplugin

sudo rm -rf "$aaxplugin/" || exit
rm -rf ~/"Library/Audio/Plug-Ins/Components/$bundle.component/" || exit
rm -rf ~/"Library/Audio/Plug-Ins/CLAP/$bundle.clap/" || exit
rm -rf ~/"Library/Audio/Plug-Ins/VST/$bundle.vst/" || exit
rm -rf ~/"Library/Audio/Plug-Ins/VST3/$bundle.vst3/" || exit

xcodebuild clean || exit

for target in AAX AU CLAP VST2 VST3
do
	xcodebuild -configuration Release ndebug=NDEBUG GCC_WARN_ABOUT_DEPRECATED_FUNCTIONS=NO -target $target install || exit
done

# /Applications/PACEAntiPiracy/Eden/Fusion/Current/bin/wraptool sign --customernumber MYCU-STOM-ERNU-MBER --customername "Tale" --productname "IPlug Example" --signid "9ca1bf1665add1b51891e59b1746d9ec67106e12" --dsigharden --dsig1-compat off --verbose --in "$aaxplugin" --out "$aaxplugin" || exit
