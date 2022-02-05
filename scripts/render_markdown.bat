@echo off


wsl -d Arch -- pandoc $(wslpath "%~1") -o $(wslpath "%~1.pdf")
start /b SumatraPDF.exe "%~1.pdf"