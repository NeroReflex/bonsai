# Bonsai

This repo holds a template to be able to run [bonsai](https://prismml.com/news/bonsai-2-27b) Q2 at full context window on a 16GB nVidia card!

You can also run whatever other model you like, including the great [Qwen3.8 flash next](https://huggingface.co/unsloth/Qwen3.8-Flash-Next-GGUF) and [GLM 5.3 Flash Next](https://huggingface.co/unsloth/GLM-5.3-Flash-GGUF).

## Prerequisites

Make sure you have docker, docker-buildx, docker-compose installed, the official nvidia driver and the container toolkit configured for docker.

You can follow official nvidia instruction [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

Only nVidia GPUs are supported at the moment.

## Instructions

Head straight to [huggingface](https://huggingface.co/) deciding what model to run and get its name:quant.

I suggest [bonsai-2](https://huggingface.co/prism-ml/Ternary-Bonsai-2-27B-gguf) for 16GB GPUs.

Place in models a file named *model.name* containing the name of the model to run, for example __prism-ml/Ternary-Bonsai-2-27B-gguf:Q2_0__


```sh
docker compose up
```

and when things go well you can press "D" key to detach.

__WARNING__ depending on the model size download might take quite some time.

## How to

Intended usage is via [OpenCode](https://opencode.ai/) or other harness for development.

You also have a chat at http://127.0.0.1:8080, the default API key is fk-api-key (change it).

## OpenWebUI

There is an OpenWebUI page at http://127.0.0.1:3000 where you can configure an OpenAI-compatible model like this:

```
Base URL: http://llama:8080/v1
Authentication: Bearer Token fk-api-key
```

## Hermes

Hermes is a bit more involved to setup. Guide coming soon.

## OpenCode

If you want to use [OpenCode](https://opencode.ai/) install it any way you like.

Configure it by editing *.config/opencode/opencode.json*: use something similar to this configuration:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "compaction": {
    "auto": true,
    "prune": true,
    "reserved": 20000
  },
  "provider": {
    "cluster": {
      "name": "personallm",
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "model": {
          "limit": {
            "context": 262144,
            "output": 32768
          },
          "name": "model"
        }
      }
    }
  }
}
```

