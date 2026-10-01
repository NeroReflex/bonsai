# Bonsai

This repo holds a template to be able to run [bonsai](https://prismml.com/news/bonsai-2-27b) Q2 at full context window on a 16GB nVidia card!

You can also run whatever other model you like, including the great [Qwen3.8 flash next](https://huggingface.co/unsloth/Qwen3.8-Flash-Next-GGUF) and [GLM 5.3 Flash Next](https://huggingface.co/unsloth/GLM-5.3-Flash-GGUF).

## Prerequisites

Make sure you have docker, docker-compose installed and the official nvidia driver.

Only nVidia GPUs are supported at the moment.
If nvidia-toolkit is needed you can follow official nvidia instruction [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).
Container toolkit needs to be configured for docker it that case.
```
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```
## Instructions

Head straight to [huggingface](https://huggingface.co/) deciding what model to run and get its name:quant.

I suggest [bonsai-2](https://huggingface.co/prism-ml/Ternary-Bonsai-2-27B-gguf) for 16GB GPUs.

Place in the models folder a file named __model.name__ containing the name of the model to run, for example *prism-ml/Ternary-Bonsai-2-27B-gguf:Q2_0*
or *unsloth/Qwen3.8-Flash-Next-GGUF:UD-Q3_K_XL*.

Alternatively you can place in the models folder a file named __model.gguf__ with the model to run (or manage it via symlinks e.g ln -s Ternary-Bonsai-2-27B-gguf model.gguf).

__NOTE__ if __model.mmproj.gguf__ file is present it will be loaded and vision will be available.

If neither files exists llama.cpp will be run in server mode, so that another llama.cpp instance can use hardware resources.

```sh
docker compose up
```

and when things go well you can press "D" key to detach.

__WARNING__ depending on the model size download might take quite some time.

## Model tweaking

You can tweak model setting by editing the models/model.conf file with llama.cpp parameters, for example I use these for qwen3.8 flash next:

```
-ctk q8_0 -ctv turbo3
-nr --cpu-moe --no-host --moe-cache 2300
--load-mode mmap
-t 12 -tb 12 -c 131072 -b 32 -ub 32
--temp 1.0 --top-p 0.95 --chat-template-kwargs '{"reasoning_effort":"xhigh"}'
```

If you have spare VRAM either increase context size, -b and -ub (keep them equals) or increase the --moe-cache to keep more of the model in GPU VRAM.

## How to

Intended usage is via [OpenCode](https://opencode.ai/) or other harness for development.

## OpenWebUI

There is an OpenWebUI page at http://127.0.0.1:3000 where you can configure a connection ___OpenAI-compatible___ model like this:

```
Base URL: http://server-ip:8080
Authentication: fk-api-key
```

## Hermes

Hermes is a bit more involved to setup. Guide coming soon.

## OpenCode

If you want to use [OpenCode](https://opencode.ai/) install it any way you like.

Configure it by editing *.config/opencode/opencode.json*: use something similar to this configuration:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "cluster/bonsai-2-27b",
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
        "baseURL": "http://127.0.0.1:8080/v1",
        "apiKey": "fk-api-key"
      },
      "models": {
        "qwen38-27b-No-vision": {
          "name": "Qwen3.8 27B",
          "modalities": {
            "input": ["text"],
            "output": ["text"]
          },
          "limit": {
            "context": 131072,
            "output": 32768
          }
        },
        "qwen38-27b-Vision": {
          "name": "Qwen3.8 27B (vision)",
          "modalities": {
            "input": ["text", "image"],
            "output": ["text"]
          },
          "limit": {
            "context": 131072,
            "output": 32768
          }
        },
        "bonsai-2-27b": {
          "name": "Ternary Bonsai 2 27B",
          "modalities": {
            "input": ["text"],
            "output": ["text"]
          },
          "limit": {
            "context": 131072,
            "output": 32768
          }
        }
      }
    }
  }
}
```

