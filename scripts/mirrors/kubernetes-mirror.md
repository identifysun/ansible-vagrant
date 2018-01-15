# Kubernetes 镜像

Kubernetes 是一个开源系统，用于容器化应用的自动部署、扩缩和管理。它将构成应用的容器按逻辑单位进行分组以便于管理和发现。

下载地址：https://mirrors.aliyun.com/kubernetes/

## 配置方法

### Debian / Ubuntu

```shell
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

### CentOS / RHEL / Fedora

```shell
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet
```

> ps: 由于官网未开放同步方式, 可能会有索引 gpg 检查失败的情况, 这时请用 `yum install -y --nogpgcheck kubelet kubeadm kubectl` 安装

https://developer.aliyun.com/mirror/kubernetes?spm=a2c6h.13651102.0.0.3e221b116M5haG
