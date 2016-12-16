/************************************************************************
* Copyright(c) 2015 tuling56
*
* File:	main.cpp
* Brief: cpp调用Python
* Reference:http://blog.sina.com.cn/s/blog_6ec980ee0101cgax.html
            http://www.udpwork.com/item/10422.html
            http://blog.csdn.net/nynyvkhhiiii/article/details/17525865
* Status: 完成
* Date:	[6/25/2015 jmy]
************************************************************************/
#include<python2.7/Python.h>

int main()
{

	Py_Initialize();
	PyRun_SimpleString("import sys");
	PyRun_SimpleString("sys.path.append('./')"); //¿¿python¿¿¿¿

	PyObject *pMode = NULL;
	PyObject *pfunc = NULL;
	PyObject* pClass = NULL;
	PyObject *pInstance = NULL;
	PyObject *pArg = NULL;
    PyObject *pRet=NULL;

    //不带参数
    char *res="zhang";
	pMode = PyImport_ImportModule("script");
	pfunc = PyObject_GetAttrString(pMode, "hello");
	pRet  = PyEval_CallObject(pfunc, NULL);
    Py_DECREF(pfunc);
    int retok=PyArg_Parse(pRet,"s",&res);
    if (retok==0)
        printf("这是返回值:%s",res);
    printf("这是返回值:%s\n",res);

    //带参数
	pfunc = PyObject_GetAttrString(pMode, "world");
	pArg = Py_BuildValue("(s)", "function with argument");
	PyEval_CallObject(pfunc,pArg);
	Py_DECREF(pfunc);

    //类
	pClass = PyObject_GetAttrString(pMode, "Student");
	if (!pClass){
		printf("cann't find Sudent class\n");
		return -1;
	}
	pInstance = PyInstance_New(pClass, NULL, NULL);
	if (!pInstance)
	{
		printf("cann't create sudent instance\n");
		return -1;
	}

	PyObject_CallMethod(pInstance, "SetName", "s", "myfamliy");
	PyObject_CallMethod(pInstance, "PrintName", NULL, NULL);
	
	Py_Finalize();
	
	return 0;

}
