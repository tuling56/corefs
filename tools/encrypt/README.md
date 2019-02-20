# 加解密

![加解密](http://tuling56.site/imgbed/2019-01-24_121851.png)



## 基础

### 加密

加密算法

```shell
echo -n foobar | sha256sum
echo -n "foobar" | shasum -a 256
echo -n "foobar" | openssl dgst -sha256
```

> 在安装和使用了openssl后，您可以替换`-sha256`为`-md4 -md5 -ripemd160`或` -sha -sha1 -sha224 -sha384 -sha512`或`-whirlpool`

或者使用python的hashlib库进行加解密

## 参考

- **基础**

  [什么命令可以生成sha256](https://cloud.tencent.com/developer/ask/28517)