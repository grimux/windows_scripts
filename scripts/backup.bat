@echo off

::
:: Backup script
:: By Jake
::
:: This script is for backing up my important files
:: External media is used for the backup, such as a portable hard drive.
::

set "backupdir=D:\Backups"

if "%1" == "" (
	call:help
	exit /b 0
)
if "%1" == "help" (
	call:help
	exit /b 0
)
if "%1" == "docs" (
	call:drive_check || exit /b 1
	call:docs
	exit /b 0
)
if "%1" == "wsl" (
	call:wsl
	exit /b 0
) 
if "%1" == "settings" (
	call:settings
	exit /b 0
)
if "%1" == "screenshots" (
	call:drive_check || exit /b 1
	call:screenshots
	exit /b 0
)
if "%1" == "pictures" (
	call:drive_check || exit /b 1
	call:pictures
	exit /b 0
)
if "%1" == "music" (
	call:drive_check || exit /b 1
	call:music
	exit /b 0
)
if "%1" == "all" (
	call:drive_check || exit /b 1
	call:docs
	call:wsl
	call:settings
	call:pictures
	call:music
	call:screenshots
	exit /b 0
) else (
	echo Invalid command.
	goto:help
	exit /b 0
)

:: Document and tools backup
:docs
echo ====================================================================
echo Backing up documents...
echo --------------------------------------------------------------------
ROBOCOPY.EXE S:\documents\ %backupdir%\docs-jake /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE S:\documents-serena\ %backupdir%\docs-serena /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE X:\shared-documents\ %backupdir%\docs-shared /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE S:\tools\ %backupdir%\tools-jake /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
echo[
echo Done!
echo ====================================================================
exit /b 0


:: wsl backup
:wsl
echo ====================================================================
echo Backing up Arch wsl install...
echo --------------------------------------------------------------------
wsl --export Arch X:\archive-jake\Backups\wsl\wsl_arch.tar.gz
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Settings backup
:settings
echo ====================================================================
echo Backing up settings...
echo --------------------------------------------------------------------
7z u -up1q0r2x1y2z1w2 -mx9 -mmt16 %backupdir%\settings-jake\my_settings.7z X:\archive-jake\my-settings
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Screenshots and wallpapers
:screenshots
echo ====================================================================
echo Backing up screenshots and wallpapers...
echo --------------------------------------------------------------------
ROBOCOPY.EXE S:\game-screenshots\ %backupdir%\game-screenshots-jake /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE S:\wallpapers\ %backupdir%\wallpapers-jake /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE S:\screenshots\ %backupdir%\screenshots-jake /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Pictures
:pictures
echo ====================================================================
echo Backing up pictures...
echo --------------------------------------------------------------------
ROBOCOPY.EXE X:\Pictures\ %backupdir%\pictures /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Music
:music
echo ====================================================================
echo Backing up music...
echo --------------------------------------------------------------------
ROBOCOPY.EXE S:\music\ %backupdir%\music /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
echo[
echo Done!
echo ====================================================================
exit /b 0

:: Help Section
:help
echo Usage: backup (command) [flags]
echo Backup important files to external media.
echo[
echo docs		Backup documents
echo wsl		Backup wsl
echo settings	Backup settings (windows, linux, dotfiles...)
echo screenshots	Backup screenshots and wallpapers
echo pictures	Backup pictures
echo music		Backup music
echo all		All of the above
exit /b 0

:: Check for backup drive
:drive_check
if not exist %backupdir% (
	echo The backup drive is not present.
	echo Should be "%backupdir%"
	exit /b 1
) else exit /b 0