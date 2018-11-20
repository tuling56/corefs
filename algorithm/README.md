#算法笔记
[TOC]

## 数据结构

数据结构分线性结构和非线性结构，其中线性结构主要是堆、栈、队列、数组和链表、哈希表等，非线性结构主要是是树和图。

### 线性结构

#### 堆

#####  最大堆

##### 最小堆

#### 栈

先进后出

#### 队列

先进先出

##### 优先队列

#### 链表

##### 单向链表

###### [反转](https://blog.csdn.net/u011452172/article/details/78127836?locationNum=1&fps=1)

单链表反转的四种方法：

- 开辟辅助数组
- 新建表头反转
- 就地反转
- 递归反转

```python
# 新建表头反转

```

###### 查找

```python

```

###### 排序

```python

```

###### 运算

两个单向链表的运算，用来解决大整数的乘法问题等

##### 双向链表

###### 反转

```python

```



#### 散列表

散列表又称哈希表

- 什么是散列表？
- 为什么要使用散列表？
- 如何解决哈希冲突？

### 非线性结构

#### 树 

树的定义

> 1.树是元素的集合
> 2.该集合可以为空，这是树中没有元素，我们称树为空数
> 3.如果该集合不为空，那么该集合有一个根结点，以及0个或者多个子树。根结点与它的子树的根结点用一个变相连

树的深度

> 从树根到任一结点n有唯一的一条路径，我们称这条路径的长度为结点n的深度或层数。根结点的深度为0，其余结点的深度为其父结点的深度加1。深度相同的结点属于同一层。树具有递归特征

树的实现

> 方式1：每个结点存储元素自身和多个指向子节点的指针
>
> 一个父节点可能有大量的子节点，而另一个父节点可能只有一个子节点，而树的增删结点操作会让子节点的数目发生进一步的变化。这种不确定性，可能带来大量的内存相关操作，并且容易造成内容的浪费。
>
> 方式2：每个节点存储元素自身，一个指针指向第一个子节点，并有另一个指针指向该子节点的下一个兄弟节点。

##### 二叉树

二叉树是一种特殊的树，二叉树的每个节点最多只能有2个子节点。
单次搜索的复杂度为n，一个有n个节点的二叉树，它的最小深度为log(n),最大深度为n。

