# CentOS Mirror

## 1. 配置方法

通知：CentOS 8 操作系统版本结束了生命周期（EOL），Linux 社区已不再维护该操作系统版本。建议您切换到 Anolis 或 Alinux。如果您的业务过渡期仍需要使用 CentOS 8 系统中的一些安装包，请根据下文切换 CentOS 8 的源。

### 1.1. 备份

```shell
$ mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
```

### 1.2. 下载新的 CentOS-Base.repo 到 /etc/yum.repos.d/

#### 1.2.1. centos8（centos8 官方源已下线，建议切换 centos-vault 源）

```shell
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo
```

或者

```shell
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo
```

#### 1.2.2. centos6（centos6 官方源已下线，建议切换 centos-vault 源）

```shell
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-6.10.repo
```

或者

```shell
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-6.10.repo
```

#### 1.2.3. CentOS 7

```shell
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
```

或者

```shell
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
```

### 1.3. 运行 yum makecache 生成缓存

### 1.4. 其他

非阿里云 ECS 用户会出现 Couldn't resolve host 'mirrors.cloud.aliyuncs.com' 信息，不影响使用。用户也可自行修改相关配置: eg:

```shell
sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
```

CentOS 8 结束生命周期如何切换源

公网用户：

```shell
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo
yum clean all && yum makecache
```

阿里云 ecs 用户：

```shell
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.aliyuncs.com/repo/Centos-vault-8.5.2111.repo
sed -i 's/mirrors.cloud.aliyuncs.com/url_tmp/g' /etc/yum.repos.d/CentOS-Base.repo && sed -i 's/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/CentOS-Base.repo && sed -i 's/url_tmp/mirrors.aliyun.com/g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all && yum makecache
```
