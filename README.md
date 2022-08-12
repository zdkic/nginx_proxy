```
docker build . -t myproxy
docker run -it -d -p8888:8888 myproxy
curl https://www.baidu.com/ -v -x 127.0.0.1:8888
```
