##hexo笔记
[TOC]

### 基础

hexo和github的关系，hexo能否单独使用呢

#### 安装

```shell
npm install hexo-cli -g
hexo init blog
cd blog
npm install

# 生成静态文件
hexo generate

# 启动自带的服务器
hexo server

# 部署
hexo deploy
```

命令一览：

```shell
hexo new "postName" 		 # 新建文章
hexo new page "pageName" 	 # 新建页面
hexo generate 				# 生成静态页面至public目录
hexo server					# 开启预览访问端口（默认端口4000，'ctrl + c'关闭server）
hexo deploy 				# 将.deploy目录部署到GitHub
hexo help 					# 查看帮助
hexo version 				# 查看Hexo的版本
```

### 进阶

#### 写作

#### 部署

#### 主题

### 实践

//待补充

 ##参考

- **基础**

  [hexo官方参考](https://hexo.io/docs/)

  [简书:hexo+github搭建自己的博客](http://www.jianshu.com/p/465830080ea9)

  [今日头条:hexo搭建私人博客](http://www.toutiao.com/i6467864285803446798/)

  [今日头条:hexo搭建私人博客2](https://www.toutiao.com/i6493409693451420173/)

- **进阶**

- **实践**

