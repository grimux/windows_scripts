;Close active window
#q::WinClose A

; Firefox Browser
#w::
	Run, C:\Program Files\Mozilla Firefox\firefox.exe
	WinWait, ahk_exe firefox.exe
	WinActivate
Return

; Launch Foobar2000
#m::
	Run, C:\Program Files (x86)\foobar2000\foobar2000.exe
	WinWait, ahk_exe foobar2000.exe
	WinActivate
Return

; Notepad++
#+n::
	Run, notepad++.exe
	WinWait, ahk_exe notepad++.exe
	WinActivate
Return

; Universal Media Server
#+u::
	Run, C:\Program Files (x86)\Universal Media Server\UMS.exe
	WinWait, ahk_exe UMS.exe
	WinActivate
Return

; JDownloader
#+d::
	Run, C:\Users\user\scoop\apps\jdownloader\current\JDownloader.bat
	WinWait, ahk_exe javaw.exe
	WinActivate
Return

; qtpass
#+p::
	Run, C:\Program Files (x86)\QtPass\qtpass.exe
	WinWait, ahk_exe qtpass.exe
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
