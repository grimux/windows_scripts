@echo off

set log=failed_archives.txt

echo 7z archives > %log%
echo ------------------------------ >> %log%
for /r .\ %%x in (*.7z) do (
	7z t "%%x"
	if errorlevel == 1 (
		echo %%x >> %log%
	)
)
echo ------------------------------ >> %log%
echo[ >> %log%
echo zip archives >> %log%
echo ------------------------------- >> %log%
for /r .\ %%x in (*.zip) do (
	7z t "%%x"
	if errorlevel == 1 (
		echo %%x >> %log%
	)
)