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

rm -rf ~/"Library/Audio/Plug-Ins/Components/$bundle.component/" || exit
rm -rf ~/"Library/Audio/Plug-Ins/VST/$bundle.vst/" || exit

xcodebuild clean || exit

for target in AU VST2; do
	xcodebuild -configuration Release ndebug=NDEBUG GCC_WARN_ABOUT_DEPRECATED_FUNCTIONS=NO -target $target install || exit
done
