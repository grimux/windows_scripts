; Spawn terminal
#Enter::
	Run, wt --fullscreen
	WinWait, ahk_exe wt.exe
	WinActivate
Return

; Start xserver for wsl
#s::Run, toggle-vcxsrv.cmd

; Close active window
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
	WinWait, ahk_exe javaw.exe
	WinActivate
Return

; JDownloader
#+d::
	Run, C:\Users\user\scoop\apps\jdownloader\current\JDownloader.bat
	WinWait, ahk_exe javaw.exe
	WinActivate
Return

; DoubleCMD
#y::
	Run, C:\Program Files\Double Commander\doublecmd.exe
	WinWait, ahk_exe doublecmd.exe
	WinActivate
Return

; Calculator
#c::
	Run, calc1.exe
	WinWait, ahk_exe calc1.exe
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

; Open my wiki in browser
#+w::
	Run, explorer S:\documents\vimwiki\_site\index.html
	WinWait, ahk_exe firefox.exe
	WinActivate
Return

; Toggle between window maximize/restore
#f::
	WinGet MX, MinMax, A
	If MX
		WinRestore A
	Else WinMaximize a
Return

; Remove default Windows shortcuts
#;::
#l::

; Toggle hidden files
#h::
RegRead, ValorHidden, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden

if ValorHidden = 2 
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
Else
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2

send {F5}

Return
