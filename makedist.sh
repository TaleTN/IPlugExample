#!/bin/bash

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

for target in AU VST2; do
	xcodebuild -configuration Release -target $target clean || exit
done

for target in AU VST2; do
	xcodebuild -configuration Release ndebug=NDEBUG GCC_WARN_ABOUT_DEPRECATED_FUNCTIONS=NO -target $target install || exit
done
