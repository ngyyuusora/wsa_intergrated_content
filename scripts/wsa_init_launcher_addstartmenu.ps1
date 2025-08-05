$batPath = 'D:\Program Files\WSABuilds\wsa_init_launcher.bat'
$shortcutDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\WSA Tools\"

# 创建快捷方式目录
New-Item -Path $shortcutDir -ItemType Directory -Force | Out-Null

# 生成快捷方式
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut("$shortcutDir\wsa_init.lnk")
$shortcut.TargetPath = $batPath
$shortcut.WorkingDirectory = Split-Path $batPath
#$shortcut.WindowStyle = 7  # 隐藏窗口模式
$shortcut.IconLocation = "$env:SystemRoot\System32\SHELL32.dll, 12"  # 齿轮图标
$shortcut.Save()
