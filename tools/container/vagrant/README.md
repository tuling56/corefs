##vagrant学习笔记
[TOC]

### 基础

三步使用法：

```
 $ vagrant box add {title} {url}
 $ vagrant init {title}
 $ vagrant up
```

#### 安装

##### [安装virtualbox](http://www.fedora.hk/linux/zhuomian/show_43.html)

```shell
# 添加版本库
cd /etc/yum.repos.d
# wget http://yum.oracle.com/public-yum-ol6.repo # 这个有问题
wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
yum clean all

yum install VirtualBox-5.0
```

> 这部分遇到问题，暂时还没有解决

##### 安装vagrant

从vagrant官网下载vagrant_xx.rpm安装包

```shell
rmp -ivh vagrant_xx.rpm
```

#### 使用

```shell
$ vagrant init  # 初始化
$ vagrant up  # 启动虚拟机
$ vagrant halt  # 关闭虚拟机
$ vagrant reload  # 重启虚拟机
$ vagrant ssh  # SSH 至虚拟机
$ vagrant status  # 查看虚拟机运行状态
$ vagrant destroy  # 销毁当前虚拟机
```

| 命令            | 详细解释                                     |
| ------------- | ---------------------------------------- |
| box           | manages boxes: installation, removal, etc. |
| connect       | connect to a remotely shared Vagrant environment |
| destroy       | stops and deletes all traces of the vagrant machine |
| global-status | outputs status Vagrant environments for this user |
| halt          | stops the vagrant machine                |
| help          | shows the help for a subcommand          |
| init          | initializes a new Vagrant environment by creating a Vagrantfile |
| login         | log in to HashiCorp’s Atlas              |
| package       | packages a running vagrant environment into a box |
| plugin        | manages plugins: install, uninstall, update, etc. |
| port          | displays information about guest port mappings |
| powershell    | connects to machine via powershell remoting |
| provision     | provisions the vagrant machine           |
| push          | deploys code in this environment to a configured destination |
| rdp           | connects to machine via RDP              |
| reload        | restarts vagrant machine, loads new Vagrantfile configuration |
| resume        | resume a suspended vagrant machine       |
| share         | share your Vagrant environment with anyone in the world |
| snapshot      | manages snapshots: saving, restoring, etc. |
| ssh           | connects to machine via SSH              |
| ssh-config    | outputs OpenSSH valid configuration to connect to the machine |
| status        | outputs status of the vagrant machine    |
| suspend       | suspends the machine                     |
| up            | starts and provisions the vagrant environment |
| version       | prints current and latest Vagrant version |

##### 下载box镜像文件

[官网box列表](http://www.vagrantbox.es/)

```shell
vagrant box add hashicorp/precise64
# 注意如果box add后不加名称，则默认使用镜像文件的名称
# 其它添加box的方法
# 1.提前下载好的box文件，~/box/precise64.box，我们给这个box命名为ubuntu12.04
vagrant box add ubuntu12.04 ~/box/precise64.box
# 2.box文件也可以是远程地址 base 为默认名称
vagrant box add base http://files.vagrantup.com/lucid64.box
```

> 注意会提示选择该box镜像的provider,选择2即可
>
> This box can work with multiple providers! The providers that it can work with are listed below. Please review the list and choose the provider you will be working with.
>
> 1) hyperv
> 2) virtualbox
> 3) vmware_fusion

删除镜像使用：vagrant box remove NAME

##### 初始化开发环境

创建一个开发目录（比如：`~/dev`），你也可以使用已有的目录

```shell
$ cd ~/dev  # 切换目录
$ vagrant init hashicorp/precise64  # 用 hashicorp/precise64 进行 box 初始化
$ vagrant up  # 启动环境
```

问题和解决方法:

1. [Error VT-x not available for Vagrant machine inside Virtualbox](https://stackoverflow.com/questions/24620599/error-vt-x-not-available-for-vagrant-machine-inside-virtualbox),修改Vagrantfile文件如下：

```
   config.vm.provider "virtualbox" do |vb|   # 开启
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
      vb.cpus=1    # 添加这一行
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
   end
```

2. [VirtualBox is complaining that the kernel module is not loaded](https://gist.github.com/geraldvillorente/977d16624e079ba12741)

```shell
/usr/lib/virtualbox/vboxdrv.sh setup
# 若提示找不到内核版本：unable to find the sources of your current Linux kernel.
yum install kernel kernel-devel kernel-header 
# 保证版本一致rpm –qa|grep kernel |sort，若不一致，则更新yum update kernel对应项
```

##### 登录虚拟机

```shell
$ vagrant ssh  # SSH 登录
$ cd /vagrant  # 切换到开发目录，也就是宿主机上的 `~/dev`
```

> 宿主机`~/dev` 目录对应虚拟机中的目录是 `/vagrant`，在虚拟中操作`/vagrant`相当于直接操作宿主机中的文件
>
> 目前ssh连接不上去

##### 其它设置

- 网络设置

```
Vagrant 初始化成功后，会在初始化的目录里生成一个 Vagrantfile 的配置文件，可以修改配置文件进行个性化的定制。

Vagrant 默认是使用端口映射方式将虚拟机的端口映射本地从而实现类似 http://localhost:80 这种访问方式，这种方式比较麻烦，新开和修改端口的时候都得编辑。相比较而言，host-only 模式显得方便多了。打开 Vagrantfile，将下面这行的注释去掉（移除 #）并保存：

config.vm.network :private_network, ip: "192.168.33.10"
重启虚拟机，这样我们就能用 192.168.33.10 访问这台机器了，你可以把 IP 改成其他地址，只要不产生冲突就行。
```

- 打包分发

当你配置好开发环境后，退出并关闭虚拟机。在终端里对开发环境进行打包：

```
$ vagrant package
```

打包完成后会在当前目录生成一个 `package.box` 的文件，将这个文件传给其他用户，其他用户只要添加这个 box 并用其初始化自己的开发目录就能得到一个一模一样的开发环境了。

添加方法：

假设我们拿到的 box 存放路径是 `~/box/package.box`，在终端里输入：

```
$ vagrant box add hahaha ~/box/package.box  # 添加 package.box 镜像并命名为 hahaha
$ cd ~/dev  # 切换到项目目录
$ vagrant init hahaha  # 用 hahaha 镜像初始化。
```



 ##参考

[vagrant官方文档参考](https://www.vagrantup.com/docs/cli/box.html)

[使用 Vagrant 打造跨平台开发环境](https://segmentfault.com/a/1190000000264347)

[不使用VirtualBox直接安装vagrant](https://fedoramagazine.org/running-vagrant-fedora-22/)