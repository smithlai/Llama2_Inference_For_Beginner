#!/bin/bash
# SUDO_USER=env | grep SUDO_USER | awk '{split($0,a,"="); print a[2]}'
# SUDO_UID=env | grep SUDO_UID | awk '{split($0,a,"="); print a[2]}'
# SUDO_GID=env | grep SUDO_GID | awk '{split($0,a,"="); print a[2]}'
is_sudo_root ()
{
    [ "$(id -u)" -eq 0  ]
}
# is_sudo_user ()
# {
#     [ "$SUDO_UID" != 0  ]
# }
if is_sudo_root; then
    echo 'You are the in sudo privilege!'
    # You can do whatever you need...
else
    echo 'You are not sudo'
    exit 1
fi
# if is_sudo_user; then
# fi
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin

mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600

FILE=cuda-repo-wsl-ubuntu-12-2-local_12.2.2-1_amd64.deb
if [ ! -f "$FILE" ]; then
    wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/"$FILE"
fi
dpkg -i cuda-repo-wsl-ubuntu-12-2-local_12.2.2-1_amd64.deb
cp -f /var/cuda-repo-wsl-ubuntu-12-2-local/cuda-*-keyring.gpg /usr/share/keyrings/
apt update
echo "*** Installing Cuda... ***"
apt install -y cuda
# echo "*** Installing nvidia-cuda-toolkit ... ***"
# sudo apt install -y nvidia-cuda-toolkit #(不需要)
# sudo apt install nvidia-utils-535 #(不需要)
