# �Թ���Ա������д˽ű�

# ���ò���
$initScriptPath = 'D:\Program Files\WSABuilds\wsa_init.ps1'
$taskName = "WSABootInitializer"
$delaySeconds = 120  # �ӳ�ʱ��(��)

# ������ԱȨ��
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "���Թ���Ա������д˽ű�" -ForegroundColor Red
    exit
}

# ����ִ������
$powershellCmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$initScriptPath`""

# ɾ����������(�������)
try {
    schtasks /DELETE /TN $taskName /F 2>&1 | Out-Null
    Write-Host "�����������" -ForegroundColor Yellow
} catch {}

# ����XML������
$xmlTemplate = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>WSA��ʼ������</Description>
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

# ��ʱ����XML
$tempXmlPath = "$env:TEMP\WSAStartupTask.xml"
$xmlTemplate | Out-File $tempXmlPath -Encoding Unicode

# ע������ƻ�
try {
    schtasks /Create /XML $tempXmlPath /TN $taskName /F
    Write-Host "�������񴴽��ɹ�" -ForegroundColor Green
    Write-Host "���� ��������: $taskName"
    Write-Host "���� ����ʱ��: ϵͳ�������ӳ� ${delaySeconds}��"
    Write-Host "���� ��Ĭģʽ: ���ش���ִ��"
} catch {
    Write-Host "���񴴽�ʧ��: $_" -ForegroundColor Red
}

# ������ʱ�ļ�
Remove-Item $tempXmlPath -Force
