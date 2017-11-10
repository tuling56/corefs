## GitBook安装设置

[TOC]

>  简介：GitBook 在文本编辑、多人协作、互动和电子书最终输出形式等方面的支持非常完善，基本上涵盖了现代出版物的整个生命周期，接下来的篇幅将详述这几个环节并介绍一些自己的实践经验

### 安装

#### 安装npm

从 [https://nodejs.org/#download](https://nodejs.org/#download) 下载 安装node.js，自带npm软件包管理器

> 测试：npm -v

#### **安装gitbook-cli**

> npm install -g gitbook-cli

gitbook-cli是gitbook的命令行，可以方便的管理多个gitbook版本

#### **安装gitbook**

> gitbook -v 

若没有安装gitbook，则会选择最新的gitbook版本进行安装，使用其他的命令

| 命令                | 意义               |
| ----------------- | ---------------- |
| gitbook ls-remote | 查看远程的gitbook所有版本 |
| gitbook fetch xx  | 安装指定gitbook版本    |
| gitbool ls        | 查看本地的gitbook版本   |

### 编辑

#### 创建

1. 编写书籍大纲的SUMMARY.md文件和书籍说明的README.md文档

```markdown
* [简介](README.md)
* [第一章](chapter1/README.md)
 - [第一节](chapter1/section1.md)
 - [第二节](chapter1/section2.md)
* [第二章](chapter2/README.md)
 - [第一节](chapter2/section1.md)
 - [第二节](chapter2/section2.md)
* [结束](end/README.md)
```

2. 执行gitbook init 

该步骤会自动创建书籍的目录和对应的章节文档

3. gitbook build 生成书籍

该步骤会在书籍目录生成_book文件夹，里面是书籍的静态html网页

4. gitbook serve 网页浏览

该步骤会启动自带的web服务器，可以通过http://localhost:4000 通过网页查看书籍

#### 方式选择

- web端
- 客户端

#### 多人协作

若使用GitBook官方，可以在设置中找到协作这，进行添加。对于绑定GitHub repo的GitBook项目，其协作方式和普通的项目没有差异，插件 [edit-link](https://github.com/rtCamp/gitbook-plugin-edit-link)可以在每个页面生成指向 GitHub repo 相应文件的链接，十分方便！但需要版本库支持web编辑的方式，若搭建本地的，要自己实现。

###  扩展

#### 评论互动

> Gitbook本身提供了对所有电子书按段落评论的功能，（但在本地搭建的gitbook仓库没有这个功能）
>
> 通过disqus,多说等第三方插件支持

#### 插件配置

书籍根目录下的book.json文件

```json
{
    "plugins": ["navigator","toolbar","edit-link","ad","chart","-prism","highlight"],
    "pluginsConfig": {
        "disqus": {
            "shortName": "tuling56"
        },
		"toolbar": {
            "buttons":
            [
                {
                    "label": "GitHub",
                    "icon": "fa fa-github",
                    "url": "https://github.com/"
                },
                {
                    "label": "Search page title on StackOverflow",
                    "icon": "fa fa-stack-overflow",
                    "url": "http://stackoverflow.com/search?q={{title}}"
                }
            ]
 		},
        "edit-link": {
              "base":"https://github.com/tuling56/GitBook/edit/master/",
              "label": {
                    "en": "Edit This Page"
                }
        },
        "ad": {
      		  "contentTop": "<div>Ads at the top of the page</div>",
      		  "contentBottom": "%3Cdiv%3EAds%20at%20the%20bottom%20of%20the%20page%3C/div%3E"
    	},
        "chart":{
             "type": "c3"
        },
        "prism":{
            "css":["prismjs/themes/prism-solarizedlight.css"]
        }
    },
   "links": {
        "sidebar": {
            "自定义左侧超链接": "http://www.baidu.com"
        },
        "sharing": {
            "baidu": "www.baidu.com",
            "weibo": false,
            "all": null
        }
    }

}
```

### 导出

支持html、epub、mobi和pdf等格式的数据，需要配合calibre使用。

> pdf、epub、mobi格式导出

在电子书存档目录，如:`E:\xx\gitbook\mybook_test`执行` gitbook pdf|epub|mobi .`或者上一级目录执行

``gitbook pdf|epub|mobi ./mybook_test`

类似的转换方式还有`pandoc xx.md -o xx.pdf|epub|mobi`

### 发布

#### 官网发布

gitbook editor只支持https协议

使用`gitbook editor`可以轻松发布，但只能发布到gitbook官网，要自己构建发布系统，若是https协议的也可发布，先在本地创建gitbook,然后git init->git add->git commit等系列操作后，添加远程的https仓库，即可实现推送

##### https协议访问

HTTP 或 HTTPS 协议的优美之处在于架设的简便性。基本上， 只需要把 ==Git 的纯仓库文件放在 HTTP 的文件根目录下==，配置一个特定的 `post-update` 挂钩（hook），就搞定了（Git 挂钩的细节见第七章）。从此，每个能访问 Git 仓库所在服务器上的 web 服务的人都可以进行克隆操作。

遇到的问题：

```shell
$ git clone http://gitweb.me/go_web.git
Cloning into 'go_web'...
fatal: repository 'http://gitweb.me/go_web.git/' not found

# 解决方法是切换到go_web.git目录下，然后执行，git update-server-info 
```

![找不到版本库的问题](http://hi.csdn.net/attachment/201010/27/0_1288160338ifZu.gif)



#### 自建发布

方法1：

在要发布的机器上，构建gitbook文档，并使用git进行管理，远程机器可以git clone该版本库，但不能git push,所有的修改只能在要发布的机器上进行，修改完文档后重启gitbook服务，重新构建文档

方法2：

在要发布的机器上构建git版本管理的仓库，配置`post-receive`钩子如下：

```shell
vim hooks/post-receive

#!/bin/bash
# gitbook工作目录的设置
gitbook_home=/home/yjm/Projects/webframe/gitbook

set GIT_INDEX_FILE
GIT_WORK_TREE=${gitbook_home} git checkout -f

cd ${gitbook_home}
echo "`date +%F\ %T`" >>timettt
gitbook build #&& gitbook serve  这部分启动的代码暂时不需要
#sh ${gitbook_home}/run.sh

exit 0
```

注意事项：

> 需要先把gitbook用到的node插件的目录如下：node_modules/  拷贝到gitbook的工作目录内，避免重复的插件下载和安装。

从远程机器上clone下仓库，编辑然后推送

```shell
git clone root@127.0.0.1:/home/yjm/Documents/gitrepo/gitbook.git
git add .
git commit -m "添加内容和修改等"
git push 
# 会在推送之后，显示gitbook build的信息如下：
Total 4 (delta 1), reused 0 (delta 0)
remote: info: 17 plugins are installed
remote: info: 12 explicitly listed
remote: info: loading plugin "navigator"... OK
remote: info: loading plugin "toolbar"... OK
remote: info: loading plugin "edit-link"... OK
remote: info: loading plugin "ad"... OK
remote: info: loading plugin "chart"... OK
remote: info: loading plugin "highlight"... OK
remote: info: loading plugin "search"... OK
remote: info: loading plugin "lunr"... OK
remote: info: loading plugin "sharing"... OK
remote: info: loading plugin "fontsettings"... OK
remote: info: loading plugin "theme-default"... OK
remote: info: found 17 pages
remote: info: found 2 asset files
remote: warn: "this.generator" property is deprecated, use "this.output.name" instead
remote: warn: "navigation" property is deprecated
remote: warn: "book" property is deprecated, use "this" directly instead
remote: warn: "options" property is deprecated, use config.get(key) instead
remote: info: >> generation finished with success in 6.5s !
```

通过http://localhost:4000来web访问修改的内容(若要支持在线编辑，需要通过web服务器来实现，暂时没有)

**增强**：通过配置nginx的服务器的方式来实现gitbook内容的访问，这样就不必再启动gitbook serve了

```nginx
server {
        listen  80;
        server_name  gitbook.me;
        charset utf-8;
        access_log    logs/gitbook_acc.log;
        error_log     logs/gitbook_error.log;

        root /home/yjm/Projects/webframe/gitbook/_book;  # gitbook的根目录

        location /{
            #default_type application/json;  	# 处理json数据的时候中文乱码，暂时未解决
            default_type 'text/plain';
            index index.html index.htm;
        }
 }
```

##### 自建发布（合集）

将多本书籍进行集中管理，git上配置的推送钩子`post-receive`不用修改(只需要改变下每本书籍的钩子地址即可)

```shell
[root@local122 hooks]# cat post-receive 
#!/bin/bash
# gitbook工作目录的设置（书籍的钩子地址）
gitbook_home=/home/yjm/Documents/gitbook/git_demo.me 

set GIT_INDEX_FILE
GIT_WORK_TREE=${gitbook_home} git checkout -f

# 以下的内容可以自动忽略（不需要额外的操作）
cd ${gitbook_home}
echo "`date +%F\ %T`" >>timettt
gitbook build #&& gitbook serve  #这部分启动的代码暂时不需要
#sh ${gitbook_home}/run.sh

exit 0
```

只用在nginx上配置如下:

```nginx
# 静态Gitbook服务器
server {
        listen  80;
        server_name  gitbook.me;
        charset utf-8;
        access_log    logs/gitbook_acc.log;
        error_log     logs/gitbook_error.log;
      
        location ~ / {
            root /home/yjm/Documents/gitbook;
        	index index.html index.htm index.php; 
        	autoindex on;
    	} 

        location ^~ /git_demo{
            alias /home/yjm/Documents/gitbook/git_demo.me/_book/;
            #default_type application/json;
            default_type 'text/plain';
            index index.html index.htm;
        }
        
        location ^~ /go_web{
            alias /home/yjm/Documents/gitbook/go_web.me/_book/;
            #default_type application/json;
            default_type 'text/plain';
            index index.html index.htm;
        }
 }
```

然后通过:http://gitbook.me/git_demo/ 和http://gitbook.me/go_web/ 方式访问对应的书籍。

本地书籍的目录方式如下(子目录就是书籍)：

```shell
[root@local122 gitbook]# ls -lh
/home/yjm/Documents/gitbook
drwxr-xr-x. 11 root root 4.0K Jun 12 10:25 git_demo.me
drwxr-xr-x.  6 root root 4.0K Jun 12 10:23 go_web.me
```

##### 结合发布

结合发布是融合了官网发布和自建发布两个方式的优缺点，既利用了官网发布的可视化操作的优势，又利用了自建发布的定制和完全控制的优点。

用GitBook Editor打开自建发布导出的仓库的时候，可以编辑和修改，但是在推送（Publish）的时候，提示Gitbook Editor暂时只支持https协议，而自己在版本库clone的时候使用的是git协议，如何使用https协议访问git仓库？

两者的对比如下：

```shell
# Clone with ssh
# Use an SSH key and passphrase from account.
git@github.com:tuling56/shared_common_libs.git

# Clone with https
# Use Git or checkout with SVN using the web URL.
https://github.com/tuling56/shared_common_libs.git
```

>  怎么配置git仓库的https访问？

```shell
git clone https://127.0.0.1/home/yjm/Documents/gitrepo/gitbook.git
```

参考：

[搭建git https服务器](http://www.cnblogs.com/clcvampire/p/6290471.html)

[利用Nginx搭建HTTP访问的Git服务器](http://www.tuicool.com/articles/bAZvEz3)

### 测试

#### pure仓库

git仓库配置在阿里云上,sample仓库是裸仓库，没有工作区，建立方式如下：

```shell
git init --bare sample.git
```

- git clone http://47.95.195.31/gitrepo/sample.git

```shell
#存在的问题是可以clone但无法提交,提示错误：
fatal: git-http-push failed
```

- git clone https://47.95.195.31/gitrepo/sample.git

```shell
#存在的问题是可以clone但无法提交，提示错误：
fatal: git-http-push failed
```

- git clone root@47.95.195.31:/usr/local/nginx/site/gitrepo/sample.git

```shell
# 可以clone也可以提交，但是找不到工作区是啥回事
```

#### nopure仓库

nopure仓库的建立方式如下:

```shell
git init sample_nopure.git
```

- git clone http://47.95.195.31/gitrepo/sample_nopure_.git  sample_nopure_http

```shell
#存在的问题是可以clone但无法提交
```

- git clone https://47.95.195.31/gitrepo/sample_nopure_.git   sample_nopure_https

```shell
#存在的问题是可以clone但无法提交
```

- git clone root@47.95.195.31:/usr/local/nginx/site/gitrepo/sample_nopure.git  sample_nopure_ssh 

```shell
# 可以正常克隆
```



## 参考

- Disqus插件

  [配置Disqus插件](http://www.jianshu.com/p/a87c070dfcf8)

  [Disqus官网](https://disqus.com/)

  [我的Disqus站点](https://tuling56.disqus.com/)

- 简明教程

  [Gitbook简易教程](https://segmentfault.com/a/1190000005859901)

  [Gitbook实用配置](http://www.cnblogs.com/zhangjk1993/p/5066771.html)

  [GitBook配置步步详解](http://www.chengweiyang.cn/gitbook/customize/book.json.html)

  [解决导出的文件中文乱码问题](http://www.tuicool.com/articles/nQNZ3yJ)

  [Linux安装新字体](http://www.cnblogs.com/MonkeyF/archive/2013/05/13/3076466.html)

- 发布

  [git配置本地、ssh、git协议和http协议传输（推荐）](http://blog.csdn.net/jixiuffff/article/details/5969174)

