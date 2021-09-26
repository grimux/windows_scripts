@echo off

:: x-server
set server="vcxsrv.exe"

:: Check if vcxsrv is running
tasklist | findstr /I %server%
REM errorlevel of 0 means the server is already running, so kill it
if "%ERRORLEVEL%" == "0" call toggle-vcxsrv.cmd

:: Run the config for VcXsrv
"S:\tools\vcxsrv\fullscreen.xlaunch"

:: Run my win-desk script inside wsl
wsl win-desk