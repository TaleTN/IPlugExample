# Usage: nmake [config=Release|Debug] [ndebug=1] ...

PROJECT = IPlugExample
OUTFILE = $(PROJECT)

CFLAGS = /fp:fast /D _USE_MATH_DEFINES /I . /c /Fd"$(OUTDIR)/" /Zi /W3 /WX /D _CRT_SECURE_NO_WARNINGS /D _CRT_NONSTDC_NO_WARNINGS /MP /nologo
CFLAGS = $(CFLAGS) /D WDL_DENORMAL_WANTS_SCOPED_FTZ

CPPFLAGS = /EHsc $(CFLAGS)

RCFLAGS = /nologo
LINKFLAGS = /dll /subsystem:windows /dynamicbase:no /manifest:no /nologo

!IF "$(TARGET_CPU)" == "x64" || "$(CPU)" == "AMD64" || "$(PLATFORM)" == "x64" || "$(PLATFORM)" == "X64"

PLATFORM = x64
CFLAGS = $(CFLAGS) /favor:blend
LINKFLAGS = $(LINKFLAGS) /machine:x64

!ELSE

PLATFORM = Win32
CFLAGS = $(CFLAGS) /arch:SSE2
LINKFLAGS = $(LINKFLAGS) /machine:x86

!ENDIF

!IF DEFINED(CONFIG)
CONFIGURATION = $(CONFIG)
!ENDIF

!IF !DEFINED(CONFIGURATION) && DEFINED(CPU) && DEFINED(APPVER) && !DEFINED(NODEBUG)
CONFIGURATION = Debug
!ELSE IF !DEFINED(CONFIGURATION)
CONFIGURATION = Release
!ENDIF

!IF "$(CONFIGURATION)" == "Release"

!IF DEFINED(NDEBUG) && "$(NDEBUG)" != "0"
CFLAGS = $(CFLAGS) /D NDEBUG /GL
VST3FLAGS = /D "RELEASE=1"
LINKFLAGS = $(LINKFLAGS) /ltcg
!ELSE
LINKFLAGS = $(LINKFLAGS) /debug
!ENDIF

CFLAGS = $(CFLAGS) /O2 /Gy /GS- /GR- /MT
LINKFLAGS = $(LINKFLAGS) /incremental:no /opt:ref /opt:icf /defaultlib:libcmt

!ELSE IF "$(CONFIGURATION)" == "Debug"

CFLAGS = $(CFLAGS) /D _DEBUG /D DEBUG /RTCsu /MTd
LINKFLAGS = $(LINKFLAGS) /debug

!ENDIF

!IF !DEFINED(VST3FLAGS)
VST3FLAGS = /D "DEVELOPMENT=1"
!ENDIF

OUTDIR = $(PLATFORM)/$(CONFIGURATION)

!MESSAGE $(PROJECT) - $(CONFIGURATION)|$(PLATFORM)
!MESSAGE

all : clap

"$(OUTDIR)" :
!IF !EXIST("$(OUTDIR)/")
	mkdir $@
!ENDIF

IPLUGINC = \
IPlug/Containers.h \
IPlug/Hosts.h \
IPlug/IControl.h \
IPlug/IGraphics.h \
IPlug/IGraphicsWin.h \
IPlug/IParam.h \
IPlug/IPlug_include_in_plug_hdr.h \
IPlug/IPlug_include_in_plug_src.h \
IPlug/IPlugBase.h \
IPlug/IPlugStructs.h

SOURCES = \
"$(PROJECT).cpp" \
"$(PROJECT).h" \
resource.h \
$(IPLUGINC)

"$(OUTDIR)/$(PROJECT)_CLAP.obj" : $(SOURCES) IPlug/IPlugCLAP.h
	$(CPP) $(CPPFLAGS) /D CLAP_API /Fo$@ /Fa"$(OUTDIR)/_$(PROJECT)_CLAP.asm" "$(PROJECT).cpp"

"$(OUTDIR)/$(PROJECT)_VST2.obj" : $(SOURCES) IPlug/IPlugVST2.h
	$(CPP) $(CPPFLAGS) /D VST2_API /Fo$@ /Fa"$(OUTDIR)/_$(PROJECT)_VST2.asm" "$(PROJECT).cpp"

