/************************************************************************
* Copyright(c) 2015 tuling56
*
* File:	main.cpp
* Brief: cpp调用Python
* Reference:http://blog.sina.com.cn/s/blog_6ec980ee0101cgax.html
			http://www.udpwork.com/item/10422.html
			http://blog.csdn.net/nynyvkhhiiii/article/details/17525865
			http://blog.csdn.net/taiyang1987912/article/details/44779719（相互调用,最详细）
			http://stackoverflow.com/questions/12230210/attributeerror-module-object-has-no-attribute-argv-when-using-python-h(若需要接收命令行参数)
* Status:待定
* Date:	[6/25/2015 jmy]
************************************************************************/
#include<python2.7/Python.h>
#include<string>
#include<iostream>
#include<stdio.h>

using namespace std;

//调用方法1：
int invoke_method_1()
{

	Py_Initialize();
	// 检查初始化是否成功  
    if ( !Py_IsInitialized() ) {  
        return -1;  
    }  

	PyRun_SimpleString("import sys");
	//PySys_SetArgv(argc, argv);
	PyRun_SimpleString("sys.path.append('./')"); 

	PyObject *pMode = NULL;
	PyObject *pfunc = NULL;
	PyObject* pClass = NULL;
	PyObject *pInstance = NULL;
	PyObject *pArg = NULL;
	PyObject *pArgs = NULL;
	PyObject *pRet=NULL;

	pMode = PyImport_ImportModule("pymodle_1");

	//调用函数：不带参数（返回值）
	pfunc = PyObject_GetAttrString(pMode, "fun_para_return");
	pRet  = PyEval_CallObject(pfunc, NULL);
	Py_DECREF(pfunc);

	char *res="zhang";
	int retok=PyArg_Parse(pRet,"s",&res);
	if (retok==0)
		printf("这是单参数调用的返回值:%s",res);

	//调用函数：单参数
	pfunc = PyObject_GetAttrString(pMode, "fun_para");
	pArg = Py_BuildValue("(s)", "function with argument"); 
	PyEval_CallObject(pfunc,pArg);
	Py_DECREF(pfunc);


	//调用函数：多参数（返回值）
	pfunc = PyObject_GetAttrString(pMode, "fun_paras_return");
	pArgs = PyTuple_New(3);	
	PyTuple_SetItem(pArgs,0,Py_BuildValue("s","para1"));
	PyTuple_SetItem(pArgs,1,Py_BuildValue("s","para2"));
	PyTuple_SetItem(pArgs,2,Py_BuildValue("s","para3"));
	pRet = PyEval_CallObject(pfunc,pArgs);
	Py_DECREF(pfunc);

	char * cnn_res=NULL;		//获取返回结果
	int retstatus=PyArg_Parse(pRet,"s",&cnn_res);
	if (retstatus!=0)
		cout<<"这是多参数调用的返回值:"<<cnn_res<<endl;



	//调用类
	pClass = PyObject_GetAttrString(pMode, "Student");
	if (!pClass){
		printf("cann't find Sudent class\n");
		return -1;
	}
	pInstance = PyInstance_New(pClass, NULL, NULL);
	if (!pInstance){
		printf("cann't create sudent instance\n");
		return -1;
	}

	PyObject_CallMethod(pInstance, "SetName", "s", "myfamliy");
	PyObject_CallMethod(pInstance, "PrintName", NULL, NULL);
	
	//结束调用
	Py_Finalize();
	
	return 0;
}

//调用方法2
int invoke_method_2()
{

	Py_Initialize();
	// 检查初始化是否成功  
    if ( !Py_IsInitialized() ) {  
        return -1;  
    }  

	PyRun_SimpleString("import sys");
	//PySys_SetArgv(argc, argv);
	int ret=PyRun_SimpleString("sys.path.append('./')"); 
	if (ret!=0)	{
		cout<<"添加路径错误，请检查字符串中是否有语法错误"<<endl;
		return -1;
	}


	// 创建相关对象
    PyObject *pName,*pModule,*pDict,*pFunc,*pArgs;  

	// 载入名为pymodle_2的脚本  
    pName = PyString_FromString("pymodle_2");  
    pModule = PyImport_Import(pName);  
    if ( !pModule ) {  
        printf("can't find pymodle_2.py");  
        getchar();  
        return -1;  
    }  
    pDict = PyModule_GetDict(pModule);  
    if ( !pDict ) {  
        return -1;  
    }  
  
    /*example1:找出函数名为add的函数(带两个参数) */ 
    printf("----------------------------------\n");  
    pFunc = PyDict_GetItemString(pDict, "add");  
    if ( !pFunc || !PyCallable_Check(pFunc) ) {  
        printf("can't find function [add]");  
        getchar();  
        return -1;  
     }  
  
    // 参数进栈  
    pArgs = PyTuple_New(2);  
  
    //  PyObject* Py_BuildValue(char *format, ...)  
    //  把C++的变量转换成一个Python对象。当需要从C++传递变量到Python时，就会使用这个函数。此函数  
    //  有点类似C的printf，但格式不同。常用的格式有  
    //  s 表示字符串，  
    //  i 表示整型变量，  
    //  f 表示浮点数，  
    //  O 表示一个Python对象。  
  
    PyTuple_SetItem(pArgs, 0, Py_BuildValue("l",3));  
    PyTuple_SetItem(pArgs, 1, Py_BuildValue("l",4));  
  
    // 调用Python函数  
    PyObject_CallObject(pFunc, pArgs);  
  
    /*example2:下面这段是查找函数foo 并执行foo（单参数）*/  
    printf("------------------------------------\n");  
    pFunc = PyDict_GetItemString(pDict, "foo");  
    if ( !pFunc || !PyCallable_Check(pFunc) ) {  
        printf("can't find function [foo]");  
        getchar();  
        return -1;  
     }  
  
    pArgs = PyTuple_New(1);  
    PyTuple_SetItem(pArgs, 0, Py_BuildValue("l",2));   
    PyObject_CallObject(pFunc, pArgs);  
       
    /*example3:下面这段是查找函数update 并执行update（单参数）*/  
    printf("------------------------------------\n");  
    pFunc = PyDict_GetItemString(pDict, "update");  
    if ( !pFunc || !PyCallable_Check(pFunc) ) {  
        printf("can't find function [update]");  
        getchar();  
        return -1;  
     }  
    pArgs = PyTuple_New(0);  
    PyTuple_SetItem(pArgs, 0, Py_BuildValue(""));  
    PyObject_CallObject(pFunc, pArgs);       
  
    Py_DECREF(pName);  
    Py_DECREF(pArgs);  
    Py_DECREF(pModule);  
  
    // 关闭Python  
    Py_Finalize();  
    
    return 0;  
}


//主体执行程序
int main(int argc,char*argv[])
{
	invoke_method_1();

	return 0;
}