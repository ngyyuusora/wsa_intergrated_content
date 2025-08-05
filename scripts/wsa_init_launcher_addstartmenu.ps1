$batPath = 'D:\Program Files\WSABuilds\wsa_init_launcher.bat'
$shortcutDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\WSA Tools\"

# ������ݷ�ʽĿ¼
New-Item -Path $shortcutDir -ItemType Directory -Force | Out-Null

# ���ɿ�ݷ�ʽ
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut("$shortcutDir\wsa_init.lnk")
$shortcut.TargetPath = $batPath
$shortcut.WorkingDirectory = Split-Path $batPath
#$shortcut.WindowStyle = 7  # ���ش���ģʽ
$shortcut.IconLocation = "$env:SystemRoot\System32\SHELL32.dll, 12"  # ����ͼ��
$shortcut.Save()
