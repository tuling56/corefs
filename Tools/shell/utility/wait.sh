#!/usr/bin/expect			# 指定shebang
set timeout 3				# 设定超时时间为3秒
spawn ssh root@127.0.0.1 122            # fork一个子进程执行ssh命令
expect "*password*"		        # 期待匹配到 'user_name@ip_string's password:'
send "123\r"				# 向命令行输入密码并回车
send "cd \r"	                        # 帮我切换到常用的工作目录
interact                                # 允许用户与命令行交互



