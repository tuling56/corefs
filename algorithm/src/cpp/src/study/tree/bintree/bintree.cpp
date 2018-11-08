/********************************************************************************* 
  *FileName:
  *Author:tuling56
  *Date:   
  *Description: 二叉树的遍历
  *Others: 
  *Function List:  //主要函数列表，每条记录应包含函数名及功能简要说明 
     1.………… 
     2.………… 
  *History: //修改历史记录列表，每条修改记录应包含修改日期、修改者及修改内容简介 
     1.Date: 
       Modification: 
     2.………… 
  *Ref:https://blog.csdn.net/sunnyyoona/article/details/24741311
**********************************************************************************/
#include<stdio.h>
#include<stdlib.h>

#include<iostream>
#include<string>
#include<vector>
#include<stack>
#include<queue>

using namespace std;

/*
class Solution{
	public:
		int xxx(string s){
			cout<<s<<endl;		
		}
};
*/

//定义树的存储结构
typedef struct BinNode {
  char data;
  struct BinNode *lchild;
  struct BinNode *rchild;
} BinNode, *BinTree;


//Visit
void Visit(BinTree T)
{
  if(T->data!='#'){
    printf("%c",T->data);
  }
}


//构造二叉树（按先序构建）
void build_bintree_preorder(BinTree &T)
{ 
  char data;
  scanf("%c",&data);
  if(data=='#'){
    T=NULL;
    return;
  }else{
    //创建根节点
    T=(BinTree)malloc(sizeof(BinNode));
    T->data=data;
    build_bintree_preorder(T->lchild); //左子树
    build_bintree_preorder(T->rchild);
  }
}



//按前序、中序和后序遍历二叉树(递归)
void visit_bintree_preorder_digui(BinTree T)
{ 
  if(T!=NULL){
    Visit(T);
    visit_bintree_preorder_digui(T->lchild);
    visit_bintree_preorder_digui(T->rchild);
  }
}


//按前序、中序和后序遍历二叉树(非递归)
/*
  利用栈
*/
void visit_bintree_preorder(BinTree T)
{ 
  stack<BinTree> bs_stack;
  BinTree p=T; //指针赋值
  while(p||!bs_stack.empty()){
    if(p!=NULL){
      //入栈
      bs_stack.push(p);
      printf("%c",p->data);
      p=p->lchild;
    }else{
      //出栈
      p=bs_stack.top(); 
      bs_stack.pop();
      p=p->rchild;
    }
  }
}


//层次遍历
void visit_bintree_level(BinTree T)
{

}


int main()
{
  BinTree T; //指针
  build_bintree_preorder(T);
  printf("(先序)构造二叉树完毕！开始遍历二叉树");
  printf("1.先序遍历");
  visit_bintree_preorder_digui(T);


	return 0;
}
