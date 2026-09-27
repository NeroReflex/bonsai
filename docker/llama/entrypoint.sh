#!/bin/bash

set -euo pipefail

if [ ! -f "/models/model.gguf" ]; then
  if [ -f "/models/model.name" ]; then
    export HF_MODEL_NAME=$(cat "/models/model.name")
    echo "Will run model $HF_MODEL_NAME"
  else
    echo "No model file found: running in gRPC mode on port 50052"
    ggml-rpc-server -p 50052
  fi
fi

if [ -f "/models/model.conf" ]; then
    echo "Loading /models/model.conf"
    source /models/model.conf
else
    echo "Missing /models/model.conf: ignoring..."
    readonly MODELS_ARGS=()
fi

if [ -f "/models/model.gguf" ]; then
  export MODEL_ARGS=(
    -m "/models/model.gguf"
  )
else
  export MODEL_ARGS=(
    -hf "$HF_MODEL_NAME"
  )
fi

export SERVER_ARGS=(
    -t 28
    -fa on
    --warmup
    --host 0.0.0.0
    --port 8080
    --api-key fk-api-key
)

export GGML_CUDA_GRAPH_OPT=1

if [ -f "/models/mmproj.gguf" ]; then
    SERVER_ARGS+=(--mmproj "/models/mmproj.gguf")
fi

# Download models in the /models directory
export LLAMA_CACHE="/models"

llama-server "${MODEL_ARGS[@]}" "${SERVER_ARGS[@]}" "${MODEL_ARGS[@]}"
