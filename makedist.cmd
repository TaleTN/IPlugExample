@echo off
setlocal

if "%1"=="" goto :help
if not "%2"=="" goto :help

if /i "%1"=="/nmake" goto :nmake
if /i "%1"=="/msbuild" goto :msbuild
if /i "%1"=="/clean" goto :clean

:help
echo Usage: %0 /nmake ^| /msbuild ^| /clean
goto :eof

:nmake
set nmake=nmake /nologo config=Release ndebug=1

%nmake% clean || goto :eof
%nmake% vst2 reminder="Reminder: Don't forget to also make x64_or_x86 distribution."
goto :eof

:msbuild
for %%i in (x64 x86) do (
	msbuild -m -t:Rebuild -p:Configuration=Release,ndebug=NDEBUG -p:Platform=%%i || goto :eof
)
goto :eof

:clean
for %%i in (x64 Win32) do if exist "%%i" rmdir /q /s "%%i"
