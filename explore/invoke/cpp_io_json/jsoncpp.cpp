/* 功能:c++读写json格式的数据文件
 * 说明：使用到jsoncpp库：http://sourceforge.NET/projects/jsoncpp
 * 参考：http://blog.csdn.net/xt_xiaotian/article/details/5648388 
 */


#include<jsoncpp/json/json.h>
#include<iostream>
#include <fstream>

using namespace Json;
using namespace std;


int main()
{
	Json::Value json_temp;      // 临时对象，供如下代码使用
	json_temp["name"] = Json::Value("huchao");
	json_temp["age"] = Json::Value(26);
 
	Json::Value root;  // 表示整个 json 对象
	root["key_string"] = Json::Value("value_string");			// 新建一个 Key（名为：key_string），赋予字符串值："value_string"。
	root["key_number"] = Json::Value(12345);					// 新建一个 Key（名为：key_number），赋予数值：12345。
	root["key_boolean"] = Json::Value(false);					// 新建一个 Key（名为：key_boolean），赋予bool值：false。
	root["key_double"] = Json::Value(12.345);					// 新建一个 Key（名为：key_double），赋予 double 值：12.345。
	root["key_object"] = json_temp;								// 新建一个 Key（名为：key_object），赋予 json::Value 对象值。
	root["key_array"].append("array_string");					// 新建一个 Key（名为：key_array），类型为数组，对第一个元素赋值为字符串："array_string"。
	root["key_array"].append(1234);								// 为数组 key_array 赋值，对第二个元素赋值为：1234。


	Json::StyledWriter styled_writer;
	std::cout << styled_writer.write(root) << std::endl;


    //写文件
    std::ofstream jf;  
    jf.open ("jsonf.json", std::ios::binary ); 
    jf << styled_writer.write(root);
    jf.close();
}



