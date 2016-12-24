#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <stdlib.h>
#include  <string.h>
#include <arpa/inet.h>
#include  <time.h>
#include <string>
#include "test.pb.h"  
#include <iostream>

using namespace std;
#define  SERVER_PORT 20000  //  define the defualt connect port id
#define  CLIENT_PORT 20001  //  define the defualt client port as a random port
#define  BUFFER_SIZE 255

int swap_str_to_int(char *str)
{
	if(NULL == str)
	{
		printf("flie<%s>, line[%d].传入空指针!\n", __FILE__, __LINE__);
		return -1;
	}
	
	char *iter = NULL;
	int int_num = 0;

	iter = str;
	while(*iter != 0)	//asicc 0 is null
	{
		if((*iter >= '0') && (*iter <= '9'))
		{
			int_num = int_num*10 + (*iter - 48);	//asicc 48 is num 0
			*iter++;
		}
		else
		{
			printf("flie<%s>, line[%d].socket端口号输入有误!\n", __FILE__, __LINE__);
			return -1;
		}
	}
	return int_num;
}

int  main(int argc, char** argv)
{
	int  servfd,clifd,length = 0;
	struct  sockaddr_in servaddr,cliaddr;
	socklen_t socklen  =   sizeof (servaddr);
	char  buf[BUFFER_SIZE];

	if (argc < 3 )
	{
		printf( " usage: %s IpAddr\n ", argv[ 0 ]);
		exit( 1 );
	}

	int ser_socketfd = 0;
	ser_socketfd = swap_str_to_int(argv[ 2 ]);
	if(-1 != ser_socketfd)
	{
		printf("flie<%s>, line[%d].ser_socketfd = %d\n", __FILE__, __LINE__, ser_socketfd);
	}	
	
	for(int i = 0; i < 1; i++)
	{
		if ((clifd  =  socket(AF_INET,SOCK_STREAM, 0 ))  <   0 )
		{
			printf( " create socket error!\n " );
			exit( 1 );
		}
		
		linger InternalLinger = { 1, 0 };
		setsockopt(clifd, SOL_SOCKET, SO_LINGER, (const char*)&InternalLinger, sizeof(linger)); //set linger
		srand(time(NULL)); // initialize random generator

		bzero( & cliaddr, sizeof (cliaddr));
		cliaddr.sin_family  =  AF_INET;
		cliaddr.sin_port  =  htons(CLIENT_PORT);
		cliaddr.sin_addr.s_addr  =  htons(INADDR_ANY);

		bzero( & servaddr, sizeof (servaddr));
		servaddr.sin_family  =  AF_INET;
		inet_aton(argv[ 1 ], & servaddr.sin_addr);
		servaddr.sin_port  =  htons(ser_socketfd);
		// servaddr.sin_addr.s_addr = htons(INADDR_ANY);

		if  (bind(clifd, (struct sockaddr* ) &cliaddr, sizeof (cliaddr)) < 0 )
		{
			printf( " bind to port %d failure!\n " ,CLIENT_PORT);
			exit( 1 );
		}
		int ret = 0;
		//sleep(1);
		if ((ret = connect(clifd,( struct  sockaddr * ) & servaddr, socklen))  <   0 )
		{
			printf( " can't connect to %s! ret = %d\n ", argv[ 1 ], ret);
			//exit( 1 );
		}

				string data;
                                chen_demo::chen_info info;
                                info.set_age(24);
                                info.set_name("chen");
                                info.set_game("online");
                                info.set_id(111);
                                info.set_pnum("13187118888");
                                info.SerializeToString(&data);
                                char send_buf[data.length()];
                                strcpy(send_buf, data.c_str());
                                send(clifd, send_buf, sizeof(send_buf), 0);

		//strcpy(buf,argv[ 3 ]);
		//send(clifd,buf,BUFFER_SIZE, 0 );
		
		length  =  recv(clifd, buf, BUFFER_SIZE, 0);
		if  (length < 0)
		{
			printf( " error comes when recieve data from server %s! ", argv[1] );
			exit( 1 );
		}
		else
		{
			cout << "chen:recieve data success form " << clifd << endl;
			cout << "chen:I recv the server is " << buf << endl;
			/*buf[length] = '\0';
			string data;
			chen_demo::chen_info info;
			info.ParseFromString(buf);
			cout << "chen:age is = " << info.age() << endl;
			cout << "chen:name is = " << info.name() << endl;
			cout << "chen:game is = " << info.game() << endl;
			cout << "chen:id is = " << info.id() << endl;
			cout << "chen:pnum is = " << info.pnum() << endl;*/
		}
		
		close(clifd);
	}
	return 0;
}

