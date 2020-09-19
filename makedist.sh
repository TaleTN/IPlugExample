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
	xcodebuild -configuration Release ndebug=NDEBUG -target $target clean install || exit
done
