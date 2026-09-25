# Bonsai

This repo holds a template to be able to run [bonsai](https://prismml.com/news/bonsai-2-27b).

## Prerequisites

Make sure you have docker, docker-buildx, docker-composer installed, the official nvidia driver and the container toolkit configured for docker.

You can follow official nvidia instruction [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

## Instructions

Download the [bonsai-2](https://huggingface.co/prism-ml/Ternary-Bonsai-2-27B-gguf) image, suggested for 16GB GPUs:

```
wget https://huggingface.co/prism-ml/Ternary-Bonsai-2-27B-gguf/resolve/main/Ternary-Bonsai-2-27B-PQ2_0.gguf?download=true
mv *.gguf models/Ternary-Bonsai-2-27B-PQ2_0.gguf
cd models
ln -s model.gguf Ternary-Bonsai-2-27B-PQ2_0.gguf
cd ..
```

Then you start the container:

```sh
docker compose up
```

and when things go well you can press "D" key to detach.

## How to

Intended usage is via [OpenCode](https://opencode.ai/) or other harness for development.

You also have a chat at http://127.0.0.1:8080, the default API key is fk-api-key (change it).
