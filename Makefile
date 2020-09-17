# Usage: nmake [config=Release|Debug] [ndebug=1] ...

PROJECT = IPlugExample
OUTFILE = $(PROJECT).dll

CFLAGS = /fp:fast /D _USE_MATH_DEFINES /I . /c /Fo"$(OUTDIR)/" /Fd"$(OUTDIR)/" /Zi /W3 /WX /D _CRT_SECURE_NO_WARNINGS /D _CRT_NONSTDC_NO_WARNINGS /nologo
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
LINKFLAGS = $(LINKFLAGS) /ltcg
!ENDIF

CFLAGS = $(CFLAGS) /O2 /Gy /GS- /GR- /MT
LINKFLAGS = $(LINKFLAGS) /incremental:no /opt:ref /opt:icf /defaultlib:libcmt

!ELSE IF "$(CONFIGURATION)" == "Debug"

CFLAGS = $(CFLAGS) /D _DEBUG /D DEBUG /RTCsu /MTd
LINKFLAGS = $(LINKFLAGS) /debug

!ENDIF

OUTDIR = $(PLATFORM)/$(CONFIGURATION)

!MESSAGE $(PROJECT) - $(CONFIGURATION)|$(PLATFORM)
!MESSAGE

all : vst2

"$(OUTDIR)" :
!IF !EXIST("$(OUTDIR)/")
	mkdir $@
!ENDIF

vst2 : "$(OUTDIR)" "$(OUTDIR)/$(OUTFILE)"
!IFDEF REMINDER
	@echo.
!	IF "$(PLATFORM)" == "x64"
	@echo $(REMINDER:x64_or_x86=x86)
!	ELSE
	@echo $(REMINDER:x64_or_x86=x64)
!	ENDIF
!ENDIF

"$(OUTDIR)/$(PROJECT).obj" : $(PROJECT).cpp $(PROJECT).h resource.h IPlug/Containers.h IPlug/Hosts.h IPlug/IControl.h IPlug/IGraphics.h IPlug/IGraphicsWin.h IPlug/IParam.h IPlug/IPlug_include_in_plug_hdr.h IPlug/IPlug_include_in_plug_src.h IPlug/IPlugBase.h IPlug/IPlugStructs.h IPlug/IPlugVST2.h
	$(CPP) $(CPPFLAGS) /D VST2_API /Fa"$(OUTDIR)/_$(PROJECT).asm" $(PROJECT).cpp

RESOURCES = \
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

"$(OUTDIR)/$(PROJECT).res" : "$(PROJECT).rc" resource.h $(RESOURCES)
	$(RC) $(RCFLAGS) /D VST2_API /fo$@ "$(PROJECT).rc"

IPLUG = \
"$(OUTDIR)/Hosts.obj" \
"$(OUTDIR)/IControl.obj" \
"$(OUTDIR)/IGraphics.obj" \
"$(OUTDIR)/IGraphicsWin.obj" \
"$(OUTDIR)/IParam.obj" \
"$(OUTDIR)/IPlugBase.obj" \
"$(OUTDIR)/IPlugStructs.obj" \
"$(OUTDIR)/IPlugVST2.obj"

iplug : "$(OUTDIR)" $(IPLUG)

{IPlug}.cpp{$(OUTDIR)}.obj :
	$(CPP) $(CPPFLAGS) $<

LIBPNG = \
"$(OUTDIR)/png.obj" \
"$(OUTDIR)/pngerror.obj" \
"$(OUTDIR)/pngget.obj" \
"$(OUTDIR)/pngmem.obj" \
"$(OUTDIR)/pngread.obj" \
"$(OUTDIR)/pngrio.obj" \
"$(OUTDIR)/pngrtran.obj" \
"$(OUTDIR)/pngrutil.obj" \
"$(OUTDIR)/pngset.obj" \
"$(OUTDIR)/pngtrans.obj" \

libpng : "$(OUTDIR)" $(LIBPNG)

{WDL/libpng}.c{$(OUTDIR)}.obj :
	$(CC) $(CFLAGS) "$<"

LICE = \
"$(OUTDIR)/lice.obj" \
"$(OUTDIR)/lice_arc.obj" \
"$(OUTDIR)/lice_line.obj" \
"$(OUTDIR)/lice_png.obj" \
"$(OUTDIR)/lice_textnew.obj"

lice : "$(OUTDIR)" $(LICE)

{WDL/lice}.cpp{$(OUTDIR)}.obj :
	$(CPP) $(CPPFLAGS) $<

ZLIB = \
"$(OUTDIR)/adler32.obj" \
"$(OUTDIR)/crc32.obj" \
"$(OUTDIR)/infback.obj" \
"$(OUTDIR)/inffast.obj" \
"$(OUTDIR)/inflate.obj" \
"$(OUTDIR)/inftrees.obj" \
"$(OUTDIR)/trees.obj" \
"$(OUTDIR)/zutil.obj"

zlib : "$(OUTDIR)" $(ZLIB)

{WDL/zlib}.c{$(OUTDIR)}.obj :
	$(CC) $(CFLAGS) /D NO_GZCOMPRESS /D Z_SOLO "$<"

LIBS = \
advapi32.lib \
comctl32.lib \
comdlg32.lib \
gdi32.lib \
ole32.lib \
shell32.lib \
user32.lib \
wininet.lib

"$(OUTDIR)/$(OUTFILE)" : "$(OUTDIR)/$(PROJECT).obj" "$(OUTDIR)/$(PROJECT).res" $(IPLUG) $(LIBPNG) $(LICE) $(ZLIB)
	link $(LINKFLAGS) /out:$@ $** $(LIBS)

clean :
!IF EXIST("$(OUTDIR)/")
	rmdir /s /q "$(OUTDIR)"
!ENDIF
!IF EXIST("$(PLATFORM)/")
	-@rmdir /q "$(PLATFORM)"
!ENDIF
