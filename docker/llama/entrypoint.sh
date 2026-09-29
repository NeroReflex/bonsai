#!/bin/bash

set -euo pipefail

# Extra llama-server args from /models/model.conf (defines MODEL_ARGS)
MODEL_ARGS=()

if [ -f "/models/model.gguf" ]; then
  MODEL_SOURCE=(-m "/models/model.gguf")
elif [ -f "/models/model.name" ]; then
  HF_MODEL_NAME=$(cat "/models/model.name")
  echo "Will run model $HF_MODEL_NAME"
  MODEL_SOURCE=(-hf "$HF_MODEL_NAME")
else
  echo "No model file found: running in gRPC mode on port 50052"
  exec ggml-rpc-server -p 50052
fi

if [ -f "/models/model.conf" ]; then
  echo "Loading /models/model.conf"
  source /models/model.conf
else
  echo "Missing /models/model.conf: ignoring..."
fi

SERVER_ARGS=(
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

echo "Starting: llama-server ${MODEL_SOURCE[*]} ${SERVER_ARGS[*]} ${MODEL_ARGS[*]}"
exec llama-server "${MODEL_SOURCE[@]}" "${SERVER_ARGS[@]}" "${MODEL_ARGS[@]}"
