## sqlite学习笔记

sqlite是一个功能强大、体积小运算速度快的[嵌入式](http://lib.csdn.net/base/embeddeddevelopment)[数据库](http://lib.csdn.net/base/mysql)，采用了全[C语言](http://lib.csdn.net/base/c)封装，并提供了八十多个命令接口，可移植性强，使用方便。

### 基础

#### 安装

```shell
wget -c http://sqlite.org/sqlite-3.6.17.tar.gz
tar -zxvf sqlite-3.6.17.tar.gz
cd sqlite-3.6.17
./configure --prefix=/usr/local/sqlite --disable-tcl
make && make install
```

在/usr/local/sqlite下产生lib,include,bin三个文件目录，分别是库文件，头文件和可执行文件

#### 配置

在用户的家目录创建`.sqliterc`文件，内容如下：

```
.timer on
.headers on
.echo on
.separator "\t"
.nullvalue "<null>"
.width 8
```

#### sqlite实现web查询

##### flask-restless实现

```python
class Person(db.Model):
    id = db.Column(db.Integer, primary_key=True)   # 主键用来搜素
    name = db.Column(db.Unicode)
    birth_date = db.Column(db.Date)     # 日期类型


class Article(db.Model):
    id = db.Column(db.Integer, primary_key=True)   # 主键用来搜素
    title = db.Column(db.Unicode)
    published_at = db.Column(db.DateTime)       # 日期时间类型
    author_id = db.Column(db.Integer, db.ForeignKey('person.id'))
    author = db.relationship(Person, backref=db.backref('articles',lazy='dynamic'))


# Create the database tables.
db.create_all()

# Create the Flask-Restless API manager.
manager = flask_restless.APIManager(app, flask_sqlalchemy_db=db)

# Create API endpoints, which will be available at /api/<tablename> by
# default. Allowed HTTP methods can be specified as well.
manager.create_api(Person, methods=['GET', 'POST', 'DELETE'])
manager.create_api(Article, methods=['GET'])
```

实现参考：https://github.com/jfinkels/flask-restless/blob/master/examples

##### sandman2ctl实现

```
sandman2ctl 'sqlite+pysqlite:///path/to/sqlite/database'
sandman2ctl 'sqlite+pysqlite:///D:/test.db'
 * Running on http://0.0.0.0:5000/
```

实现参考：http://sandman2.readthedocs.io/en/latest/quickstart.html

## 参考

[sqlite基础配置和C语言接口](http://blog.csdn.net/kuangreng/article/details/6474895)

[sqlite入门三之配置文件说明](http://blog.csdn.net/wirelessqa/article/details/21030147)

[是否存在根据MySQL表格自动生成restful接口的技术](https://segmentfault.com/q/1010000008335958?_ea=1878275)

