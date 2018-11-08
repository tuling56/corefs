/********************************************************************************* 
  *FileName:
  *Author:tuling56
  *Date:   
  *Description: 快速排序
  *Others: 
  *Function List:  //主要函数列表，每条记录应包含函数名及功能简要说明 
     1.………… 
     2.………… 
  *History: //修改历史记录列表，每条修改记录应包含修改日期、修改者及修改内容简介 
     1.Date: 
       Modification: 
     2.………… 
  *Ref:http://blog.csdn.net/fmxfmx2013/article/details/30999095
**********************************************************************************/
#include<stdio.h>


//定义全局变量
int a[20]={1,2,4,6,2,123,10};


//快排(涉及递归)
void quicksort(int left,int right)
{
  int i,j,base,temp;
  
  base=a[left];
  i=left;
  j=right;

  while(i!=j){
    //右指针左移动
    while(a[j]>base && i<j)
      j--;
    //左指针右移动
    while(a[j]<base && i<j)
      i++;

    //交互
    if(i<j)
    {
      temp=a[i];
      a[i]=a[j];
      a[j]=temp;
    }
  }

  //基数归位
  a[left]=a[i];
  a[i]=base;

  //递归子数组
  quicksort(left,i-1);
  quicksort(i+1,right);

}


int main()
{
  printf("程序开始执行");

  int i;
  //输出排序前的数据
  for(i=0;i<10;i++)
    printf("%d",a[i]);

  quicksort(1,10);

  //输出排序后的结果
  for(i=0;i<10;i++)
    printf("%d",a[i]);

  getchar();

	return 0;
}