VST3FLAGS = $(VST3FLAGS) /I VST3_SDK

"$(OUTDIR)/$(PROJECT)_VST3.obj" : $(SOURCES) IPlug/IPlugVST3.h
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /D VST3_API /Fo$@ /Fa"$(OUTDIR)/_$(PROJECT)_VST3.asm" "$(PROJECT).cpp"

# TN: AAX SDK v2.8.0 doesn't require /wd5272 anymore, but v2.6.x and v2.7.x
# probably do.
AAXFLAGS = /I AAX_SDK/Interfaces/ACF /FIIPlug/IPlugAAX_Assert.h /wd5272

"$(OUTDIR)/$(PROJECT)_AAX.obj" : $(SOURCES) IPlug/IPlugAAX.h
	$(CPP) $(CPPFLAGS) $(AAXFLAGS) /D AAX_API /Fo$@ /Fa"$(OUTDIR)/_$(PROJECT)_AAX.asm" "$(PROJECT).cpp"

RESOURCES = \
"$(PROJECT).rc" \
resource.h \
img/bg.png \
img/bg@2x.png \
img/bypass.png \
img/bypass@2x.png \
# img/font.ttf \
img/handle.png \
img/handle@2x.png \
img/knob.png \
img/knob@2x.png \
img/shape.png \
img/shape@2x.png

"$(OUTDIR)/$(PROJECT)_CLAP.res" : $(RESOURCES)
	$(RC) $(RCFLAGS) /D CLAP_API /fo$@ "$(PROJECT).rc"

"$(OUTDIR)/$(PROJECT)_VST2.res" : $(RESOURCES)
	$(RC) $(RCFLAGS) /D VST2_API /fo$@ "$(PROJECT).rc"

"$(OUTDIR)/$(PROJECT)_VST3.res" : $(RESOURCES)
	$(RC) $(RCFLAGS) /D VST3_API /fo$@ "$(PROJECT).rc"

"$(OUTDIR)/$(PROJECT)_AAX.res" : $(RESOURCES)
	$(RC) $(RCFLAGS) /D AAX_API /fo$@ "$(PROJECT).rc"

IPLUGOBJ = \
"$(OUTDIR)/Hosts.obj" \
"$(OUTDIR)/IControl.obj" \
"$(OUTDIR)/IGraphics.obj" \
"$(OUTDIR)/IGraphicsWin.obj" \
"$(OUTDIR)/IParam.obj" \
"$(OUTDIR)/IPlugBase.obj" \
"$(OUTDIR)/IPlugStructs.obj"

iplug : "$(OUTDIR)" $(IPLUGOBJ) "$(OUTDIR)/IPlugCLAP.obj" "$(OUTDIR)/IPlugVST2.obj" "$(OUTDIR)/IPlugVST3.obj" "$(OUTDIR)/IPlugAAX.obj"

