@echo off
:: wsa_launcher.bat
:: 存放路径：D:\Program Files\WSABuilds\
:: 执行时无任何窗口弹出

setlocal
cd /d "%~dp0" 2>&1 >nul
:: start "" /B powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "wsa_init.ps1"
start "" /B powershell -NoProfile -ExecutionPolicy Bypass -File "wsa_init.ps1"
endlocal
exit
