;Close active window
#q::WinClose A

; Brave Browser
#w::
	Run, C:\Users\user\AppData\Local\BraveSoftware\Brave-Browser\Application\brave.exe
	WinWait, ahk_exe brave.exe
	WinActivate
Return

; Launch Foobar2000
#m::
	Run, C:\Program Files (x86)\foobar2000\foobar2000.exe
	WinWait, ahk_exe foobar2000.exe
	WinActivate
Return

; Bulk Crap Uninstaller
#u::
	Run, C:\Program Files\BCUninstaller\win-x64\BCUninstaller.exe
	WinWait, ahk_exe BCUninstaller.exe
	WinActivate
Return

; Toggle hidden files
#h::
RegRead, ValorHidden, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden

if ValorHidden = 2 
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
Else
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2

send {F5}

Return