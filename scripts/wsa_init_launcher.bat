@echo off
:: wsa_launcher.bat
:: ���·����D:\Program Files\WSABuilds\
:: ִ��ʱ���κδ��ڵ���

setlocal
cd /d "%~dp0" 2>&1 >nul
:: start "" /B powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "wsa_init.ps1"
start "" /B powershell -NoProfile -ExecutionPolicy Bypass -File "wsa_init.ps1"
endlocal
exit
