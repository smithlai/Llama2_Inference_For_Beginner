# my_cuda_jupyterlab


## Quick Start  

**Ubuntu Docker**  
Please refers to: [Ubuntu docker (WSL)](#ubuntu-docker-wsl)  

> console#1  
`cd docker && docker compose up --build -d`
`docker save -o docker-my_cuda_jupyter_lab.tar docker-my_cuda_jupyter_lab`
__OR__
`docker load -i docker-my_cuda_jupyter_lab.tar`

> console#2  
`docker exec -it my_cuda_jupyterlab-1 /entrypoint.sh bash`  


---------------------------------------------------
## Ubuntu docker (WSL)
Refers to [WSLSetup.md](./wsl/WSLSetup.md)

### Setup Docker in WSL

auto install docker  
`sudo ./docker/install_docker.sh`  

**Remember to re-login**

check docker cuda
`docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi`

__OR__

---------- Deprecated, for inference only -------------
https://docs.docker.com/engine/install/ubuntu/
```sh
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "\
  $(. /etc/os-release && echo $VERSION_CODENAME)" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
sudo systemctl restart docker
```


#### (Optional) Docker IP conflict
*Note* : Prevent dcoker from subnet ip conflict with 172.1x.xxx.xxx
> https://serverfault.com/questions/916941/configuring-docker-to-not-use-the-172-17-0-0-range

*Note1*: Sometimes the docker will re-start fail, you can try to do it again later.
*Note2*: https://stackoverflow.com/questions/43988006/docker-create-two-bridges-that-corrupts-my-internet-access
>        the default empty bip means it will just grab an allocation from the pool, like any other network/container will.
```bash

$ sudo vi /etc/docker/daemon.json
{
  "default-address-pools" : [
    {
      "base" : "172.118.0.0/16",
      "size" : 24
    }
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}

sudo systemctl restart docker
```