#"$(OUTDIR)/Hosts.obj" : IPlug/Hosts.cpp IPlug/Hosts.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_Hosts.asm" IPlug/Hosts.cpp
#
#"$(OUTDIR)/IControl.obj" : IPlug/IControl.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IControl.h IPlug/IGraphics.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IControl.asm" IPlug/IControl.cpp
#
#"$(OUTDIR)/IGraphics.obj" : IPlug/IGraphics.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IControl.h IPlug/IGraphics.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IGraphics.asm" IPlug/IGraphics.cpp
#
#"$(OUTDIR)/IGraphicsWin.obj" : IPlug/IGraphicsWin.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IControl.h IPlug/IGraphics.h IPlug/IGraphicsWin.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IGraphicsWin.asm" IPlug/IGraphicsWin.cpp
#
#"$(OUTDIR)/IParam.obj" : IPlug/IParam.cpp IPlug/Containers.h IPlug/IParam.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IParam.asm" IPlug/IParam.cpp
#
#"$(OUTDIR)/IPlugBase.obj" : IPlug/IPlugBase.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IGraphics.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IPlugBase.asm" IPlug/IPlugBase.cpp
#
#"$(OUTDIR)/IPlugStructs.obj" : IPlug/IPlugStructs.cpp IPlug/Containers.h IPlug/IPlugStructs.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IPlugStructs.asm" IPlug/IPlugStructs.cpp
#
#"$(OUTDIR)/IPlugCLAP.obj" : IPlug/IPlugCLAP.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IGraphics.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h IPlug/IPlugCLAP.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IPlugCLAP.asm" IPlug/IPlugCLAP.cpp
#
#"$(OUTDIR)/IPlugVST2.obj" : IPlug/IPlugVST2.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IGraphics.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h IPlug/IPlugVST2.h
#	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IPlugVST2.asm" IPlug/IPlugVST2.cpp
#
#"$(OUTDIR)/IPlugVST3.obj" : IPlug/IPlugVST3.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IGraphics.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h IPlug/IPlugVST3.h
#	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IPlugVST3.asm" IPlug/IPlugVST3.cpp
#
#"$(OUTDIR)/IPlugAAX.obj" : IPlug/IPlugAAX.cpp IPlug/Containers.h IPlug/Hosts.h IPlug/IGraphics.h IPlug/IParam.h IPlug/IPlugBase.h IPlug/IPlugStructs.h IPlug/IPlugAAX.h
#	$(CPP) $(CPPFLAGS) $(AAXFLAGS) /Fo"$(OUTDIR)/" /Fa"$(OUTDIR)/_IPlugAAX.asm" IPlug/IPlugAAX.cpp

{IPlug}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" $<

"$(OUTDIR)/IPlugVST3.obj" : IPlug/IPlugVST3.cpp
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $**

"$(OUTDIR)/IPlugAAX.obj" : IPlug/IPlugAAX.cpp
	$(CPP) $(CPPFLAGS) $(AAXFLAGS) /Fo"$(OUTDIR)/" $**

LIBPNGOBJ = \
"$(OUTDIR)/png.obj" \
"$(OUTDIR)/pngerror.obj" \
"$(OUTDIR)/pngget.obj" \
"$(OUTDIR)/pngmem.obj" \
"$(OUTDIR)/pngread.obj" \
"$(OUTDIR)/pngrio.obj" \
"$(OUTDIR)/pngrtran.obj" \
"$(OUTDIR)/pngrutil.obj" \
"$(OUTDIR)/pngset.obj" \
"$(OUTDIR)/pngtrans.obj"

libpng : "$(OUTDIR)" $(LIBPNGOBJ)

{WDL/libpng}.c{$(OUTDIR)}.obj ::
	$(CC) $(CFLAGS) /Fo"$(OUTDIR)/" $<

LICEOBJ = \
"$(OUTDIR)/lice.obj" \
"$(OUTDIR)/lice_arc.obj" \
"$(OUTDIR)/lice_line.obj" \
"$(OUTDIR)/lice_png.obj" \
"$(OUTDIR)/lice_textnew.obj"

lice : "$(OUTDIR)" $(LICEOBJ)

{WDL/lice}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) /Fo"$(OUTDIR)/" $<

ZLIBOBJ = \
"$(OUTDIR)/adler32.obj" \
"$(OUTDIR)/crc32.obj" \
"$(OUTDIR)/infback.obj" \
"$(OUTDIR)/inffast.obj" \
"$(OUTDIR)/inflate.obj" \
"$(OUTDIR)/inftrees.obj" \
"$(OUTDIR)/trees.obj" \
"$(OUTDIR)/zutil.obj"

zlib : "$(OUTDIR)" $(ZLIBOBJ)

{WDL/zlib}.c{$(OUTDIR)}.obj ::
	$(CC) $(CFLAGS) /D NO_GZCOMPRESS /D Z_SOLO /Fo"$(OUTDIR)/" $<

