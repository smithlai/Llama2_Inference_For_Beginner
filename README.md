# Llama2_Inference_For_Beginner

## Description
This is a simple tutorial depends on Llama2 and LangChain for begginers like me.

There are too many models/components/libraries to inference a LLM if you tried text-generation-webui before.

I have too many questions about how it works and why I should use this?

For example: 

*hf? GGML? GGUF? GPTQ? Transformers, CTransformers, exllama, llama.cpp, gptq.....*  
*Why there is no [INT] or \<\<SYS\>\> in text-generation-webui?*  
*Can we use "User: " and "AI: " to replace Llama2 "[INST]"? If yes, what's the difference*  
*What is the instruction_template, chat-instruct_command?*  
*https://github.com/oobabooga/text-generation-webui/discussions/3644*  
......
.......

There are too many mystories in LLM, especially when the are wrapped in text-generation-ui or LangChain.

As a result, I tried to start from scratch, step by step.

This project is merely a simple record for studying and practicing, and still work in progress.

**Note**: Some descriptions and comments are still written in Chinese


-----------------------------------------------------------
## prerequisite:

1. Windows WSL2 + Ubuntu  
   _OR_
   Ubuntu
  
2. NVidia GPU w/ driver installed

-----------------------------------------------------------

## Quick Start  

**Ubuntu Docker**  

Please refers to: [Setup & Installation](#setup--installation)  


**console#1**  
modify the model folder path in **.env**  
Example:
```shell
HOST_MODEL_PATH="~/llama2/llama2_models/"
HOST_LORA_PATH="~/llama2_loras/"
```
We will mount the path folder into docker.

`cd docker && docker compose up --build`  
before open jupyterlab browser (127.0.0.1:7888).

**Optional: Load/Save**  
You can save/load image like this:  
`docker save -o docker-llama2_inference_for_beginner-1.tar docker-llama2_inference_for_beginner-1`  
__AND__   
`docker load -i docker-llama2_inference_for_beginner-1.tar`  

And you can exec command here  
**console#2**  

`docker exec -it docker-llama2_inference_for_beginner-1 /entrypoint.sh bash`  

**Note**:  
if you want pip install anything in console, make sure to source `. /app/venv/bin/activate` first  

---------------------------------------------------
## Setup & Installation

### Setup cuda
  If you are WSL, refers to [WSLSetup.md](./wsl/WSLSetup.md)

  If you are Linux, install NV driver and CUDA:  
  https://www.nvidia.com/download/index.aspx  
  https://developer.nvidia.com/cuda-downloads  


### Setup Docker

auto install docker  
`sudo ./docker/install_docker.sh`  

**Remember to re-login**

check docker cuda
`docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi`

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
