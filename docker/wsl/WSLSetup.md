# Ubuntu docker (WSL)

## install WSL and WSL Ubuntu

### Enable WSL2
This only execute one time  
```powershell
# Administrator mode
#dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All
#dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All
#DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
#dism.exe /online /enable-feature /featurename:Containers /all
Enable-WindowsOptionalFeature -Online -FeatureName containers –All

# bcdedit /set hypervisorlaunchtype auto
```

### Install Ubuntu
```powershell
# Administrator mode
wsl --update # make sure you have latest wsl
wsl --install -d Ubuntu-22.04  # you may have to try many times
wsl --status

```

If there's any problem, try `wsl --shutdown` to restart.
__OR__

try `wsl --unregister Ubuntu-22.04` to remove previous failed install/uninstall

### WSL ssh  (in Ubuntu shell)
the SSH in WSL2 ubuntu is not openssh.
https://www.cnblogs.com/ucos/p/16998981.html

```sh
sudo apt update
sudo apt install -y ssh
sudo vi /etc/ssh/sshd_config
```
> Port 44
> ListenAddress 0.0.0.0
> PermitRootLogin yes
> PasswordAuthentication yes

`sudo service ssh restart`

## WSL Cuda  
1. Driver+Cuda
https://docs.nvidia.com/cuda/wsl-user-guide/index.html#getting-started-with-cuda-on-wsl
Install Windows Driver will also install WSL2 Driver (nvidia-smi)
So **DO NOT install ANY derver in WSL2**

2. Cuda in WSL
https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local
`sudo ./wsl_install_cuda20.sh`