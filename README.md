# perf-disk

fsync 磁盘延迟监控收集
 
 
## 使用工具

iotop 获取当前程序的io消耗。

pidstat 获取所有处于 Running 状态的进程。

iosnoop 获取 Block 层下发请求到驱动完成返回的时间。

funcgraph 获得 fsync 的调用函数的延迟。

## 使用环境

推荐将输出日志放在 tmpfs 等内存存储中，避免日志写IO对延迟测试造成影响

## 安装

```
yum install iotop
yum install sysstat 
git clone https://github.com/lhy1024/perf-disk.git
cd perf-disk
git clone https://github.com/brendangregg/perf-tools
```

将 perf-tools 和 perf.sh放在同一路径下，需要 root 权限。

如果遇到外网无法访问情况，可通过 yum reinstall --downloadonly --downloaddir=~  iotop sysstat 进行下载安装包。

## 使用

### 运行

因为 perf-tools 无法通过多实例运行，所以需要分开跑后两个测试。

`bash perf.sh start pd-server /home/lhy1024 funcgraph`

`bash perf.sh start pd-server /home/lhy1024 iosnoop`

### 停止

`bash perf.sh close pd-server /home/lhy1024 all`

### 观测

`bash perf.sh observe`

可通过此命令观测程序是否正常关闭或启动

### 清理

如果发现 iosnoop 或 funcgraph 无法正常运行，且日志中查看到`ERROR: ftrace may be in use by PID 186161 /var/tmp/.ftrace-lock`，请关闭其他使用 ftrace 程序，如果仍然无法运行，可执行 `bash perf.sh clean`
