#! /bin/bash
# https://github.com/containerd/containerd/releases
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md
set -xe

CONTAINERD_VERSION=1.7.1
CONTAINERD_PACKAGE_NAME="containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz"
CONTAINERD_DOWNLOAD_URL="https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/${CONTAINERD_PACKAGE_NAME}"
CONTAINERD_TMP_PATH="/tmp/${CONTAINERD_PACKAGE_NAME}"
if [ ! -f "${CONTAINERD_TMP_PATH}" ];
then
    wget $CONTAINERD_DOWNLOAD_URL -O "${CONTAINERD_TMP_PATH}"
fi
tar Cxzvf /usr/local "${CONTAINERD_TMP_PATH}"

if [ ! -f "/usr/lib/systemd/system/containerd.service" ];
then
    wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service \
        -O /usr/lib/systemd/system/containerd.service
fi

mkdir -pv /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i -e "s/SystemdCgroup = false/SystemdCgroup = true/g" /etc/containerd/config.toml
systemctl daemon-reload
systemctl enable --now containerd

# Runc
RUNC_VERSION=v1.1.7
RUNC_TMP_PATH=/tmp/runc.amd64
if [ ! -f "${RUNC_TMP_PATH}" ];
then
    wget -O "${RUNC_TMP_PATH}" https://github.com/opencontainers/runc/releases/download/${RUNC_VERSION}/runc.amd64
fi
install -m 755 "${RUNC_TMP_PATH}" /usr/local/sbin/runc


# Installing CNI plugins
CNI_PLUGIN_VERSION=v1.3.0
CNI_PLUGIN_PACKAGE_NAME="cni-plugins-linux-amd64-${CNI_PLUGIN_VERSION}.tgz"
CNI_PLUGIN_URL="https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGIN_VERSION}/cni-plugins-linux-amd64-${CNI_PLUGIN_VERSION}.tgz"
CNI_PLUGIN_TMP_PATH="/tmp/${CNI_PLUGIN_PACKAGE_NAME}"

if [ ! -f "${CNI_PLUGIN_TMP_PATH}" ];
then
    wget -O "${CNI_PLUGIN_TMP_PATH}" "${CNI_PLUGIN_URL}"
fi

mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin "${CNI_PLUGIN_TMP_PATH}"


# crictl
# https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md
VERSION="v1.27.0" # check latest version in /releases page
CRICTL_TMP_PATH="/tmp/crictl-$VERSION-linux-amd64.tar.gz"
if [ ! -f "${CRICTL_TMP_PATH}" ];
then
    wget -O ${CRICTL_TMP_PATH} https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
fi
tar zxvf "${CRICTL_TMP_PATH}" -C /usr/local/bin
rm -f "${CRICTL_TMP_PATH}"

crictl config runtime-endpoint unix:///run/containerd/containerd.sock
crictl config image-endpoint unix:///run/containerd/containerd.sock
cat /etc/crictl.yaml
