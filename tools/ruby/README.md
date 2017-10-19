## Ruby学习笔记

### 安装

```shell
# 安装ruby基本环境、irb交互式ruby命令行工具和rubypick，
# 此外还有rubygems包管理工具，bigdecimal、io-console、json、rdoc、psych等包
yum install ruby

# 安装ruby的开发环境，以方便使用mkmf来安装其它包
yum install ruby-devel
```

#### RubyGems包管理器

rubygems是Ruby的包管理器，提供一个分发Ruby程序和库的标准格式，还提供一个管理程序包安装的工具，类似于apt-get、yum、pip等

```shell
gem install xxx
gem uninstall xxx

# 列出本地安装的包
gem list --local

#列出远程可用的包
gem list --remote

# 下载一个gem包，但不安装
gem fetch xxx

# 从可用的gem中搜索
gem search xxx --remote
```

修改ruby的源

```shell
# 查看当前源
gem source -l

# 移除当前源，添加淘宝源(确保只有淘宝源)
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org/
```

### 应用

#### 邮件发送



## 参考

[RUNOOB的Ruby教程](http://www.runoob.com/ruby/ruby-rubygems.html)

