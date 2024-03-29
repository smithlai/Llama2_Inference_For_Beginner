# ==== Image1: Clone and build GPTQ-for-LLaMa ====
# FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as builder

# RUN apt-get update && \
#     apt-get install --no-install-recommends -y git vim build-essential python3-dev python3-venv && \
#     rm -rf /var/lib/apt/lists/*


# RUN git clone https://github.com/oobabooga/GPTQ-for-LLaMa /build

# WORKDIR /build

# RUN python3 -m venv /build/venv
# RUN . /build/venv/bin/activate && \
#     pip3 install --upgrade pip setuptools wheel && \
#     pip3 install torch torchvision torchaudio && \
#     pip3 install -r requirements.txt

# # https://developer.nvidia.com/cuda-gpus
# # for a rtx 2060: ARG TORCH_CUDA_ARCH_LIST="7.5"
# ARG TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX}"
# RUN . /build/venv/bin/activate && \
#     python3 setup_cuda.py bdist_wheel -d .

# ==== Image2: Our Working Docker ====
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

LABEL maintainer="SmithLai <smith_lai@usiglobal.com>"
LABEL description="Docker image for normal LLM test"

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-dev git python3 python3-pip && \
    apt-get install --no-install-recommends -y make g++ libportaudio2 libasound-dev curl && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip pip3 install virtualenv
# RUN mkdir /app
WORKDIR /app


RUN virtualenv /app/venv
RUN . /app/venv/bin/activate && \
    pip3 install --upgrade pip setuptools wheel && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# COPY --from=builder /build /app/repositories/GPTQ-for-LLaMa
# RUN . /app/venv/bin/activate && \
#     pip3 install /app/repositories/GPTQ-for-LLaMa/*.whl


COPY ./requirement.txt ./docker/launch-jupyterlab.sh /app/
RUN . /app/venv/bin/activate && \
    pip3 install -r /app/requirement.txt && \
    curl https://ollama.ai/install.sh | sh && \
    chmod u+x /app/launch-jupyterlab.sh
# ENV CLI_ARGS=""
# CMD . /app/venv/bin/activate && python3 server.py ${CLI_ARGS}
CMD ./launch-jupyterlab.sh
