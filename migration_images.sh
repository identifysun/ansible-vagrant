#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

KUBE_VERSION=v1.11.2
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.2.18
CORE_DNS_VERSION=1.1.3

GCR_URL=gcr.io/google_containers
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/google_containers

SOURCE_URL=$ALIYUN_URL
DEST_URL=nexus.twdns.top:5002/google_containers

images=(kube-proxy-amd64:${KUBE_VERSION}
kube-scheduler-amd64:${KUBE_VERSION}
kube-controller-manager-amd64:${KUBE_VERSION}
kube-apiserver-amd64:${KUBE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
etcd-amd64:${ETCD_VERSION}
coredns:${CORE_DNS_VERSION})
# k8s-dns-sidecar-amd64:${DNS_VERSION}
# k8s-dns-kube-dns-amd64:${DNS_VERSION}
# k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION})


for imageName in ${images[@]} ; do
  docker pull $SOURCE_URL/$imageName
  docker tag $SOURCE_URL/$imageName $DEST_URL/$imageName
  docker push $DEST_URL/$imageName
  docker rmi $DEST_URL/$imageName
done
