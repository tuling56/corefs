#<center>这是一级标题</center>

<pre>      这  是 Pre标签的使用                                 2013/12/2 18:31:28 </pre>

<p style="text-align:right">使用p标签加style属性text-align这种方式可以右对齐</p>

<div style="text-align:right;border:1px solid;color:red;background-color:blue">使用div标签加style属性text-align这种方式可以右对齐</div>

<span style="text-align:right">但span标签加style属性text-align***无法实现***右对齐</span>



一阶标题定义方法
==
二阶标题定义方法
--

###这是定义表格 ###
这是定义表格|的表头，下面有几个下划线
------|-----
列1|列2
列1|列2




>这是引用

正文内容，你时候

[这是超链接](http://www.baidu.com)
## 这是二级标题##
>>这是二级缩进
>
- 列表项1
- 列表项2
- 列表项3

重点支持《国家中长期人才发展规划纲要（2010—2020年）》、《国家中长期科学和技术发展规划纲要（2006—2020年）》确定的重点支持学科、前沿技术、基础研究、人文与社会应用科学领域（详见国家留学网“国家留学基金重点资助学科专业领域”）

>整段代码用前面空四个空格，或一个Tab开头,这是块代码

	  int main()
       {
        std::count<<"hellow world" <<std::endl;
        exit();
       }

> `这是行内代码`


<code>这是code方式引用代码</code>
<cite>这也是引用，但是斜体</cite>
<blockquote>你好这是blockquote引用
<br>
   <cite>这是cite引用</cite>
</blockquote>
<q>短引用</q>

<strong>定义横隔线：</strong>

"方式1，连续3个*好

***

方式2，连续3个-号

---
"
<strong>定义无序列表项：</strong>

+ 一级列表
- 二级列表
* 三级列表
- 四级列表

<strong>定义有序列表项：</strong>

<ol>
<li>这是一端很重要的内同</li>
<li>这段内容页很重要
	<ol>
		<li>这是这段内容的第二部分</li>
		<li>这是这段内容的第三部分</li>
	</ol>
</li>
</ol>


<strong>定义常见项：</strong>

<u>定义下划线</u>

定义下标<sub>下标</sub>

定义上标<sup>上标</sup>

<small>这是小号字体</small>

<big>这是大号字体</big>



<em>这是强调</em>
等同于
*这也是强调*

<strong>这是粗体强调</strong>
等同于
**这也是粗体强调**


*斜体1*

**粗体1**

***粗体加斜体1***


_斜体2_

__加粗2__

___加粗+斜体2___


[<input type="button" value="按钮，也是超链接"/>](http://www.baidu.com)

![这是插入本地图片的方式](url("markdown.png"))

![这是插入网络图片的方式](http://www.w3cfuns.com/data/attachment/cmplugin/W3Cfuns_Adv/portal/index/right/0/201312/01/162739agj5mebf5g556km3.png)

[http://www.baidu.com](http://www.baidu.com)这是直接网址超链接

[这是文本超链接](http://www.baidu.com "这个部分可有可无")

###整段代码定义和使用
+ 在需要代码格式的段落每一行前面四个空格(这里的空格是相对空格)
具体可以参考[Code帮助](https://code.csdn.net/help/CSDN_Code/code_support/new_9)

        这是代码啊
    
        这也是代码啊
+ 先选中段落，然后按tab键
		这部分诠释tab代码
		
		这部分诠释tab代码
		
		这部分诠释tab代码

+ 在段落的首尾用四（三）个“`”符号

```
这部分是Github“···”格式定义的代码，
	
但是尝试未成功，后来查明的原因是要使用Github风格的预处理器的时候才生效，这个工具-->选项-->Markdown-->预处理器中设置

```

:octocat:
:birthday:

- 在一个段落内部把一部分文字作为代码

     这是一段文字这是一段文字
  `这是一段文字内部的代码（注意背景色）`



单个回车
视为空格

连续回车

才能分段

行尾加两个空格，这里->  
即可段内换行。

---
+ 第一层列表项目
 - 第二层列表项目
  - 只支持到第第二层
 - 第二层列表项目
- 第一层列表项目
 1. 列表嵌套无序列表嵌套有序列表
 2. 列表嵌套
 - 不能在无序列表嵌套有序列表后再嵌套无序列表
- 第一层列表

这是分割线

1. 这是有序列表
4. 这段内容准备嵌套无序
 - 无序列表第一层
  - 依然是只能嵌套两层

---
### Table of Contents

>这是锚

- [Go to Section One](#sectionOne)
- [Go to Section Two](#sectionTwo)

<a name="sectionOne"></a>
### My First Header ##
This is some content in my first section.

<a name="sectionTwo"></a>
### My Second Header ##
This is some content in my second section.
***
