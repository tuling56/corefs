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

该步骤会会在书籍目录生成_book文件夹，里面是书籍的静态html网页

4. gitbook serve 网页浏览

该步骤会启动自带的web服务器，可以通过http://localhost:4000 通过网页查看书籍

#### 方式选择

- web端
- 客户端

#### 多人协作

若使用GitBook官方，可以在设置中找到协作这，进行添加。对于绑定GitHub repo的GitBook项目，其协作方式和普通的项目没有差异，插件 [edit-link](https://github.com/rtCamp/gitbook-plugin-edit-link)可以在每个页面生成指向 GitHub repo 相应文件的链接，十分方便！

###  功能扩展

#### 评论互动

> Gitbook本身提供了对所有电子书按段落评论的功能
>
> 通过disqus,多数等第三方插件支持

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

### 导出和发布

#### 导出

支持网页输出，epub,mobi和pdf等格式的数据，需要配合calibre使用。

> pdf,epub,mobi格式导出

在电子书存档目录，如：E:\xx\gitbook\mybook_test执行` gitbook pdf|epub|mobi .`或者上一级目录执行``gitbook pdf|epub|mobi ./mybook_test`

#### 发布

使用gitbook editor可以轻松发布[^1]

[^1]: 还没有实现

### 参考

- Disqus插件

  [配置Disqus插件](http://www.jianshu.com/p/a87c070dfcf8)

  [Disqus官网](https://disqus.com/)

  [我的Disqus站点](https://tuling56.disqus.com/)

- 简明教程

  [Gitbook简易教程](https://segmentfault.com/a/1190000005859901)

  [Gitbook实用配置](http://www.cnblogs.com/zhangjk1993/p/5066771.html)

  [GitBook配置步步详解](http://www.chengweiyang.cn/gitbook/customize/book.json.html)