VST3OBJ = \
"$(OUTDIR)/baseiids.obj" \
"$(OUTDIR)/fbuffer.obj" \
"$(OUTDIR)/fdebug.obj" \
"$(OUTDIR)/fobject.obj" \
"$(OUTDIR)/fstreamer.obj" \
"$(OUTDIR)/fstring.obj" \
"$(OUTDIR)/updatehandler.obj" \
"$(OUTDIR)/flock.obj" \
"$(OUTDIR)/coreiids.obj" \
"$(OUTDIR)/funknown.obj" \
"$(OUTDIR)/ustring.obj" \
"$(OUTDIR)/commoniids.obj" \
"$(OUTDIR)/pluginview.obj" \
"$(OUTDIR)/pluginfactory.obj" \
"$(OUTDIR)/vstbus.obj" \
"$(OUTDIR)/vstcomponentbase.obj" \
"$(OUTDIR)/vstinitiids.obj" \
"$(OUTDIR)/vstparameters.obj" \
"$(OUTDIR)/vstsinglecomponenteffect.obj" \
"$(OUTDIR)/vst2persistence.obj"

vst3sdk : "$(OUTDIR)" $(VST3OBJ)

{VST3_SDK/base/source}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $<

{VST3_SDK/base/thread/source}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $<

{VST3_SDK/pluginterfaces/base}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $<

{VST3_SDK/public.sdk/source/common}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $<

{VST3_SDK/public.sdk/source/main}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $<

{VST3_SDK/public.sdk/source/vst}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $<

{VST3_SDK/public.sdk/source/vst/utility}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(VST3FLAGS) /Fo"$(OUTDIR)/" $<

AAXOBJ = \
"$(OUTDIR)/AAX_CACFUnknown.obj" \
"$(OUTDIR)/AAX_CChunkDataParser.obj" \
"$(OUTDIR)/AAX_CEffectGUI.obj" \
"$(OUTDIR)/AAX_CEffectParameters.obj" \
"$(OUTDIR)/AAX_CHostServices.obj" \
"$(OUTDIR)/AAX_CMutex.obj" \
"$(OUTDIR)/AAX_CPacketDispatcher.obj" \
"$(OUTDIR)/AAX_CParameter.obj" \
"$(OUTDIR)/AAX_CParameterManager.obj" \
"$(OUTDIR)/AAX_CString.obj" \
"$(OUTDIR)/AAX_CUIDs.obj" \
"$(OUTDIR)/AAX_Exports.obj" \
"$(OUTDIR)/AAX_IEffectGUI.obj" \
"$(OUTDIR)/AAX_IEffectParameters.obj" \
"$(OUTDIR)/AAX_Init.obj" \
"$(OUTDIR)/AAX_VAutomationDelegate.obj" \
"$(OUTDIR)/AAX_VCollection.obj" \
"$(OUTDIR)/AAX_VComponentDescriptor.obj" \
"$(OUTDIR)/AAX_VController.obj" \
"$(OUTDIR)/AAX_VDescriptionHost.obj" \
"$(OUTDIR)/AAX_VEffectDescriptor.obj" \
"$(OUTDIR)/AAX_VFeatureInfo.obj" \
"$(OUTDIR)/AAX_VHostServices.obj" \
"$(OUTDIR)/AAX_VPageTable.obj" \
"$(OUTDIR)/AAX_VPropertyMap.obj" \
"$(OUTDIR)/AAX_VTransport.obj" \
"$(OUTDIR)/AAX_VViewContainer.obj"

aaxlib : "$(OUTDIR)" $(AAXOBJ)

AAXFLAGS = $(AAXFLAGS) /D WIN32

{AAX_SDK/Libs/AAXLibrary/source}.cpp{$(OUTDIR)}.obj ::
	$(CPP) $(CPPFLAGS) $(AAXFLAGS) /I AAX_SDK/Interfaces /Fo"$(OUTDIR)/" $<

"$(OUTDIR)/AAX_Exports.obj" : AAX_SDK/Interfaces/AAX_Exports.cpp
	$(CPP) $(CPPFLAGS) $(AAXFLAGS) /Fo"$(OUTDIR)/" $**

OBJECTS = \
$(IPLUGOBJ) \
$(LIBPNGOBJ) \
$(LICEOBJ) \
$(ZLIBOBJ)

LIBS = \
advapi32.lib \
comctl32.lib \
comdlg32.lib \
gdi32.lib \
ole32.lib \
shell32.lib \
user32.lib \
wininet.lib

