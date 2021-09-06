@echo off

::
:: Backup script
:: By Jake
::
:: This script is for backing up my important files
:: External media is used for the backup, such as a portable hard drive.
::

set "backupdir=D:\Backups"

if not exist %backupdir% (
	echo The backup drive is not present.
	echo Should be "%backupdir%"
	exit /b 1
)

if "%1" == "" (
	goto:help
	exit /b 0
)
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
if "%1" == "all" (
	goto:docs
	goto:wsl
	goto:settings
	exit /b 0
) else (
	echo Invalid command.
	goto:help
	exit /b 0
)

:: Document and tools backup
:docs
ROBOCOPY.EXE S:\documents\ %backupdir%\docs-jake /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE S:\documents-serena\ %backupdir%\docs-serena /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE X:\shared-documents\ %backupdir%\docs-shared /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
ROBOCOPY.EXE S:\tools\ %backupdir%\tools-jake /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
exit /b 0


:: wsl backup
:wsl
echo Backing up Arch wsl install...
wsl --export Arch X:\archive-jake\Backups\wsl\wsl_arch.tar.gz
echo Done.
exit /b 0


:: Settings backup
:settings
7z u -up1q0r2x1y2z1w2 -mx9 -mmt16 %backupdir%\settings-jake\my_settings.7z X:\archive-jake\my-settings
exit /b 0


:: Help Section
:help
echo Usage: backup (command) [flags]
echo Backup important files to external media.
echo[
echo docs		Backup documents
echo wsl		Backup wsl
echo settings	Backup settings (windows, linux, dotfiles...)
echo all		All of the above
exit /b 0