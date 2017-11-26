# 算法与应用

[TOC]



## 数据结构

### trie树

#### 基础

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

#### 实现

python实现

```python

```

c++实现

```cpp

```

## 算法应用

### 子串

#### 最长连续子串

问题：

```
比如[1 2 4 5 6  9 12 13 16],规定两个相邻的数的差值为1则为连续，则该序列的最长子序列为[4 5 6],最长子序列的长度为3
```

实现：

```

```

#### [最长非重复子串](https://leetcode.com/problems/longest-substring-without-repeating-characters/description/)

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

#### 最大和子串

问题：

```
一列数，求和最大的子串
```

实现：

```

```

### 子序列

问题：

```
最长
```

实现：

```

```

### 数组

#### 合并有序数组

问题：

```
合并两个有序数组并求合并之后的第k大的元素
```

实现：

```python

```

#### 删除数组中的重复元素



## 参考

- 基础

  [LeetCode题解解题报告(推荐)](http://bookshadow.com/leetcode/)

  [LeetCode题解Gitbook(cpp)](https://siddontang.gitbooks.io/leetcode-solution/content/)

  [LeetCode题解专栏(Python)](http://blog.csdn.net/column/details/leetcode-with-python.html)

- 数据结构

  [小白详解trie树](https://segmentfault.com/a/1190000008877595)

- 算法应用

