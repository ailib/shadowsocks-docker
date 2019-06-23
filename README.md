# shadowsocks-docker

> 使用 Docker 快速部署 Shadowsocks。

# 准备

```
git clone https://github.com/chiqj/shadowsocks-docker.git
```

## 修改内核参数

`sysctl.conf` 是 Shadowsocks 推荐的内核参数，最好在宿主机上也应用同样的配置。以 Ubuntu 18.04 为例：

```
cd shadowsocks-docker
cp sysctl.conf /etc/sysctl.d/99-shadowsocks.conf
sudo reboot
```

检查配置生效：

```
lsmod | grep bbr
```

如果出现 `tcp_bbr` 则说明正确开启了 bbr 算法。

## 生成 Shadowsocks 配置（可选）

参考示例配置文件生成 Shadowsocks 配置：

```
cp example_config.json config.json
```

例如：

```json
{
    "server":"0.0.0.0",
    "port_password": {
        "8388": "password1",
        "8389": "password2"
    },
    "timeout": 300,
    "method": "aes-256-cfb",
    "fast_open": true
}
```

# docker run 部署

构建镜像：

```
docker build -t shadowsocks .
```

## 使用配置文件

运行时需要：

- 指定端口映射；
- 指定配置文件目录挂载，docker 镜像中配置文件目录为 `/shadowsocks`，默认配置文件名为 `config.json`；

```
docker run -d --name shadowsocks \
  -p 8388-8390:8388-8390 \
  -v <HOSTDIR>:/shadowsocks:ro \
  --restart always shadowsocks
```

## 不使用配置文件

运行时需要：

- 指定端口映射；
- 直接指定 `ssserver` 运行参数，参考下表：

```
-s SERVER_ADDR         server address, default: 0.0.0.0
-p SERVER_PORT         server port, default: 8388
-k PASSWORD            password
-m METHOD              encryption method, default: aes-256-cfb
-t TIMEOUT             timeout in seconds, default: 300
--fast-open            use TCP_FASTOPEN, requires Linux 3.7+
--workers WORKERS      number of workers, available on Unix/Linux
--forbidden-ip IPLIST  comma seperated IP list forbidden to connect
--manager-address ADDR optional server manager UDP address, see wiki
-v, -vv                verbose mode
-q, -qq                quiet mode, only show warnings/errors
```

例如：

```
docker run -d -p 8388:8388 shadowsocks -p 8388 -k password
```

# docker-compose 部署

修改 `docker-compose.yaml`中端口映射为实际使用端口。

```
docker-compose up -d
```
