# 捋

* 可以从已有的image_dockerfile构建新的dockerfile，这样就可以设置一下sshfs直连，不过ubuntu总归是要打开的，直接挂载docker到ubuntu里然后sshfs连ubuntu就行
* 可以把容器打包成image，时间应该不长
* run启动-rm删除 start重开已有-stop关闭 exec可以在终端执行
* docker run -it -v ~/docp:/root/chipyard/sims/verilator/mnt registry.cn-hangzhou.aliyuncs.com/chipyard-lwh/chipyard:1.8.1 bash
  * 会把ubuntu下的docp和新建的一个mnt同步
  * 然后用xterm或sshfs连ubuntu就行
* 直接复制也可以
  * docker ps查看id
  * docker cp 68710303b65a:/root/chipyard/sims/verilator/output ~/docpp
  * docker cp my_container:/app/file.txt /host/path
