@echo off

::
:: Backup script
:: By Jake
::
:: This script is for backing up my important files
:: External media is used for the backup, such as a portable hard drive.
::

:: Directory locations
set "backupdir=D:\Backups"
set "localdir=S:"
set "docs-jake=documents"

:: Flow
if "%1" == "" (
	call:help
	exit /b 0
)
if "%1" == "help" (
	call:help
	exit /b 0
)

:: Check for external hard drive, if not attached exit script
call:drive_check || exit /b 1

if "%1" == "docs" (
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
	call:screenshots
	exit /b 0
)
if "%1" == "pictures" (
	call:pictures
	exit /b 0
)
if "%1" == "music" (
	call:music
	exit /b 0
)
if "%1" == "all" (
	call:docs
	call:wsl
	call:settings
	call:pictures
	call:music
	call:screenshots
	exit /b 0
)
if "%1" == "restore" (
	call:restore
	exit /b 0
 )else (
	echo Invalid command.
	goto:help
	exit /b 0
)

:: Document and tools backup
:docs
echo ====================================================================
echo Backing up documents...
echo --------------------------------------------------------------------
call:robocopy_backup S:\documents\ %backupdir%\docs-jake
call:robocopy_backup S:\documents-serena\ %backupdir%\docs-serena
call:robocopy_backup X:\shared-documents\ %backupdir%\docs-shared
call:robocopy_backup S:\tools\ %backupdir%\tools-jake
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
ROBOCOPY.EXE X:\archive-jake\Backups\wsl %backupdir%\wsl /E /J /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16 /NJH /NJS /ETA /XO
rem xcopy /DEY /J X:\archive-jake\Backups\wsl %backupdir%\wsl
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
call:robocopy_backup S:\game-screenshots\ %backupdir%\game-screenshots-jake/MT:16
call:robocopy_backup S:\wallpapers\ %backupdir%\wallpapers-jake
call:robocopy_backup S:\screenshots\ %backupdir%\screenshots-jake
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Pictures
:pictures
echo ====================================================================
echo Backing up pictures...
echo --------------------------------------------------------------------
call:robocopy_backup X:\Pictures\ %backupdir%\pictures
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Music
:music
echo ====================================================================
echo Backing up music...
echo --------------------------------------------------------------------
call:robocopy_backup S:\music\ %backupdir%\music
echo[
echo Done!
echo ====================================================================
exit /b 0

:: Restore
:restore
echo ====================================================================
echo Restoring documents
echo --------------------------------------------------------------------
echo[
echo This script will perform a dry-run first, please check the log to ensure no
echo files are overwritten or lost.
echo[
pause
ROBOCOPY.EXE %backupdir%\docs-jake\ S:\documents /L /E /XO /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
choice /M "Would you like to continue?"
if ERRORLEVEL 2 exit /b 0
ROBOCOPY.EXE %backupdir%\docs-jake\ S:\documents /E /XO /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
exit /b 0

:: Robocopy backup command
:robocopy_backup
ROBOCOPY.EXE %~1 %~2 /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
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
echo restore		Restore files
exit /b 0

:: Check if external HDD is mounted
:drive_check
if not exist %backupdir% (
	echo The backup drive is not present.
	echo Should be "%backupdir%"
	exit /b 1
) else (
	echo External HDD found.  Commencing backup....
	exit /b 0
)