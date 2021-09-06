@echo off
:: This script is for toggling the xserver for wsl

:: Search for the vcxsrv instance, either start or kill
tasklist /fi "ImageName eq vcxsrv.exe" /fo csv 2>NUL | find /I "vcxsrv.exe">NUL
if "%ERRORLEVEL%"=="0" (
	echo vcxsrv is running, killing...
	taskkill /f /im vcxsrv.exe
	S:\tools\SystemTrayRefresh.exe
)
if "%ERRORLEVEL%"=="1" (
	echo starting vcxsrv...
	S:\tools\vcxsrv\config.xlaunch
)