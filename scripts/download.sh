#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Download the etcd, flannel, and K8s binaries automatically and stored in files roles directory
# author @resouer @WIZARD-CXY
set -eux

function cleanup {
  # cleanup work
  rm -rf flannel* kubernetes* etcd* binaries
}
trap cleanup SIGHUP SIGINT SIGTERM

pushd $(dirname $0)
mkdir -p binaries

# ectd
ETCD_VERSION=${ETCD_VERSION:-"3.3.20"}
ETCD="etcd-v${ETCD_VERSION}-linux-amd64"
echo "Prepare etcd ${ETCD_VERSION} release ..."
grep -q "^${ETCD_VERSION}\$" binaries/.etcd 2>/dev/null || {
    curl -L https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/${ETCD}.tar.gz -o binaries/${ETCD}.tar.gz
    echo ${ETCD_VERSION} > binaries/.etcd
}

# k8s
KUBE_VERSION=${KUBE_VERSION:-"1.17.5"}
echo "Prepare kubernetes ${KUBE_VERSION} release ..."
grep -q "^${KUBE_VERSION}\$" binaries/.kubernetes 2>/dev/null || {
    curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-apiserver" -o binaries/kube-apiserver
    curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-controller-manager" -o binaries/kube-controller-manager
    curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-scheduler" -o binaries/kube-scheduler
    curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" -o binaries/kubectl
    curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-proxy" -o binaries/kube-proxy
    curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubelet" -o binaries/kubelet
    echo ${KUBE_VERSION} > binaries/.kubernetes
}

# docker
DOCKER_VERSION=${DOCKER_VERSION:-"19.03.9"}
DOCKER="docker-${DOCKER_VERSION}"
echo "Prepare docker ${DOCKER_VERSION} release ..."
grep -q "^${DOCKER_VERSION}\$" binaries/.docker 2>/dev/null || {
    curl -L "https://download.docker.com/linux/static/stable/x86_64/${DOCKER}.tgz" -o binaries/${DOCKER}.tgz
    echo ${DOCKER_VERSION} > binaries/.docker
}

echo "Done! All your binaries locate in tests/binaries directory"
popd
