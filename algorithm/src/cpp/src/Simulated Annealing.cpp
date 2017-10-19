/*
 *	ģ���˻��㷨��������̣�TSP���⣩
 */

#include <iostream>  
#include <sstream>  
#include <fstream>  
#include <string>
#include <cstring>
#include <iterator>  
#include <algorithm>  
#include <climits>  
#include <cmath>  
#include <cstdlib> 
#include <time.h>

using namespace std;  

const int nCities = 10;           //��������  
const double SPEED = 0.98;        //�˻��ٶ�  
const int INITIAL_TEMP = 1000;    //��ʼ�¶�  
const int L = 10 * nCities;       //Markov ���ĳ���  

struct unit                             //һ����  
{  
	double length;                      //���ۣ��ܳ���  
	int path[nCities];                  //·��  
	bool operator < (const struct unit &other) const  
	{  
		return length < other.length;  
	}  
};  
unit bestone = {INT_MAX, {0} };         //���Ž�  

double length_table[nCities][nCities];  //distance  

class saTSP
{
  public:
	int init_dis();                  // create matrix to storage the Distance each city
	void SA_TSP();  
	void CalCulate_length(unit &p);  //���㳤��  
	void print(unit &p);             //��ӡһ����  
	void getNewSolution(unit &p);    // �������л�ȥһ���½�  
	bool Accept(unit &bestone, unit &temp, double t);//�½���Metropolis ׼�����  
};

//stl �� generate �ĸ�����������  
class GenbyOne {  
  public:  
	GenbyOne (int _seed = -1): seed(_seed){}  
	int operator() (){return seed += 1;}  
  private:  
	int seed;  
};  

void saTSP::SA_TSP()  
{  
	srand((int)time(0));  
	int i = 0;  
	double r = SPEED;  
	double t = INITIAL_TEMP;  
	const double t_min = 0.001; //�¶����ޣ����¶ȴﵽt_min ����ֹͣ����  

	//choose an initial solution ~  
	unit temp;  
	generate(temp.path, temp.path + nCities, GenbyOne(0));  
	random_shuffle(temp.path, temp.path + nCities);  
	CalCulate_length(temp);  
	memcpy(&bestone, &temp, sizeof(temp));  

	// while the stop criterion is not yet satisfied do  
	while ( t > t_min )  
	{  
		for (i = 0; i < L; i++)   
		{  

			getNewSolution(temp);  
			//cout << "dkkd:" << bestone.length << endl;
			if(Accept(bestone,temp, t))  
			{  
				memcpy(&bestone, &temp, sizeof(unit));  
			}  
			else  
			{  
				memcpy(&temp, &bestone, sizeof(unit));  
			}  
		}  
		t *= r; //�˻�  
	}  
	return;  
}  

bool saTSP::Accept(unit &bestone, unit &temp, double t)  
{  
	if (bestone.length > temp.length) //��ø��̵�·��  
	{  
		return true;  
	}  
	else  
	{  
		if ((int)(exp((bestone.length - temp.length) / t) * 100) > (rand() % 101) )   
		{  
			return true;  
		}  
	}  
	return false;  
}  

void saTSP::getNewSolution(unit &p)  
{  
	int i = rand() % nCities;  
	int j = rand() % nCities;  
	if (i > j)   
	{  
		int t = i;  
		i = j;  
		j = t;  
	}  
	else if (i == j)      
	{  
		return;   
	}  

	int choose = rand() % 3;  
	if ( choose == 0)   
	{//����  
		int temp = p.path[i];  
		p.path[i] = p.path[j];  
		p.path[j] = temp;  
	}  
	else if (choose == 1)   
	{//����  
		reverse(p.path + i, p.path + j);       
	}  
	else  
	{//��λ  
		if (j + 1 == nCities) //�߽紦������  
		{  
			return;  
		}  
		rotate(p.path + i, p.path + j, p.path + j + 1);    
	}  
	CalCulate_length(p);  
}  

int saTSP::init_dis() // create matrix to storage the Distance each city  
{  
	int i = 0, j = 0;  
	string line;
	double word;
	ifstream infile("distances.txt");  
	if(!infile)
	{
		cout << "Cannot open the file" << endl;
		return 0;
	}

	while(getline(infile, line))
	{
		j = 0;
		istringstream instream(line);
		while(instream >> word)
		{
			length_table[i][j] = word;  
			++j;
		}
		++i;
	}
}  

void saTSP::CalCulate_length(unit &p)  
{  
	int j = 0;  
	p.length = 0;  
	for (j = 1; j < nCities; j++)   
	{  
		p.length += length_table[ p.path[j-1] ][ p.path[j] ];  
	}  
	p.length += length_table[p.path[ nCities - 1] ][ p.path[0] ];  
}  

void saTSP::print( unit &p)  
{  
	int i;  
	cout << "�����ǣ�" << p.length << endl;  
	cout << "·���ǣ�";  
	for (i = 0; i < nCities; i++)   
	{  
		cout << p.path[i] << " ";  
	}  
	cout << endl;  
}  

int SimulatedAnnewaling()  
{  
	saTSP sa;
	sa.init_dis();  
	sa.SA_TSP();  
	sa.CalCulate_length(bestone);  
	sa.print(bestone);  
	//system("pause");
	cin.get();

	return 0;  
}