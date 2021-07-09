IPLUG EXAMPLE

A simple tremolo audio effect plugin (AU/VST2), serving as an example for
the IPlug "Tale" edition plugin framework.

GETTING STARTED

To be able to build this example you will need the following (free) tools
and additional projects:

	1. C/C++ compiler.
	2. IPlug framework.
	3. WDL library.
	4. VST 2.4 SDK.

Note that this readme describes the toolset we actually use at Martinic. You
could probably use a different toolset, but then things will likely not work
right out of the box.

C/C++ COMPILER

For Windows we use the Microsoft Visual Studio 2019 C/C++ compiler, although
any somewhat recent Microsoft C/C++ toolset should work. You can download
the free Visual Studio 2019 Community edition via:

	https://visualstudio.microsoft.com/downloads/

For macOS you will need the Xcode 12.5 IDE. Before downloading Xcode first
sign in to Apple Developer via:

	https://developer.apple.com/account/

Then you can download Xcode 12.5 (and optionally the Additional Tools for
Xcode 12.5) via:

	https://developer.apple.com/download/all/

IPLUG FRAMEWORK

IPlug is a cross-platform VST/AU plugin framework for Windows and macOS, on
which you can build audio plug-in effects and instruments. It was originally
part of the Cockos WDL library, but it has since evolved into different forks
like IPlug "Tale" edition and WDL-OL (now iPlug2). Note that this example
will work only with IPlug "Tale" edition.

You can download IPlug "Tale" edition from:

	https://github.com/TaleTN/IPlug.git

Extract it so you have:

	IPlugExample/IPlugExample.cpp, ...
	IPlugExample/IPlug/IPlugBase.cpp, ...             <-- IPlug goes here

If you use Git, then alternatively you can add IPlug as a remote:

	1. git remote add iplug https://github.com/TaleTN/IPlug.git
	2. git fetch iplug
	3. git merge --allow-unrelated-histories iplug/master

For your own projects this is the recommended method.

WDL LIBRARY

WDL (whittle) is a C++ library, created and maintained by Cockos, and used
for REAPER. Although IPlug "Tale" edition will work fine with Cockos WDL,
using WDL "Tale" edition instead is recommended, because that is what we
use. ;-)

You can download WDL "Tale" edition from:

	https://github.com/TaleTN/WDL.git

Extract it so you have:

	IPlugExample/IPlugExample.cpp, ...
	IPlugExample/IPlug/Containers.h, ...
	IPlugExample/WDL/assocarray.h, ...                <-- WDL goes here

Alternatively you can add WDL as a remote:

	1. git remote add wdl https://github.com/TaleTN/IPlug.git
	2. git fetch wdl
	3. git merge --allow-unrelated-histories wdl/master

For your own projects this is the recommended method.

VST 2.4 SDK

You will need only two header files from the VST 2.4 SDK: aeffect.h and
aeffectx.h. Extract them and place them in VST2_SDK so you have:

	IPlugExample/IPlugExample.cpp, ...
	IPlugExample/IPlug/Containers.h, ...
	IPlugExample/WDL/assocarray.h, ...
	IPlugExample/VST2_SDK/aeffect.h, aeffectx.h       <-- VST2_SDK goes here

You will find these header files in the pluginterfaces/vst2.x/ directory
inside the VST 2.4 or VST 3 SDK, but you will need v3.6 or older. You can
download v3.6.6 here:

	https://www.steinberg.net/sdk_downloads/vstsdk366_27_06_2016_build_61.zip

HOW TO BUILD & RUN

On Windows open the IPlugExample.sln solution in Visual Studio 2019, and
build the VST 2.4 plugin DLL from within the IDE. Alternatively you can
build the DLL from the command prompt by typing:

	cd IPlugExample
	nmake

Note that building from the command prompt should work with any somewhat
recent Microsoft C/C++ toolset.

To run the plugin copy IPlugExample.dll from IPlugExample/x64/Release/ to
your VST 2.4 plugin path. Then launch your hosting software of choice (e.g.
REAPER or VSTHost), and load the IPlug Example plugin.

On macOS open the IPlugExample.xcodeproj project in Xcode 12.5, and build
the VST 2.4 and/or AU bundle from within the IDE. If you build for running,
then this will automatically copy the plugin to the user audio plugins
folder.

To run the plugin launch your hosting software of choice (e.g. REAPER or
GarageBand), and load the IPlug Example plugin. Note that macOS might not
see new AU plugins unless you restart your computer.

Note that even if you build a release version of the plugin, by default it
won't have NDEBUG defined. This is great for testing, because it means you
can still use DebugLog() to log to DebugView (Windows) or Console (macOS).

To build a production release you can run the makedist.cmd (Windows) and
makedist.sh (macOS) scripts from the command prompt. A next step would be
bundle production releases in a ZIP or installer, but that is beyond the
scope of this example.

LICENSE

WDL license, see License.txt.
