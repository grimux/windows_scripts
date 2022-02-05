@echo off

rem this script is meant to be run from Notepad++, to easily render markdown files into pdfs

rem %~1 argument is full path to file
rem %~2 argument is path to file, minus extension
rem run command for notepad++ is "S:\tools\scripts\render_markdown.bat $(FULL_CURRENT_PATH) $(CURRENT_DIRECTORY)\$(NAME_PART)"
rem remember to delete pdf files if run by accident

wsl -d Arch -- pandoc $(wslpath "%~1") -o $(wslpath "%~2.pdf")
start /b SumatraPDF.exe "%~2.pdf"