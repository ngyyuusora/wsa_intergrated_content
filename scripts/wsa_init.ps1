# ������������ʵ���޸ģ�
$wsa_port = "58526"
$target_device = "localhost:$wsa_port"

# ǿ��ָ���豸����
function adbwsa {
    param([Parameter(ValueFromRemainingArguments)]$cmd)
    adb -s $target_device @cmd
}

# ---------- ������ ----------
# ����1�����ר���豸����
Write-Host "`n[1/3] ��֤WSA�豸����..." -ForegroundColor Cyan
$devices = adb devices | Where-Object { $_ -match "$target_device\s+device" }
if (-not $devices) {
    Write-Host "������������WSA..."
    $connect = adb connect $target_device
    if ($connect -notmatch "connected") {
        Write-Host "�޷����ӵ�WSA�����飺`n1. �Ƿ�������WSA`n2. ������ģʽ״̬`n3. ����ǽ����" -ForegroundColor Red
        exit
    }
}

# ����2��Shizuku�����⣨ǿ��ָ���豸��
Write-Host "`n[2/3] ����Shizuku..." -ForegroundColor Cyan
$shizuku_log = adbwsa shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh 2>&1
if ($LASTEXITCODE -eq 0 -and $shizuku_log -match "starting server") {
    Write-Host "״̬: �����Ѻ�̨����" -ForegroundColor Green
    adbwsa shell "ps -A | grep shizuku_server" | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "������֤: ����" -ForegroundColor DarkGreen
    }
}
else {
    Write-Host "�쳣��Ϣ��`n$shizuku_log" -ForegroundColor Yellow
}

# ����3��Breventִ�У��豸���룩
Write-Host "`n[3/3] ����Brevent..." -ForegroundColor Cyan
$brevent_result = adbwsa shell "sh /sdcard/Android/data/me.piebridge.brevent/brevent.sh" 2>&1
if ($brevent_result -match "checking for server..started") {
    Write-Host "���: ��������Ч" -ForegroundColor Green
}
else {
    Write-Host "������־��`n$brevent_result" -ForegroundColor Red
    Write-Host "����ԭ��`n1. Shizukuδ��Ȩ`n2. �豸δROOT`n3. �ű�·������" -ForegroundColor Magenta
}

Start-Sleep -Seconds 3  # �ӳ�3��
if ($Host.Name -eq 'ConsoleHost') { exit }
Read-Host "`n��Enter�˳�..."

