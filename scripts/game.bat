@echo off
SETLOCAL EnableDelayedExpansion
::
:: Game backup script
:: By Jake
::
:: This script is for managing my game saves.  With it I can back them up
::

set "conf=S:\tools\scripts\game_save_locations.txt"

if "%1" == "" (
	call:help
	exit /b 0
)
if "%1" == "-h" (
	call:help
	exit /b 0
)
if "%1" == "list" (
	call:list
	exit /b 0
)
if "%1" == "backup" (
	call:backup
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


:: List
:list
echo[
for /f "delims=	 eol=# tokens=1,2" %%a in (%conf%) do (
	echo %%a
	if "%%a" == "arc" echo %%b
)
exit /b 0

:: Backup
:backup
echo Backing up saves...
echo[
for /f "delims=	 eol=# tokens=1,2,3" %%a in (%conf%) do (
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
exit /b 0

:: Restore
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

:: Delete
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

:: Revert a save
:revert
call:delete %*
echo[
call:restore %*
exit /b 0


:: Help section
:help
echo Usage: game (command) (flags)
exit /b 0
