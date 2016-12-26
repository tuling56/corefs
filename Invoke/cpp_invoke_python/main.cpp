/************************************************************************
* Copyright(c) 2015 tuling56
*
* File:	main.cpp
* Brief: cpp调用Python
* Reference:http://blog.sina.com.cn/s/blog_6ec980ee0101cgax.html
			http://www.udpwork.com/item/10422.html
			http://blog.csdn.net/nynyvkhhiiii/article/details/17525865
			http://blog.csdn.net/taiyang1987912/article/details/44779719（相互调用）
			http://stackoverflow.com/questions/12230210/attributeerror-module-object-has-no-attribute-argv-when-using-python-h(若需要接收命令行参数)
* Status: 完成
* Date:	[6/25/2015 jmy]
************************************************************************/
#include<python2.7/Python.h>

int main(int argc,char*argv[])
{

	Py_Initialize();
	PyRun_SimpleString("import sys");
	//PySys_SetArgv(argc, argv);
	PyRun_SimpleString("sys.path.append('./')"); 

	PyObject *pMode = NULL;
	PyObject *pfunc = NULL;
	PyObject* pClass = NULL;
	PyObject *pInstance = NULL;
	PyObject *pArg = NULL;
	PyObject *pRet=NULL;

	//调用函数：不带参数（返回值）
	char *res="zhang";
	pMode = PyImport_ImportModule("script");
	pfunc = PyObject_GetAttrString(pMode, "hello");
	pRet  = PyEval_CallObject(pfunc, NULL);
	Py_DECREF(pfunc);
	int retok=PyArg_Parse(pRet,"s",&res);
	if (retok==0)
		printf("这是返回值:%s",res);
	printf("这是返回值:%s\n",res);

	//调用函数：带参数
	pfunc = PyObject_GetAttrString(pMode, "world");
	pArg = Py_BuildValue("(s)", "function with argument"); //单参数
	PyEval_CallObject(pfunc,pArg);
	Py_DECREF(pfunc);

	pArgs = PyTuple_New(3);		//多参数
	PyTuple_SetItem(pArgs,0,Py_BuildValue("s","para1"));
	PyTuple_SetItem(pArgs,1,Py_BuildValue("s","para2"));
	PyTuple_SetItem(pArgs,2,Py_BuildValue("s","para3"));
	pRet = PyEval_CallObject(pfunc,pArgs);

	char * cnn_res=NULL;		//获取返回结果
	int retstatus=PyArg_Parse(pRet,"s",&cnn_res);
	Py_DECREF(pfunc);
	if (retstatus!=0){
		string res=cnn_res;		//获取的字符串处理结果
		return 0;
	}
	else
		return -1;	


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
