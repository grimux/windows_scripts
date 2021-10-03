@echo off

:: x-server
set server="vcxsrv.exe"

:: Check if vcxsrv is running
tasklist | findstr /I %server%
REM errorlevel of 0 means the server is already running, so kill it
if "%ERRORLEVEL%" == "0" call toggle-vcxsrv.cmd

:: Run the config for VcXsrv
"S:\tools\vcxsrv\fullscreen.xlaunch"

:: Start Puleseadio
start "" /B "C:\wsl\pulseaudio\bin\pulseaudio.exe"

:: Run my win-desk script inside wsl
wsl win-desk

:: Kill pulseaudio after server is closed
taskkill /IM pulseaudio.exe /F