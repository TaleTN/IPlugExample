# IPlug Example

A simple tremolo audio effect plugin (AAX/AU/CLAP/VST2/VST3) for Windows and
macOS, serving as an example for the
[IPlug "Tale" Edition](https://github.com/TaleTN/IPlug) plugin framework.

## Getting started

To be able to build this example you will need the following (free) tools
and additional projects:

1. [C/C++ compiler](#cc-compiler)
2. [IPlug framework](#iplug-framework)
3. [WDL library](#wdl-library)
4. [CLAP headers](#clap-headers)
5. [VST 2.4 SDK](#vst-24-sdk)
6. [VST 3 SDK](#vst-3-sdk)
7. [AAX SDK](#aax-sdk)

Note that this readme describes the toolset we actually use at
[Martinic](https://www.martinic.com/). You could probably use a different
toolset, but then things will likely not work right out of the box.

## C/C++ compiler

For Windows we use the Microsoft
[Visual Studio](https://visualstudio.microsoft.com/vs/) 2022 C/C++
compiler, although any somewhat recent Microsoft C/C++ toolset should work.
You can download the free Visual Studio Community edition via:

https://visualstudio.microsoft.com/downloads/

For macOS you will need the [Xcode](https://developer.apple.com/xcode/) 13
or newer IDE. Before downloading Xcode first sign in to Apple Developer via:

https://developer.apple.com/account/

Then you can download Xcode (and optionally the Additional Tools for Xcode)
via:

https://developer.apple.com/download/all/

Alternatively you can download Xcode from the Mac App Store.

## Example project

You can download the IPlug example project (i.e. this project) from:

https://github.com/TaleTN/IPlugExample

If you use [Git](https://git-scm.com/), then alternatively you can clone the
example project:

1. `mkdir IPlugExample`
2. `cd IPlugExample`
3. `git clone https://github.com/TaleTN/IPlugExample.git .`

## IPlug framework

IPlug is a cross-platform AAX/AU/CLAP/VST2/VST3 plugin framework for Windows
and macOS, on which you can build audio plug-in effects and instruments. It
was originally part of the [Cockos WDL](https://www.cockos.com/wdl/)
library, but it has since evolved into different forks like
[IPlug "Tale" Edition](https://github.com/TaleTN/IPlug) and
[iPlug2](https://iplug2.github.io/) (formerly
[WDL-OL](https://github.com/olilarkin/wdl-ol)). Note that this example will
work only with IPlug "Tale" Edition.

You can download IPlug "Tale" Edition from:

https://github.com/TaleTN/IPlug

Extract it so you have:

```
IPlugExample/IPlugExample.cpp, ...
IPlugExample/IPlug/IPlugBase.cpp, ...             <-- IPlug goes here
```

If you use [Git](https://git-scm.com/), then alternatively you can add IPlug
as a remote:

1. `git remote add iplug https://github.com/TaleTN/IPlug.git`
2. `git fetch iplug`
3. `git merge --allow-unrelated-histories iplug/main`

For your own projects this is the recommended method.

## WDL library

WDL (whittle) is a C++ library, created and maintained by
[Cockos](https://www.cockos.com/), and used for
[REAPER](https://www.reaper.fm/). Although
[IPlug "Tale" Edition](https://github.com/TaleTN/IPlug) will work fine with
[Cockos WDL](https://www.cockos.com/wdl/), using
[WDL "Tale" Edition](https://github.com/TaleTN/WDL) instead is recommended,
because that is what we use at [Martinic](https://www.martinic.com/). :wink:

You can download WDL "Tale" Edition from:

https://github.com/TaleTN/WDL

Extract it so you have:

```
IPlugExample/IPlugExample.cpp, ...
IPlugExample/IPlug/Containers.h, ...
IPlugExample/WDL/assocarray.h, ...                <-- WDL goes here
```

Alternatively you can add WDL as a remote:

1. `git remote add wdl https://github.com/TaleTN/WDL.git`
2. `git fetch wdl`
3. `git merge --allow-unrelated-histories wdl/main`

For your own projects this is the recommended method.

## CLAP headers

For [CLAP](https://cleveraudio.org/) support you will need the CLAP ABI
headers. You can download CLAP from:

https://github.com/free-audio/clap

You will only need the header files in `include/clap`. Extract them and
place them in `CLAP_SDK` so you have:

```
IPlugExample/IPlugExample.cpp, ...
IPlugExample/IPlug/Containers.h, ...
IPlugExample/WDL/assocarray.h, ...
IPlugExample/CLAP_SDK/audio-buffer.h, ...         <-- CLAP_SDK goes here
```

## VST 2.4 SDK

For VST 2.4 support you will need only two header files from the VST 2.4
SDK: `aeffect.h` and `aeffectx.h`. Extract them and place them in
`VST2_SDK` so you have:

```
IPlugExample/IPlugExample.cpp, ...
IPlugExample/IPlug/Containers.h, ...
IPlugExample/WDL/assocarray.h, ...
IPlugExample/VST2_SDK/aeffect.h, aeffectx.h       <-- VST2_SDK goes here
```

You will find these header files in the `pluginterfaces/vst2.x` directory
inside the VST 2.4 or [VST 3 SDK](https://www.steinberg.net/developers/),
but you will need v3.6 or older. You used to be able to download v3.6.6
here:

https://www.steinberg.net/sdk_downloads/vstsdk366_27_06_2016_build_61.zip

However, it would seem that it is no longer available, courtesy of
Steinberg.

## VST 3 SDK

For VST 3 support you will need the VST 3 Audio Plug-Ins SDK from Steinberg,
which you can download from here:

https://www.steinberg.net/developers/

The VST 3 SDK comes as a ZIP file, and you will need only three directories
from `VST_SDK/vst3sdk/` within this ZIP: `base`, `pluginterfaces`, and
`public.sdk`. Extract them and place them in `VST3_SDK` so you have:

```
IPlugExample/IPlugExample.cpp, ...
IPlugExample/IPlug/Containers.h, ...
IPlugExample/WDL/assocarray.h, ...
IPlugExample/VST3_SDK/base/*                      <-- VST3_SDK goes here
IPlugExample/VST3_SDK/pluginterfaces/*
IPlugExample/VST3_SDK/public.sdk/*
```

## AAX SDK

For AAX ([Pro Tools](https://www.avid.com/pro-tools)) support you will need
the AAX SDK from Avid, which you can download from here:

https://my.avid.com/products/cppsdk  (developer account required)

The AAX SDK comes as a ZIP file, from which you will need only three
directories: `Interfaces`, `Libs/AAXLibrary/include`, and
`Libs/AAXLibrary/sources`. Extract them and place them in `AAX_SDK` so
you have:

```
IPlugExample/IPlugExample.cpp, ...
IPlugExample/IPlug/Containers.h, ...
IPlugExample/WDL/assocarray.h, ...
IPlugExample/AAX_SDK/Interfaces/AAX.h, ...        <-- AAX_SDK goes here
IPlugExample/AAX_SDK/Libs/AAXLibrary/include/*
IPlugExample/AAX_SDK/Libs/AAXLibrary/source/*
```

## How to build & run

On Windows open the [`IPlugExample.sln`](IPlugExample.sln) solution in
Visual Studio 2022, and build the CLAP plugin from within the IDE.
Alternatively you can build the CLAP plugin (as well as the other plugin
formats) from the command prompt by typing:

1. `cd IPlugExample`
2. `nmake clap`
3. `nmake vst2`
4. `nmake vst3`
5. `nmake aax`

Note that building from the command prompt should work with any somewhat
recent Microsoft C/C++ toolset.

To run the plugin copy `IPlugExample.clap` (CLAP), `IPlugExample.dll`
(VST2), or `IPlugExample.vst3` (VST3) from `IPlugExample/x64/Release/` to
your CLAP, VST 2.4, or VST 3 plugin path. Then launch your hosting software
of choice (e.g. [REAPER](https://www.reaper.fm/) or
[VSTHost](https://www.hermannseib.com/english/vsthost.htm)), and load the
IPlug Example plugin.

To run the AAX plugin copy `IPlugExample.aaxplugin` from
`IPlugExample/x64/Release/` to:

```
C:\Program Files\Common Files\Avid\Audio\Plug-Ins\IPlugExample.aaxplugin\Contents\x64\
```

Then launch [Pro Tools](https://www.avid.com/pro-tools) Developer, and load
the IPlug Example (stereo) plugin (under *multichannel plug-in* > *Effect*).

On macOS open the [`IPlugExample.xcodeproj`](IPlugExample.xcodeproj) project
in Xcode, and build the AAX, AU, CLAP, and/or VST2 target from within the
IDE. If you build for running, then this will automatically copy the plugin
to the (user) audio plugins folder.

To run the plugin launch your hosting software of choice (e.g.
[REAPER](https://www.reaper.fm/) or
[GarageBand](https://www.apple.com/mac/garageband/)), and load the IPlug
Example plugin. The first time you build the AU plugin macOS might not see
it unless you restart your computer, or run the following command from the
terminal:

```
killall -9 AudioComponentRegistrar
```

Note that even if you build a release version of the plugin, by default it
won't have the `NDEBUG` macro defined. This is great for testing, because it
means you can still use `IPlugBase::DebugLog()` to log to
[DebugView](https://learn.microsoft.com/en-us/sysinternals/downloads/debugview)
(Windows) or Console (macOS).

To build a production release you can run the [`makedist.cmd`](makedist.cmd)
(Windows) or [`./makedist.sh`](makedist.sh) (macOS) scripts from the command
prompt or terminal. A next step would be to bundle production releases in a
ZIP file or installer, but that is beyond the scope of this example.

## License

WDL license, see [License.txt](License.txt).
