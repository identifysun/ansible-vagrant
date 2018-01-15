#! /bin/bash
# https://stackoverflow.com/questions/36070562/disable-ssh-root-login-by-modifying-etc-ssh-sshd-conf-from-within-a-script
set -xe

NEWUSR=root
PASSWD=vagrant

if [[ "${UID}" -ne 0 ]]; then
    echo " You need to run this script as root"
    exit 1
fi

# To directly modify sshd_config.
sed -i 's/#\?\(PermitRootLogin\s*\).*$/\1 yes/' /etc/ssh/sshd_config
sed -i 's/#\?\(PasswordAuthentication\s*\).*$/\1 yes/' /etc/ssh/sshd_config
if [[ "${?}" -ne 0 ]]; then
   echo "The sshd_config file was not modified successfully"
   exit 1
fi
systemctl restart sshd.service

# Update passwd
echo "$NEWUSR:$PASSWD" | chpasswd

# OpenJDK
apt-get install openjdk-11-jdk
