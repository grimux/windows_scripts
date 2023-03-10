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
if "%1" == "prune" (
	call:prune
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
)
if "%1" == "open" (
	call:open %*
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
	if "%%a" == "arc" (
		echo %%b
	) else echo %%a
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


:edit
::=========================================================================================
:: Call to edit the game list
notepad++.exe %conf%
exit /b 0
::=========================================================================================


:backup
::=========================================================================================
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
	)
	if not exist %%c echo Backup location not found...Creating...
	xcopy /IDEY "%%b" "%%c"
	rem call:check_structure "%%b" "%%c"
	echo[
)
del %temp%
exit /b 0
::=========================================================================================


:prune
echo It is recommended to backup saves before pruning.
choice /M "Would you like to now?"
if !ERRORLEVEL! == 1 (
	call:backup
	echo done
	echo Pruning will now commence
	echo[
	pause
)
echo Pruning old save files...
echo[
set "dir_a=S:\tools\scripts\dir_a.txt"
set "dir_b=S:\tools\scripts\dir_b.txt"
:: Create temp file with archives removed
grep -G -v "arc.*" %conf% > %temp%
for /f "delims=	 eol=# tokens=1,2,3" %%a in (%temp%) do (
	REM %%a=game name
	REM %%b=local save
	REM %%c=backup save
	echo %%a
	call:check_structure "%%b" "%%c"
	if !ERRORLEVEL! == 1 (
		rem call:prune_files "%%b" "%%c"
		echo Extra files found. Running robocopy...
		robocopy "%%b" "%%c" /L /E /DCOPY:DAT /MIR /R:1 /W:3 /MT:16
		echo Please check the above files and make sure they are okay to delete.
		choice /M "Do you want to remove the above files?"
		if !ERRORLEVEL! == 1 (robocopy "%%b" "%%c" /E /DCOPY:DAT /MIR /R:1 /W:3 /MT:16)
	) else echo Files match
	echo[
)
del %dir_a% %dir_b% %temp%
exit /b 0

:check_structure
dir /b /s "%~1" | wc -l > %dir_a%
dir /b /s "%~2" | wc -l > %dir_b%
comp "%dir_a%" "%dir_b%" /m >NUL
rem echo !ERRORLEVEL!
exit /b !ERRORLEVEL!


:archive
::=========================================================================================
:: Backup folders in archive mode.  For example, emulators and Goldberg saves
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
	if exist %%b (
		if not exist %%c echo Backup location not found...Creating...
		if exist "%%c.tmp" (
			echo Temporary file found...Deleting...
			del /Q "%%c.tmp"
		)
		7z u -up1q0r2x1y2z1w2 -mx9 -mmt16 "%%c" "%%b"
	) else echo Local folder not found, skipping...

	echo ================================================================
	echo[
	echo[
)
del %temp%
exit /b 0
::=========================================================================================




::=========================================================================================
:: Restore a game save
:: Remove first argument and take the rest
:restore
for /f "usebackq tokens=1*" %%i in (`echo %*`) DO @ set params=%%j

:: Loop through text file
for /f "delims=	 eol=# tokens=1,2,3,4" %%a in (%conf%) do (
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
	REM %%a=arc
	REM %%b=game name
	REM %%c=local save
	REM %%d=backup save
	if "%%a" == "arc" if "%%b" == "%params%" (
		if not exist "%%d" (
			echo Backup archive for %%b does not exist.
			exit /b 1
		)
		if exist "%%c" echo Local archive already present & exit /b 0
		echo Restoring archive %%b
		echo Archive found.
		7z x -mmt9 "%%d" -o"%%c/../"
		echo Done, have fun ^^!
		exit /b 0
	) 
)
echo Game not in list.
exit /b 0
::=========================================================================================



:delete
::=========================================================================================
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
	REM %%a=arc
	REM %%b=game name
	REM %%c=local save
	REM %%d=backup save
	if "%%a" == "arc" if "%%b" == "%params%" (
		if not exist "%%c" (
			echo Local archive for %%b does not exist.
			exit /b 1
		)
		echo Deleting %%b
		echo Local archive found, removing...
		rmdir /S /Q "%%c"
		echo Done
		exit /b 0
	)
)
echo Game not in list.
exit /b 0
::=========================================================================================


:revert
::=========================================================================================
call:delete %*
echo[
call:restore %*
exit /b 0
::=========================================================================================


:open
::=========================================================================================
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
		echo Local save found, opening...
		start "%%a" "%%b"
		rem start "%%b" "%%c"
		echo Done
		exit /b 0
	)
	REM %%a=arc
	REM %%b=game name
	REM %%c=local save
	REM %%d=backup save
	if "%%a" == "arc" if "%%b" == "%params%" (
		if not exist "%%c" (
			echo Local archive for %%b does not exist.
			exit /b 1
		)
		echo Local archive found, removing...
		start "%%b" "%%c"
		rem start "%%b" "%%d"
		echo Done
		exit /b 0
	)
)
echo Game not in list.
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
echo prune				Remove orphaned saves in share drive
echo restore (name of game)		Restore a save
echo delete (name of game)		Delete the local save
echo list				List all game names
echo edit				Edit the game list
exit /b 0
::=========================================================================================
