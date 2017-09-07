##docker
[TOC]

### 基础

#### 概念

Docker底层组成：

- `Namespace`：隔离技术的第一层，确保 Docker 容器内的进程看不到也影响不到 Docker 外部的进程。
- `Control Groups`：LXC 技术的关键组件，用于进行运行时的资源限制。
- `UnionFS（文件系统）`：容器的构件块，创建抽象层，从而实现 Docker 的轻量级和运行快速的特性。

Docker的主要构成：

- `Docker Client`：用户和 Docker 守护进程进行通信的接口，也就是 docker 命令。
- `Docker Daemon`：宿主机上用于用户应答用户请求的服务。
- `Registry`：注册服务器，注册服务器是存放仓库（`Repository`）的具体服务器。

Docker的三元素：

- `Container`：用于运行应用程序的容器，包含操作系统、用户文件和元数据，相当于镜像Images的一个运行实例。。
- `Images`：只读的 Docker 容器模板，简言之就是系统镜像文件。
- `DockerFile`：进行镜像创建的指令文件。

#### 安装

1. 安装docker

Docker 软件包和依赖包已经包含在默认的 CentOS-Extras 软件源里

```shell
yum -y install docker
# 或者使用脚本安装
curl -fsSL https://get.docker.com/ | sh
```

2. 启动docker后台服务

```shell
[root@local122 supervisord.d]# service docker start 
Redirecting to /bin/systemctl start  docker.service
```

3. 运行hello-world

```shell
docker run hello-world
```

由于本地没有hello-world这个镜像，所以会下载这个镜像，并在容器内运行

#### 使用

| 命令                     | 功能                               | 备注                                |
| ---------------------- | -------------------------------- | --------------------------------- |
| docker run name/id     | 运行容器                             | -i -t 实现交互;-d  后台运行，-P端口映射        |
| docker ps              | 查看哪些容器在运行                        | 可以查看端口映射                          |
| docker stop name/id    | 停止容器                             |                                   |
| docker logs name/id    | 查看容器内的标准输出                       | -f，类似tail -f                      |
| docker port name/id    | 查看网络端口映射                         |                                   |
| docker inspect name/id | 使用 docker inspect 来查看Docker的底层信息 | 返回一个 JSON 文件记录着 Docker 容器的配置和状态信息 |
| docker start name/id   | 启动容器                             | 重启使用restart                       |
| docker rm name/id      | 删除容器                             | 删除容器时，容器必须是停止状态                   |
| docker images          | 列出本地主机上的镜像                       |                                   |

运行容器内容的应用程序

```shell
docker run ubuntu:15.10 /bin/echo "Hello world"
docker pull busybox
```

##### 镜像





 ##参考

[docker基础知识汇总](http://www.imooc.com/article/18030)

