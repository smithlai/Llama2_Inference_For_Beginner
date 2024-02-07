#!/bin/bash


SUDO_USER=env | grep SUDO_USER | awk '{split($0,a,"="); print a[2]}'
SUDO_UID=env | grep SUDO_UID | awk '{split($0,a,"="); print a[2]}'
SUDO_GID=env | grep SUDO_GID | awk '{split($0,a,"="); print a[2]}'

# bool function to test if the user is root or not (POSIX only)
is_sudo_root ()
{
    [ "$(id -u)" -eq 0  ]
}

is_sudo_user ()
{
    [ "$SUDO_UID" != 0  ]
}

if is_sudo_root; then
    echo 'You are the in sudo privilege!'
    # You can do whatever you need...
else
    echo 'You are not sudo'
    exit 1
fi

echo "*** Installing Docker...(Install using the Apt repository) ***"
# https://docs.docker.com/engine/install/ubuntu/
apt update
apt install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "\
  $(. /etc/os-release && echo $VERSION_CODENAME)" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin



if is_sudo_user; then
    echo "*** Adding user $SUDO_USER to Docker... ***"
    usermod -aG docker $SUDO_USER
    # newgrp docker <--This will cut off all scripts later
fi


echo "*** Modifying Docker Network settings... ***"
# script_dir=$(dirname "$0")
# mkdir -p /etc/docker/ && cp -f $script_dir/daemon.json /etc/docker/daemon.json
# if test -f "/etc/docker/daemon.json"; then
#     echo "/etc/docker/daemon.json exists, please check the file content by your self."
#     cat /etc/docker/daemon.json
# else
#     cp daemon.json /etc/docker/daemon.json
# fi



echo "*** Installing nvidia-container-toolkit... ***"
# nvidia-container-toolkit
# we need nvidia-container-runtime-hook to enable docker GPU
# You have to restart docker to make effect
# Or we will get "docker: Error response from daemon: could not select device driver “” with capabilities: [[gpu]]."
#                         Error response from daemon: could not select device driver "nvidia" with capabilities: [[gpu]]
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    apt-get update
apt-get install -y nvidia-container-toolkit


echo "*** Restarting Docker.... ***"
systemctl restart docker

echo "*** DONE ***"

echo "****************** NOTE **********************"
echo "YOU Have to RE-LOGIN or `newgrp docker` to make the docker user/group take effect"
echo "****************** NOTE **********************"