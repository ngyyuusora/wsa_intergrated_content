# wsa_intergrated_content
适用于Windows安卓子系统的使用体验提升资料。

Regards to [WSABuilds](https://github.com/MustardChef/WSABuilds).

# 2025s3安装问题

原因见[问题讨论](https://github.com/MustardChef/WSABuilds/issues/593)，请按照[0-1_系统更新问题.md]https://github.com/ngyyuusora/wsa_intergrated_content/blob/main/docs/0-1_%E7%B3%BB%E7%BB%9F%E6%9B%B4%E6%96%B0%E9%97%AE%E9%A2%98.md操作。

# 目录
## apks
- 黑阀/黑域/黑阈/brevent(me.piebridge.brevent)
- MiXplorer(com.mixplorer)
- AppOps(rikka.appops)
- Shizuku(moe.shizuku.privilege.api)
- LibChecker(com.absinthe.libchecker)
内建资源文件为**原版**apk文件，感谢原作者的精品应用和工作，如侵权请联系删除。

## docs
- 0-1_系统更新问题.md
- 1-1_README.md
- 2-1_黑阀.md

## scripts
- wsa_init.ps1
通过127.1:58526启动brevent及shizuku
- wsa_init_addtask.ps1
添加`wsa_init.ps1`至计划任务
- wsa_init_launcher.bat
用于无感启动`wsa_init.ps1`
- wsa_init_launcher_addstartmenu.ps1
添加`wsa_init_launcher.bat`至开始菜单

部分配置如任务计划名、部署目录请自行修改。
