#! /bin/bash
# https://docs.docker.com/engine/install/centos/

# https://www.ibm.com/docs/en/power8?topic=POWER8/p8ef9/p8ef9_selinux_setup.htm
sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config
setenforce 0
sestatus

yum remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine

yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

systemctl start docker
