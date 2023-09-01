# my_cuda_jupyterlab


## Quick Start  

**Ubuntu Docker**  
Please refers to: [Ubuntu docker (WSL)](#ubuntu-docker-wsl)  

> console#1  
`cd docker && docker compose up --build -d`

> console#2  
`docker exec -it my_cuda_jupyterlab-1 /entrypoint.sh bash`  


---------------------------------------------------


## Ubuntu docker (WSL)

### install WSL and WSL Ubuntu
```powershell
#dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All
#dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All
#DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
#dism.exe /online /enable-feature /featurename:Containers /all
Enable-WindowsOptionalFeature -Online -FeatureName containers –All

# bcdedit /set hypervisorlaunchtype auto

wsl --install -d Ubuntu-22.04  #有時會發生錯誤，多試幾次
wsl --status
wsl --update #很重要，否則docker可能無法執行
```
https://download.docker.com/win/static/stable/x86_64/

#### WSL ssh  
https://www.cnblogs.com/ucos/p/16998981.html

```sh
sudo apt update
sudo apt install ssh
sudo vi /etc/ssh/sshd_config
```
> Port 44
> ListenAddress 0.0.0.0
> PermitRootLogin yes
> PasswordAuthentication yes

`sudo service ssh restart`

### Setup Docker in WSL

auto install docker  

`./docker/install_docker.sh`  

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
