##Electron笔记
[TOC]

### 基础

Electron 可以让你使用纯 JavaScript 调用丰富的原生(操作系统) APIs 来创造桌面应用。 你可以把它看作一个专注于桌面应用的 Node. js 的变体，而不是 Web 服务器。

#### 安装

前置依赖node.js安装

到[node.js官网](https://nodejs.org/en/)下载对应的版本安装即可，安装完毕后使用以下命令检查：

```shell
node -v
npm -v 
```

在线安装

```shell
npm install electron electron-packager
```

离线下载

淘宝镜像：[https://npm.taobao.org/mirrors/electron/](https://npm.taobao.org/mirrors/electron/) 
GitHub：[https://github.com/electron/electron/releases](https://github.com/electron/electron/releases) 

>  下载对应的安装包解压即可，并添加到环境变量中去

#### 使用

快速入门指南

```shell
git clone https://github.com/electron/electron-quick-start
cd electron-quick-start
npm install
npm start
```

#### 打包

打包成系统可执行程序，没有nodejs环境也可以使用，用到的两个包`electron-packager`、`electron-prebuilt`

```shell
electron-packager ./  
	--platform=win32 
	--arch=x64 
	--version=0.37.2 
	--icon=./images/favicon.ico

```



 ##参考

- 基础

  [Electron的Github官方](https://github.com/electron/electron)

  [我眼中的Electron](https://segmentfault.com/a/1190000008205112)

​	[Electron装X入门](http://blog.csdn.net/cyzshenzhen/article/details/52669200)

