/* 说明：hash表的使用
 * 参考：http://blog.csdn.net/feixiaoxing/article/details/6885657
 */

#include<iostream>
#include<string.h>
#include<stdlib.h>

using namespace std;

//定义节点
typedef struct _NODE{
    int data;
    struct _NODE* next; //指向下一个节点
}NODE;

//定义hash表
typedef struct _HASH_TABLE{
    NODE* value[10];
}HASH_TABLE;


//创建hash表(申请空和初始化)
HASH_TABLE* create_hash_tbl()
{
    HASH_TABLE *phashtbl=(HASH_TABLE*)malloc(sizeof(HASH_TABLE));
    memset(phashtbl,0,sizeof(HASH_TABLE));

    return phashtbl;
}


//在hash表中查找数据
NODE* find_data_in_hash(HASH_TABLE*phashtbl,int data)
{
    NODE*pNode;
    if(NULL==phashtbl)
        return NULL;
    if(NULL==(pNode=phashtbl->value[data%10])) //若没有查找到
        return NULL;
    
    while(pNode)
    {
        if(data==pNode->data)
            return pNode;
        pNode=pNode->next;
    }

    return NULL;
}

//在hash表中插入数据
bool insert_data_into_hash(HASH_TABLE *phashtbl,int data)
{
    NODE*pNode;
    if(NULL==phashtbl)
        return false;
    if(NULL==phashtbl->value[data%10]){
        pNode=(NODE*)malloc(sizeof(NODE));
        memset(pNode,0,sizeof(NODE));
        pNode->data=data;
        phashtbl->value[data%10]=pNode;
        return true;
    }

    //若在hash表中已存在，则插入失败（避免冲突）
    if(NULL!=find_data_in_hash(phashtbl,data))
        return false;

    pNode=phashtbl->value[data%10];
    while(NULL!=pNode->next)
        pNode=pNode->next;

    //这个插入情况是什么情况
    pNode->next=(NODE*)malloc(sizeof(NODE));
    memset(pNode,0,sizeof(NODE));
    pNode->next->data=data;

    return true;
}

int main()
{
    HASH_TABLE *hash_tbl=create_hash_tbl();
    if(insert_data_into_hash(hash_tbl,5))
        cout<<"插入成功"<<endl;
    else
        cout<<"插入失败"<<endl;

    NODE*pnode=find_data_in_hash(hash_tbl,4);
    if(NULL!=pnode)
        cout<<"查找到:"<<pnode->data<<endl;
    else
        cout<<"没有查找到:4"<<endl;

    return 0;
}
