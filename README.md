Windows Scripts
===============

This is my collection of scripts I've written for Windows.  They control various things such as my Windows Hotkeys, WSL, backups, and game saves.

This is my attempt to preserve my scripts forever.

autohotkey
----------

After you have installed `AutoHotKey`, compile the `*.ahk` files into `.exe` files.  Then, create a shortcut to `run_wsl2_at_startup.exe` and `my_keybinds.exe` and place them into the startup directory.  To access, `win+r` then type `shell:startup`.  The `start_wsl.exe` script is for binding to the keyboard.  It will launch my DE in WSL.

vcxsrv
------

`vcxsrv` is required for WSL GUI programs to work, and for my DE.  As long as it is installed in the default location, the scripts should work.  There are two configs for `vcxsrv`.  `vcxsrv/config.xlaunch` is for and GUI programs launched while on the Windows side.  `vcxsrv/fullscreen.xlaunch` is for the DE.

Scripts
--------
TODO: expand
Be sure to add the `scripts` directory to the Windows `PATH`.

WSL
----
TODO: expand
The WSL scripts rely upon `SystemTrayRefresh.exe` to get rid of non-working icons.  It can be downloaded [here](https://www.majorgeeks.com/files/details/system_tray_refresh.html).  I also added it to the repo.
