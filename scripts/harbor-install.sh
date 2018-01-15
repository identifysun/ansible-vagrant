#! /bin/bash
# Harbor on Ubuntu 18.04
# https://gist.github.com/kacole2/95e83ac84fec950b1a70b0853d6594dc
set -xe

HARBOR_VERSION=v2.5.5
HARBOR_HOSTNAME=harbor.example.com

# Update hosts
ipaddr=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -Ev '127.0.0.1|10.0.2.15'`
grep -ic harbor /etc/hosts || echo "${ipaddr}   harbor ${HARBOR_HOSTNAME}" >> /etc/hosts

#Install Latest Stable Docker Release
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "insecure-registries" : ["$ipaddr:443","$ipaddr:80","0.0.0.0/0"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
groupadd docker
MAINUSER=$(logname)
usermod -aG docker $MAINUSER
systemctl daemon-reload
systemctl restart docker
echo "Docker Installation done"

# Download the Harbor installation package
cd /opt
harbor_install_package="harbor-offline-installer-${HARBOR_VERSION}.tgz"
if [ ! -f "/opt/$harbor_install_package" ]; then
    wget "https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/${harbor_install_package}"
fi
tar -xvf $harbor_install_package -C /opt

#
mkdir -pv /opt/harbor/ssl
if [ -d "/opt/harbor/ssl" ]; then
    cd /opt/harbor/ssl
    openssl genrsa -out example-ca.key 4096
    openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=CN/ST=Beijing/L=Beijing/O=Example Inc./OU=www.example.com/CN=Example Root CA" \
    -key example-ca.key -out example-ca.crt
    openssl genrsa -out harbor.example.com.key 4096
    openssl req -sha512 -new \
        -subj "/C=CN/ST=Beijing/L=Beijing/O=Example Inc/OU=Tech/CN=harbor.example.com" \
        -key harbor.example.com.key \
        -out harbor.example.com.csr
    cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=${HARBOR_HOSTNAME}
DNS.2=harbor
EOF
    openssl x509 -req -sha512 -days 3650 \
        -extfile v3.ext \
        -CA example-ca.crt -CAkey example-ca.key -CAcreateserial \
        -in harbor.example.com.csr \
        -out harbor.example.com.crt

    cp example-ca.crt /usr/local/share/ca-certificates
    update-ca-certificates
else
    echo "Create /opt/harbor/ssl failed."
    exit -1
fi

cd /opt/harbor
cp harbor.yml.tmpl harbor.yml
sed -i "s/reg.mydomain.com/${HARBOR_HOSTNAME}/g" harbor.yml
sed -i "/certificate/ s/certificate: .*/certificate: \/opt\/harbor\/ssl\/${HARBOR_HOSTNAME}.crt/" harbor.yml
sed -i "/private_key/ s/private_key: .*/private_key: \/opt\/harbor\/ssl\/${HARBOR_HOSTNAME}.key/" harbor.yml

#
./install.sh --with-notary --with-trivy --with-chartmuseum
echo -e "Harbor Installation Complete \n\nPlease log out and log in or run the command 'newgrp docker' to use Docker without sudo\n\nLogin to your harbor instance:\n docker login -u admin -p Harbor12345 $ipaddr"







