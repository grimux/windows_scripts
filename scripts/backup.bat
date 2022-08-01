@echo off

::
:: Backup script
:: By Jake
::
:: This script is for backing up my important files
:: External media is used for the backup, such as a portable hard drive.
::

:: Directory locations
set "backup_dir_small=D:\Backups"
set "backup_dir_large=Z:"
set "local_dir=S:"
set "docs-jake=documents"

:: Flags
set is_small_connected=0
set is_large_connected=0

:: Flow
if "%1" == "" (
	call:help
	exit /b 0
)
if "%1" == "help" (
	call:help
	exit /b 0
)
if "%1" == "space" (
	call:drive_space
	exit /b 0
)

:: Check for external hard drive, if not attached exit script
call:drive_check_small && set is_small_connected=1
call:drive_check_large && set is_large_connected=1

if "%1" == "docs" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:docs
	exit /b 0
)
if "%1" == "wsl" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:wsl
	exit /b 0
) 
if "%1" == "settings" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:settings
	exit /b 0
)
if "%1" == "screenshots" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:screenshots
	exit /b 0
)
if "%1" == "pictures" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:pictures
	exit /b 0
)
if "%1" == "music" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:music
	exit /b 0
)
if "%1" == "all" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:docs
	call:settings
	call:pictures
	call:music
	call:screenshots
	exit /b 0
)
if "%1" == "restore" (
	if "%is_small_connected%" == "0" (exit /b 1)
	call:restore
	exit /b 0
 )
if "%1" == "share" (
	if "%is_large_connected%" == "0" (exit /b 1)
	call:share
	exit /b 0
)
if "%1" == "status" (
	if "%is_small_connected%" == "0" (exit /b 1)
	if "%is_large_connected%" == "0" (exit /b 1)
	call:status
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
call:robocopy_backup S:\documents\ %backup_dir_small%\docs-jake
call:robocopy_backup S:\documents-serena\ %backup_dir_small%\docs-serena
call:robocopy_backup X:\shared-documents\ %backup_dir_small%\docs-shared
call:robocopy_backup S:\tools\ %backup_dir_small%\tools-jake
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
ROBOCOPY.EXE X:\archive-jake\Backups\wsl %backup_dir_small%\wsl /E /J /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16 /NJH /NJS /ETA /XO
rem xcopy /DEY /J X:\archive-jake\Backups\wsl %backup_dir_small%\wsl
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Settings backup
:settings
echo ====================================================================
echo Backing up settings...
echo --------------------------------------------------------------------
7z u -up1q0r2x1y2z1w2 -mx9 -mmt16 %backup_dir_small%\settings-jake\my_settings.7z X:\archive-jake\my-settings
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Screenshots and wallpapers
:screenshots
echo ====================================================================
echo Backing up screenshots and wallpapers...
echo --------------------------------------------------------------------
call:robocopy_backup S:\game-screenshots\ %backup_dir_small%\game-screenshots-jake
call:robocopy_backup S:\wallpapers\ %backup_dir_small%\wallpapers-jake
call:robocopy_backup S:\screenshots\ %backup_dir_small%\screenshots-jake
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Pictures
:pictures
echo ====================================================================
echo Backing up pictures...
echo --------------------------------------------------------------------
call:robocopy_backup X:\Pictures\ %backup_dir_small%\pictures
echo[
echo Done!
echo ====================================================================
exit /b 0


:: Music
:music
echo ====================================================================
echo Backing up music...
echo --------------------------------------------------------------------
call:robocopy_backup S:\music\ %backup_dir_small%\music
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
ROBOCOPY.EXE %backup_dir_small%\docs-jake\ S:\documents /L /E /XO /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
choice /M "Would you like to continue?"
if ERRORLEVEL 2 exit /b 0
ROBOCOPY.EXE %backup_dir_small%\docs-jake\ S:\documents /E /XO /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:16
exit /b 0

:: Share drive backup
:share
echo ====================================================================
echo Backing up share drive to %backup_dir_large%
echo --------------------------------------------------------------------
echo[
ROBOCOPY.EXE X:\ %backup_dir_large%\ /E /J /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:64
exit /b 0

:: Status
:status
echo ====================================================================
echo File changes
echo --------------------------------------------------------------------
echo This is a log of changes for robocopy.
echo[
pause
cls
call:robocopy_status S:\documents\ %backup_dir_small%\docs-jake
echo[
pause
cls
call:robocopy_status S:\documents-serena\ %backup_dir_small%\docs-serena
echo[
pause
cls
call:robocopy_status X:\shared-documents\ %backup_dir_small%\docs-shared
echo[
pause
cls
call:robocopy_status S:\tools\ %backup_dir_small%\tools-jake
echo[
pause
cls
call:robocopy_status S:\game-screenshots\ %backup_dir_small%\game-screenshots-jake
echo[
pause
cls
call:robocopy_status S:\wallpapers\ %backup_dir_small%\wallpapers-jake
echo[
pause
cls
call:robocopy_status S:\screenshots\ %backup_dir_small%\screenshots-jake
echo[
pause
cls
call:robocopy_status X:\Pictures\ %backup_dir_small%\pictures
echo[
pause
cls
call:robocopy_status S:\music\ %backup_dir_small%\music
echo[
pause
cls
call:robocopy_status X:\ %backup_dir_large%\
exit /b 0


rem Robocopy backup
:robocopy_backup
ROBOCOPY.EXE %~1 %~2 /E /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:64
exit /b 0

:: status
:robocopy_status
ROBOCOPY.EXE %~1 %~2 /E /L /DCOPY:DAT /MIR /XA:S /R:1 /W:3 /MT:64
exit /b 0

:: Help Section
:help
echo Usage: backup (command) [flags]
echo Backup important files to external media.
echo[
echo docs		Backup documents
echo settings	Backup settings (windows, linux, dotfiles...)
echo screenshots	Backup screenshots and wallpapers
echo pictures	Backup pictures
echo music		Backup music
echo all		All of the above
echo[
echo wsl		Backup wsl
echo restore		Restore files
echo share		Backup Share-Drive to other backup drive
echo space		Show current space avalible
echo status		Show file changes, robocopy /L
exit /b 0

:: Check if external HDD is mounted
:drive_check_small
if not exist %backup_dir_small% (
	echo The small backup drive is not present.  Should be "%backup_dir_small%"
	exit /b 1
) else (
	echo "%backup_dir_small%" found.
	exit /b 0
)

:drive_check_large
if not exist %backup_dir_large% (
	echo The large backup drive is not present.  Should be "%backup_dir_large%"
	exit /b 1
) else (
	echo "%backup_dir_large%" found.
	exit /b 0
)

:drive_space
echo[

rem Used space in share-drive X:
for /f "tokens=*" %%a in ('powershell -Command "[math]::Round(((get-volume X).Size - (get-volume X).SizeRemaining) / 1TB, 2)"') do set large_space=%%a

rem Total space in backup-drive Z:
for /f "tokens=*" %%b in ('powershell -Command "[math]::Round((get-volume Z).Size / 1TB, 2)"') do set backup_space=%%b

echo X Used: %large_space% TB
echo Z Total: %backup_space% TB
echo[
echo Keep X ^< Z

exit /b 0