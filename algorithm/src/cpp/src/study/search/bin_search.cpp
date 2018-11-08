/********************************************************************************* 
  *FileName:
  *Author:tuling56
  *Date:   
  *Description:二分查找 
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
#include<stdlib.h>
#include<iostream>
#include<string>

using namespace std;

class Solution{
	public:
		int xxx(string s){
			cout<<s<<endl;		
		}
};

//返回查找到的元素的下标
int bin_search(int a[],int n,int key)
{

  int low=0;
  int high=n;
  int mid=0;

  while(low<=high){
    mid=low+(high-low)/2;
    if(key==a[mid]){
      return mid;
    }else if(key<a[mid]){
      high=mid-1;
    }else{
      low=mid+1;
    }
  }

  return -1;
}


int c_print_arr(int a[])
{
  int i=0;
  while(a[i]!='\0'){
    printf("%d ",a[i]);
    i=i+1;
  }
  printf(" size:%d\n",i);
  return i;
}

int main()
{
  int a[]={1,2,4,6,9,12,22};
  int key=9;
  printf("输入的待查有序数组是：\n");
  int len=c_print_arr(a);
  printf("输入的待查数字是：%d\n",key);

  int res=bin_search(a,len,key);
  printf("查找元素下标返回值：%d\n",res);


	return 0;
}
