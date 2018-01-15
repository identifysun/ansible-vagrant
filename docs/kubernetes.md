# 基于 Kubernetes 部署 Java Web 应用

## 关闭 Centos 自带的防火墙服务：

```
systemctl disable firewalld
systemctl stop    firewalld
```

## 安装 etcd 和 Kubernetes 软件 (会自动安装 Docker 软件):

```
yum install -y etcd kubernetes
```

## 安装好软件后，修改两个配置文件（其他配置文件使用系统默认的配置参数即可）。

Docker 配置文件为 /etc/sysconfig/docker，其中 OPTIONS 的内容设置为：

```
OPTIONS='--selinux-enabled=false --insecure-reggistry gcr.io'
```

Kubernetes apiserver 配置文件为 /etc/kubernetes/apiserver，把
--admission_control 参数中的 ServiceAccount 删除。

## 按顺序启动所有服务:

```
systemctl start etcd
systemctl start docker
systemctl start kube-apiserver
systemctl start kube-controller-manager
systemctl start kube-scheduler
systemctl start kubelet
systemctl start kube-proxy
```

至此，一个简单的 Kubernetes 集群环境就安装启动完成了。
