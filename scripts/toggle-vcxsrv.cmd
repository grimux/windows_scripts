@echo off
:: This script is for toggling the xserver for wsl

set server="vcxsrv.exe"

:: Search for the vcxsrv instance, either start or kill
tasklist | findstr /I %server%
if "%ERRORLEVEL%" == "0" (
	echo vcxsrv is running, killing...
	taskkill /f /im %server%
	S:\tools\SystemTrayRefresh.exe
)
if "%ERRORLEVEL%" == "1" (
	echo starting %server%...
	S:\tools\vcxsrv\config.xlaunch
)