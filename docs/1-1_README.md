# 准备工作

## 启用“虚拟机平台"
- 系统设定导航至`可选功能`
- 打开传统界面的`更多Windows功能`
- 确认启用`虚拟机平台`
- 重新启动

因win11翻译问题，可能会显示为`Virtual Machine Platform`。
也可以通过WSABuilds的`Run.bat`自动启用，但推荐提前确保启用。

## （可选）安装adb
- 打开`adb-setup-1.4.3.zip`中的安装程序
- 安装完成后将`adb_platform-tools-r36-windows.zip`中的文件覆盖至`C:\adb`中进行替换

# 安装WSABuilds
## 释放安装文件
选择目标版本后，将安装包内容`WSA_*_*`文件夹中内容释放至`D:\Program Files\WSABuilds`内。

## 安装
(无需手动选择管理员权限运行)打开`Run.bat`，即开始自动安装。安装完成后会自动启动子系统并弹出部分界面，确认安装窗口提示`Press any key to quit`无异常可关闭，安装完成。

## 基础配置
- 打开`适用于Android的Windows子系统`
- 确认`阻止安装恶意应用`关闭
- 导航至`高级设置`
- 打开`开发人员模式`
- 打开`实验性功能-共享用户文件夹`
- 选择`实验性功能-Vulkan驱动程序`为`系统默认`
- 打开`开发人员模式-管理开发人员模式`

如可正常弹出开发者选项，配置完成，如不能正确弹出界面，将`实验性功能-Vulkan驱动程序`选择为`D3D12`后重试。

# 配置自动化脚本及调试
## 导入脚本至系统
将`scripts`文件夹内的全部文件复制至`D:\Program Files\WSABuilds`内，使用**管理员权限的终端**导航至`D:\Program Files\WSABuilds`。
```
 cd "D:\Program Files\WSABuilds"
```
运行`wsa_init_addtask.ps1`以添加开机自动启动计划任务。
运行`wsa_init_launcher_addstartmenu.ps1`以添加开始菜单项目。

## 调试
运行开始菜单项目中的`wsa_init`，应看到提示确认调试授权的对话框，选择始终允许。启动任意终端，检查是否可列出子系统设备。`adb devices`应看到：
```
List of devices attached
localhost:58526 device
```

## 安装应用
使用任意终端，导航至apk安装包文件所在文件夹，使用以下命令即可向子系统内安装应用，也可以通过安装到子系统中的文件管理器访问apk文件直接安装。
**路径中不可含有非unicode(中文
```
adb install <apk完整文件名>
```

# (可选)迁移子系统数据至其他目录
## 基础流程
- 打开`%LOCALAPPDATA%\Pacakges`
- 定位目录`MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe`
- 将该目录`MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe`复制至目标目录
- 确认子系统已停止运行
- **确认复制成功，否则会丢失现有数据**
- 删除`%localappdata%\Pacakges`中的`MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe`
- 使用管理员权限执行如下命令后，即可重新启动子系统
```
mklink /J "%LOCALAPPDATA%\Packages\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe" "<目标目录>\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe"
```
## 示例操作
以希望迁移数据至`D:\Program Files\WSAPackages`为例:
- 将`%LOCALAPPDATA%\Pacakges\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe`复制至`D:\Program Files\WSAPackages`内
- 确认子系统已停止运行
- 删除`%LOCALAPPDATA%\Pacakges\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe`
```
mklink /J "%LOCALAPPDATA%\Packages\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe" "D:\Program Files\WSAPackages\MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe"
```