![深度为n](http://images.cnitblog.com/blog/413416/201303/18192708-33f7275db8f04f29bceb101db8e363ed.png)

![深度为logn](http://images.cnitblog.com/blog/413416/201303/18193146-54c40b4027ff442fb3199543c7f42d8e.png)

###### **二叉搜索树**

![二叉搜索树](http://images.cnitblog.com/blog/413416/201303/17001935-1b9faa8518a14f95b3bb9eb3083f683c.png)



在二叉树的基础上添加条件：每个及节点都不比他左子树的任意元素小，而且不比它的右子树的任意元素大。
二叉搜索树可以方便的实现搜索算法。在搜索元素x的时候，我们可以将x和根节点比较:

1. 如果x等于根节点，那么找到x，停止搜索 (终止条件)
2. 如果x小于根节点，那么搜索左子树
3. 如果x大于根节点，那么搜索右子树

二叉搜索树所需要进行的操作次数最多与树的深度相等。n个节点的二叉搜索树的深度最多为n，最少为log(n)。

```
    在二叉搜索树上实现搜索，插入，删除，寻找最大最小节点的操作，每个节点中存有三个指针，一个指向父节点，一个指向左子节点，一个指向右子节点。

(这样的实现是为了方便。节点可以只保存有指向左右子节点的两个指针，并实现上述操作。)

难点在二叉搜索树的删除
```

###### 二叉平衡树

//待补充

#####  AVL树

单次搜索的复杂度为log(n)

##### TRIE树

###### 基础

![trie树](http://images.cnitblog.com/blog/183411/201212/30214213-f9256d989b3b45ae8d15da2604ddce71.png)

trie树描述

> 每个单词都是通过character by character的方式进行连接，中文名叫字典树、前缀树，主要用途是将字符串集合整合成树形

trie树的性质

> - （1）根节点不包含字符，除根节点外的每个节点只包含一个字符。
> - （2）从根节点到某一个节点，路径上经过的字符连接起来，为该节点对应的字符串。
> - （3）每个节点的所有子节点包含的字符串不相同。

应用场景：

> - 搜索词提示
>   - 比直接用hash节省存储空间
> - 词频统计
> - 其它应用的辅助结构

###### 实现

python实现

```python

```

c++实现

```cpp

```

##### 伸展树

对于m次连续搜索操作有很好的效率。

伸展树会在一次搜索后，对树进行一些特殊的操作，这些操作的理念与AVL树有些类似，即通过旋转来改变书节点的分布，并减小树的深度。但伸展树并没有AVL的平衡要求，任意及诶单的左右子树可以相差任意深度。与二叉搜索树类型，伸展树的单次搜索也可能需要n次操作。但伸展树可以保证，m次的连续搜索操作的复杂度为mlog(n)的量级，而不是mn量级。

##### 哈弗曼树

待完成

##### 红黑树

待完成

##### B树

待完成

#### 图

##### 图的表示

##### 图的遍历

###### 广度优先

###### 深度优先

##### 图的保存

##### 图的添加和删除

## 算法

### 查找

#### 字符串查找

### 排序

待完成

### 图算法

#### 最短路径

##### Dijskla算法

#### 最小生成树

##### prim算法

按照节点查找的方法

##### 克鲁斯卡尔算法

按照具体的线段进行的

##  思想

### 递归

//待补充

### 动态规划

//待补充

## 积累

### 串和序列

#### 子串

##### 最长连续子串

问题：

```
比如[1 2 4 5 6  9 12 13 16],规定两个相邻的数的差值为1则为连续，则该序列的最长子序列为[4 5 6],最长子序列的长度为3
```

实现：

```

```

##### [最长非重复子串](https://leetcode.com/problems/longest-substring-without-repeating-characters/description/)

问题：

```
Given a string, find the length of the longest substring without repeating characters.
# 例如：
Given "pwwkew", the answer is "wke", with the length of 3. Note that the answer must be a substring, "pwke" is a subsequence and not a substring.
```

实现：

```cpp
class Solution {
	public：
      	int lengthOfLongestSubstring(string s){
          
      	}
};
```

##### 最大和子串

问题：

```
一列数，求和最大的子串
```

实现：

```

```

#### 子序列

##### [最长递增子序列](http://www.cnblogs.com/lixiaohui-ambition/archive/2012/12/24/2831491.html)

问题：

```
最长
```

实现：

```

```

### 数组

数组只是串和序列的一种存储方式而已，其形式依然是串和序列，但有独特部分。

#### 合并有序数组

问题：

```
合并两个有序数组并求合并之后的第k大的元素
```

实现：

```python

```

#### 删除重复元素

```shell

```

## 训练

贵在实践

### LeetCode

#### 整体参考

[LeetCode题解解题报告(推荐)](http://bookshadow.com/leetcode/)

[LeetCode题解Gitbook(cpp)](https://siddontang.gitbooks.io/leetcode-solution/content/)

[LeetCode题解专栏(Python)](http://blog.csdn.net/column/details/leetcode-with-python.html)

[leetcode题解索引（推荐）](http://blog.csdn.net/hcbbt/article/details/43966331)

[leetcode题解详解（推荐）](https://www.tianmaying.com/tutorials/tag/Leetcode)

[leetcode编程训练（酷壳）](https://coolshell.cn/articles/12052.html)

#### 分类训练

[LeetCode之Array题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/250681)
[LeetCode之Hash Table题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/250743)
[LeetCode之Linked List题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/253217)
[LeetCode之Math题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/253233)
[LeetCode之String题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/253417)
[LeetCode之Binary Search题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/253602)
[LeetCode之Divide and Conquer题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/253633)
[LeetCode之Dynamic Programming题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/253649)
[LeetCode之Backtracing题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/254988)
[LeetCode之Stack题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255249)
[LeetCode之Sort题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255346)
[LeetCode之Bit Manipulation题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255359)
[LeetCode之Tree题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255436)
[LeetCode之Depth-first Search题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255699)
[LeetCode之Breadth-first Search题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255729)
[LeetCode之Graph题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255732)
[LeetCode之Trie题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255738)
[LeetCode之Design题目汇总](https://link.jianshu.com/?t=https://www.zybuluo.com/Yano/note/255755)

 ##参考

- **数据结构**

  [堆的定义](http://blog.csdn.net/wypblog/article/details/8076324)

  [小白详解trie树](https://segmentfault.com/a/1190000008877595)

- **算法**

  [算法与数据结构C++精解](http://t.cn/RVHmRYb)

  [Java数据结构与算法](http://t.cn/RtW9dtv) 

  [基本排序算法](http://t.cn/RtW9d5F)

  [算法分析](http://t.cn/RtW9d5k)

  [面试中的排序算法](http://t.cn/RtW9dth)

  [算法学习笔记](http://t.cn/RtW9d5s) 

  [算法图解(强烈推荐)](https://github.com/egonSchiele/grokking_algorithms.git)

  [啊哈，算法](https://github.com/egonSchiele/grokking_algorithms.git)

- **思想**

  //待补充

- **积累**

  //待补充


