安装多个 shadowsocks server 的 Chef 食谱。

## 准备工作

这个食谱没有发布，所以需要使用 Berkshelf 管理。首先安装必要的 gem

    $ gem install chef knife-solo berkshelf

创建一个 solo 项目

    $ knife solo init yourproject
    $ cd yourproject

在 Berksfile 中加入

    cookbook 'shadowsocks', github: 'john1king/shadowsocks-recipe'

执行

    $ berks install

安装 chef 的服务器环境，服务器已安装 chef 的可以跳过

    $ knife solo prepare user@yourhost

## 食用方法

在 `nodes/yourhost.json` 文件中加入 `shadowsocks` 配置，如

```json
{
  "run_list": [
    "shadowsocks",
  ],
  "shadowsocks": {
    "servers": [{
      "name": "admin",
      "password": "******",
      "server_port": 12345
    }, {
      "name": "guest",
      "password": "******",
      "server_port": 23456
    }]
  }
}
```

执行

    $ knife solo cook yourhost

