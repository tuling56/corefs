##hexo笔记
[TOC]

### 基础

hexo和github的关系，hexo能否单独使用呢

#### 安装

##### 安装

```shell
npm install hexo-cli -g
```

###### 流程

```shell
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

**目录结构**

```shell
node_modules/
public/
scaffolds/
source/
themes/
_config.yml
db.json
package.json
package-lock.json
```

目录说明：

> - public/    发布之后的生成的静态文件夹
> - node_module/    依赖的nodejs模块
> - scaffolds/    模板文件
> - source/     原始文章，markdown格式
> - themes/    主题文件
> - _config.yml   主配置文件
> - db.json    数据库文件夹
> - package.json    包依赖描述文件

##### 命令

生成和部署

```shell
hexo new "postName" 		 # 新建文章
hexo new page "pageName" 	 # 新建页面
hexo generate 				# 生成静态页面至public目录
hexo server					# 开启预览访问端口（默认端口4000，'ctrl + c'关闭server）
hexo deploy 				# 将.deploy目录部署到GitHub
hexo help 					# 查看帮助
hexo version 				# 查看Hexo的版本
```

#### 配置

主配置文件_config.yml 

```yaml
# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: Hexo
subtitle:
description:
author: John Doe
language:
timezone:

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://gitbook.tuling56.top
root: /hexo/blog1/public
permalink: :year/:month/:day/:title/
permalink_defaults:

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: :lang
skip_render:

# Writing
new_post_name: :title.md # File name of new posts
default_layout: post
titlecase: false # Transform title into titlecase
external_link: true # Open external links in new tab
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
future: true
highlight:
  enable: true
  line_number: true
  auto_detect: false
  tab_replace:
  
# Home page setting
# path: Root path for your blogs index page. (default = '')
# per_page: Posts displayed per page. (0 = disable pagination)
# order_by: Posts order. (Order by date descending by default)
index_generator:
  path: ''
  per_page: 10
  order_by: -date
  
# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 10
pagination_dir: page

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: landscape

# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type:
```



### 进阶

#### 写作

```
$ hexo new [layout] <title>
```

您可以在命令中指定文章的布局（layout），默认为 `post`，可以通过修改 `_config.yml` 中的 `default_layout` 参数来指定默认布局。

##### 布局（Layout）

Hexo 有三种默认布局：`post`、`page` 和 `draft`，它们分别对应不同的路径，而您自定义的其他布局和 `post` 相同，都将储存到 `source/_posts` 文件夹。

| 布局    | 路径             |
| ------- | ---------------- |
| `post`  | `source/_posts`  |
| `page`  | `source`         |
| `draft` | `source/_drafts` |

 

#### 部署

##### 部署方式

###### Git仓库

部署到git仓库，其git仓库是管理public的文件

###### Rsync

通过rsync部署生成的public文件

###### FTPSync

通过ftpsync部署生成的public文件

参见[Hexo官方文档部署部分](https://hexo.io/zh-cn/docs/deployment.html)

##### 其它

选择指定的端口

```shell
hexo server -p 4050
```

#### 主题

### 实践

//待补充

 ##参考

- **基础**

  [hexo官方参考](https://hexo.io/docs/)

  [简书:hexo+github搭建自己的博客](http://www.jianshu.com/p/465830080ea9)

  [今日头条:hexo搭建私人博客](http://www.toutiao.com/i6467864285803446798/)

  [今日头条:hexo搭建私人博客2](https://www.toutiao.com/i6493409693451420173/)

  [参考jade模板引擎](待补充)

- **进阶**

  //待补充

- **实践**

  //待补充

