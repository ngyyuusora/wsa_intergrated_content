# 配置区（根据实际修改）
$wsa_port = "58526"
$target_device = "localhost:$wsa_port"

# 强制指定设备函数
function adbwsa {
    param([Parameter(ValueFromRemainingArguments)]$cmd)
    adb -s $target_device @cmd
}

# ---------- 主流程 ----------
# 步骤1：检测专属设备连接
Write-Host "`n[1/3] 验证WSA设备连接..." -ForegroundColor Cyan
$devices = adb devices | Where-Object { $_ -match "$target_device\s+device" }
if (-not $devices) {
    Write-Host "尝试重新连接WSA..."
    $connect = adb connect $target_device
    if ($connect -notmatch "connected") {
        Write-Host "无法连接到WSA，请检查：`n1. 是否已启动WSA`n2. 开发者模式状态`n3. 防火墙设置" -ForegroundColor Red
        exit
    }
}

# 步骤2：Shizuku服务检测（强制指定设备）
Write-Host "`n[2/3] 启动Shizuku..." -ForegroundColor Cyan
$shizuku_log = adbwsa shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh 2>&1
if ($LASTEXITCODE -eq 0 -and $shizuku_log -match "starting server") {
    Write-Host "状态: 服务已后台运行" -ForegroundColor Green
    adbwsa shell "ps -A | grep shizuku_server" | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "进程验证: 存在" -ForegroundColor DarkGreen
    }
}
else {
    Write-Host "异常信息：`n$shizuku_log" -ForegroundColor Yellow
}

# 步骤3：Brevent执行（设备隔离）
Write-Host "`n[3/3] 激活Brevent..." -ForegroundColor Cyan
$brevent_result = adbwsa shell "sh /sdcard/Android/data/me.piebridge.brevent/brevent.sh" 2>&1
if ($brevent_result -match "checking for server..started") {
    Write-Host "结果: 黑域已生效" -ForegroundColor Green
}
else {
    Write-Host "错误日志：`n$brevent_result" -ForegroundColor Red
    Write-Host "可能原因：`n1. Shizuku未授权`n2. 设备未ROOT`n3. 脚本路径错误" -ForegroundColor Magenta
}

Start-Sleep -Seconds 3  # 延迟3秒
if ($Host.Name -eq 'ConsoleHost') { exit }
Read-Host "`n按Enter退出..."

