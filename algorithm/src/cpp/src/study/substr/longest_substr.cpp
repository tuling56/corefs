/*********************************************************************************
  *FileName:
  *Author:tuling56
  *Date:
  *Description:最长非重复子串
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
#include<iostream>
#include<string>
#include<vector>

using namespace std;

typedef struct {
	unsigned int start=0;
	unsigned int end=0;
}SEG;

class Solution{
    public:
		vector<SEG> vseg;
        int lengthOfLongestSubstr(string s)
		{
            cout<<"输入:"<<s<<endl;
			unsigned int sl=s.size();
			for(unsigned int i=0;i<sl-1;i++)
			{
				for(unsigned int j=i+1;j<sl;j++)
				{
					if(s[j-1]!=s[j])
					{
						SEG sg;
						sg.start=i;
						sg.end=j;
						vseg.push_back(sg);
					}
				}
			}
			return getLongestLength(vseg,s);        
        }
	
	private:
		//获取最长的间隔长度
		int getLongestLength(vector<SEG> vseg,string s)
		{
			unsigned int maxdiff=0;
			unsigned int diff=0;
			unsigned int maxstart=0;
			unsigned int maxend=0;
			vector<SEG>::iterator it;
			for(it=vseg.begin();it!=vseg.end();it++)
			{
				//cout<<it->start<<it->end<<endl;
				diff=it->end-it->start;
				if(diff>maxdiff){
					maxdiff=diff;
					maxstart=it->start;
					maxend=it->end;
				}
			}
			
			cout<<"最长非重复子串是:"<<s.substr(maxstart,maxdiff)<<endl
				<<"长度是:"<<maxdiff<<endl;

			return maxdiff;
		}
};


int main()
{
    string instr="pwwkew";
    
    Solution s;
    s.lengthOfLongestSubstr(instr);

    return 0;
}
