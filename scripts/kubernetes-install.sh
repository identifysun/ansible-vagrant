#! /bin/bash
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd

function aliyun_kubernetes_mirrors()
{
    apt-get update && apt-get install -y apt-transport-https
    curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
    cat > /etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
}

function kubeadm_config()
{
    kubeadm config print > kubeadm-config.yaml
}

aliyun_kubernetes_mirrors


swapoff -a
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
# Apply sysctl params without reboot
sudo sysctl --system

# kubeadm config print init-defaults --component-configs KubeProxyConfiguration,KubeletConfiguration > kubeadm-config.yaml