"$(OUTDIR)/$(OUTFILE).clap" : "$(OUTDIR)/$(PROJECT)_CLAP.obj" "$(OUTDIR)/$(PROJECT)_CLAP.res" "$(OUTDIR)/IPlugCLAP.obj" $(OBJECTS)
	@echo ^ ^ ^ ^ ^ ^ ^ ^ link $(LINKFLAGS) /out:$@ "$(OUTDIR)/$(PROJECT)_CLAP.obj" ...
	@link $(LINKFLAGS) /out:$@ /implib:"$(OUTDIR)/$(PROJECT)_CLAP.lib" $** $(LIBS)

"$(OUTDIR)/$(OUTFILE).dll" : "$(OUTDIR)/$(PROJECT)_VST2.obj" "$(OUTDIR)/$(PROJECT)_VST2.res" "$(OUTDIR)/IPlugVST2.obj" $(OBJECTS)
	@echo ^ ^ ^ ^ ^ ^ ^ ^ link $(LINKFLAGS) /out:$@ "$(OUTDIR)/$(PROJECT)_VST2.obj" ...
	@link $(LINKFLAGS) /out:$@ /implib:"$(OUTDIR)/$(PROJECT)_VST2.lib" $** $(LIBS)

"$(OUTDIR)/$(OUTFILE).vst3" : "$(OUTDIR)/$(PROJECT)_VST3.obj" "$(OUTDIR)/$(PROJECT)_VST3.res" "$(OUTDIR)/IPlugVST3.obj" $(OBJECTS) $(VST3OBJ)
	@echo ^ ^ ^ ^ ^ ^ ^ ^ link $(LINKFLAGS) /out:$@ "$(OUTDIR)/$(PROJECT)_VST3.obj" ...
	@link $(LINKFLAGS) /out:$@ /implib:"$(OUTDIR)/$(PROJECT)_VST3.lib" $** $(LIBS)

"$(OUTDIR)/$(OUTFILE).aaxplugin" : "$(OUTDIR)/$(PROJECT)_AAX.obj" "$(OUTDIR)/$(PROJECT)_AAX.res" "$(OUTDIR)/IPlugAAX.obj" $(OBJECTS) $(AAXOBJ)
	@echo ^ ^ ^ ^ ^ ^ ^ ^ link $(LINKFLAGS) /out:$@ "$(OUTDIR)/$(PROJECT)_AAX.obj" ...
	@link $(LINKFLAGS) /out:$@ /implib:"$(OUTDIR)/$(PROJECT)_AAX.lib" $** $(LIBS)

OUTDIR_OUTFILE = $(OUTDIR:/=\)\$(OUTFILE)

clap : "$(OUTDIR)" "$(OUTDIR)/$(OUTFILE).clap"

vst2 : "$(OUTDIR)" "$(OUTDIR)/$(OUTFILE).dll"

vst3 : "$(OUTDIR)" "$(OUTDIR)/$(OUTFILE).vst3"

aax : "$(OUTDIR)" "$(OUTDIR)/$(OUTFILE).aaxplugin"

sign-aax : del-aax aax
#	wraptool sign --signtool "$(WINDOWSSDKVERBINPATH)\x64\signtool.exe" --customernumber MYCU-STOM-ERNU-MBER --customername "Tale" --productname "IPlug Example" --signid "9ca1bf1665add1b51891e59b1746d9ec67106e12" --extrasigningoptions "digest_sha256" --in "$(OUTDIR_OUTFILE).aaxplugin" --out "$(OUTDIR_OUTFILE).aaxplugin"

del-aax :
!IF EXIST("$(OUTDIR_OUTFILE).aaxplugin")
	@del "$(OUTDIR_OUTFILE).aaxplugin"
!ENDIF

dist : clap vst2 vst3 sign-aax
!IFDEF REMINDER
	@echo.
!	IF "$(PLATFORM)" == "x64"
	@echo $(REMINDER:x64_or_x86=x86)
!	ELSE
	@echo $(REMINDER:x64_or_x86=x64)
!	ENDIF
!ENDIF

clean :
!IF EXIST("$(OUTDIR)/")
	rmdir /s /q "$(OUTDIR)"
!ENDIF
!IF EXIST("$(PLATFORM)/")
	-@rmdir /q "$(PLATFORM)"
!ENDIF
