# 以管理员身份运行此脚本

# 配置参数
$initScriptPath = 'D:\Program Files\WSABuilds\wsa_init.ps1'
$taskName = "WSABootInitializer"
$delaySeconds = 120  # 延迟时间(秒)

# 检测管理员权限
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "请以管理员身份运行此脚本" -ForegroundColor Red
    exit
}

# 构建执行命令
$powershellCmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$initScriptPath`""

# 删除已有任务(如果存在)
try {
    schtasks /DELETE /TN $taskName /F 2>&1 | Out-Null
    Write-Host "已清除旧任务" -ForegroundColor Yellow
} catch {}

# 创建XML任务定义
$xmlTemplate = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>WSA初始化服务</Description>
  </RegistrationInfo>
  <Triggers>
    <BootTrigger>
      <Enabled>true</Enabled>
      <Delay>PT$($delaySeconds)S</Delay>
    </BootTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <Hidden>true</Hidden>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>5</Priority>
  </Settings>
  <Actions>
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>-ExecutionPolicy Bypass -WindowStyle Hidden -File "$initScriptPath"</Arguments>
    </Exec>
  </Actions>
</Task>
"@

# 临时保存XML
$tempXmlPath = "$env:TEMP\WSAStartupTask.xml"
$xmlTemplate | Out-File $tempXmlPath -Encoding Unicode

# 注册任务计划
try {
    schtasks /Create /XML $tempXmlPath /TN $taskName /F
    Write-Host "开机任务创建成功" -ForegroundColor Green
    Write-Host "├─ 任务名称: $taskName"
    Write-Host "├─ 触发时机: 系统启动后延迟 ${delaySeconds}秒"
    Write-Host "└─ 静默模式: 隐藏窗口执行"
} catch {
    Write-Host "任务创建失败: $_" -ForegroundColor Red
}

# 清理临时文件
Remove-Item $tempXmlPath -Force
