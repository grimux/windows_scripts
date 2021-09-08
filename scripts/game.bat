@echo off
SETLOCAL EnableDelayedExpansion
::
:: Game backup script
:: By Jake
::
:: This script is for managing my game saves.  With it I can back them up
::

::=========================================================================================
set "conf=S:\tools\scripts\game_save_locations.txt"
set "temp=S:\tools\scripts\temp.txt"
::=========================================================================================


:: Main Flow
::=========================================================================================
if "%1" == "" (
	call:help
	exit /b 0
)
if "%1" == "help" (
	call:help
	exit /b 0
)
if "%1" == "list" (
	call:list
	exit /b 0
)
if "%1" == "location" (
	call:location %*
	exit /b 0
)
if "%1" == "edit" (
	call:edit
	exit /b 0
)
if "%1" == "backup" (
	call:backup
	exit /b 0
)
if "%1" == "archive" (
	call:archive
	exit /b 0
)
if "%1" == "all" (
	call:backup
	call:archive
	exit /b 0
)
if "%1" == "restore" (
	call:restore %*
	exit /b 0
)
if "%1" == "delete" (
	call:delete %*
	exit /b 0
)
if "%1" == "revert" (
	call:revert %*
	exit /b 0
) else (
	echo Invalid command
	call:help
	exit /b 0
)
::=========================================================================================



::=========================================================================================
:: List
::------
:: List out the games
:list
echo[
for /f "delims=	 eol=# tokens=1,2" %%a in (%conf%) do (
	echo %%a
	if "%%a" == "arc" echo %%b
)
exit /b 0
::=========================================================================================



:: Location
::=========================================================================================
:: Print the location of the game's save (local)
:location
:: Remove first argument and take the rest
for /f "usebackq tokens=1*" %%i in (`echo %*`) DO @ set params=%%j
:: Loop through text file
for /f "delims=	 eol=# tokens=1,2,3" %%a in (%conf%) do (
	REM %%a=game name
	REM %%b=local save
	REM %%c=backup save
	if "%%a" == "%params%" (
		echo %%b
		exit /b 0
	)
)
echo Game not in list.
exit /b 1
::=========================================================================================


:: Edit
::=========================================================================================
:: Call to edit the game list
:edit
notepad++.exe %conf%
exit /b 0
::=========================================================================================



:: Backup
::=========================================================================================
:backup
echo Backing up saves...
echo[
:: Create temp file with archives removed
grep -G -v "arc.*" %conf% > %temp%
for /f "delims=	 eol=# tokens=1,2,3" %%a in (%temp%) do (
	REM %%a=game name
	REM %%b=local save
	REM %%c=backup save
	echo %%a
	if not exist %%b (
		echo Local save not found, skipping...
		exit /b 0
	)
	if not exist %%c echo Backup location not found...Creating...
	xcopy /IDEY "%%b" "%%c"
	echo[
)
del %temp%
exit /b 0
::=========================================================================================



:: Archive
::=========================================================================================
:: Backup folders in archive mode.  For example, emulators and Goldberg saves
:archive
echo Backing up archives...
echo[
:: Create a temporary file with only archives
grep -G "^arc" %conf% | sed "s/^arc\t*//" > %temp%
for /f "delims=	 eol=# tokens=1,2,3" %%a in (%temp%) do (
	REM %%a=game name
	REM %%b=local save
	REM %%c=backup save
	echo ================================================================
	echo %%a
	echo ----------------------------------------------------------------
	if not exist %%b (
		echo Local folder not found, skipping...
		exit /b 0
	)
	if not exist %%c echo Backup location not found...Creating...
	7z u -up1q0r2x1y2z1w2 -mx9 -mmt16 "%%c" "%%b"
	echo ================================================================
	echo[
	echo[
)
del %temp%
exit /b 0
::=========================================================================================



:: Restore
::=========================================================================================
:: Restore a game save
:restore
:: Remove first argument and take the rest
for /f "usebackq tokens=1*" %%i in (`echo %*`) DO @ set params=%%j

:: Loop through text file
for /f "delims=	 eol=# tokens=1,2,3" %%a in (%conf%) do (
	REM %%a=game name
	REM %%b=local save
	REM %%c=backup save
	if "%%a" == "%params%" (
		if not exist "%%c" (
			echo Backup save for %%a not found.
			exit /b 1
		)
		if exist "%%b" echo Local save already present. & exit /b 0
		echo Restoring %%a
		echo Backup save found, restoring...
		xcopy /IDEY "%%c" "%%b"
		echo Done, have fun^^!
		exit /b 0
	)
)

exit /b 0
::=========================================================================================



:: Delete
::=========================================================================================
:delete
:: Remove first argument and take the rest
for /f "usebackq tokens=1*" %%i in (`echo %*`) DO @ set params=%%j
:: Loop through text file
for /f "delims=	 eol=# tokens=1,2,3" %%a in (%conf%) do (
	REM %%a=game name
	REM %%b=local save
	REM %%c=backup save
	if "%%a" == "%params%" (
		if not exist "%%b" (
			echo Local save for %%a not found.
			exit /b 1
		)
		echo Deleting %%a
		echo Local save found, removing...
		rmdir /S /Q "%%b"
		echo Done
		exit /b 0
	)
)
exit /b 0
::=========================================================================================



:: Revert a save
::=========================================================================================
:revert
call:delete %*
echo[
call:restore %*
exit /b 0
::=========================================================================================



:: Help section
::=========================================================================================
:help
echo Usage: game (command) [game name]
echo[
echo backup				Backup saves
echo archive				Backup archives
echo all				Backup both saves and archives
echo restore (name of game)		Restore a save
echo delete (name of game)		Delete the local save
echo list				List all game names
echo edit				Edit the game list
exit /b 0
::=========================================================================================