#!/bin/bash

set -euo pipefail

# Settings shared by every mode (router and single-model).
SERVER_ARGS=(
  -fa on
  --warmup
  --host 0.0.0.0
  --port 8080
  --api-key fk-api-key
  --no-ui
  --metrics
)

export GGML_CUDA_GRAPH_OPT=1

# Download models in the /models directory
export LLAMA_CACHE="/models"

# --- Router mode: /models/models.ini
if [ -f "/models/models.ini" ]; then
  echo "Router mode: using /models/models.ini"
  echo "Starting: llama-server --models-preset /models/models.ini --models-max 1 ${SERVER_ARGS[*]}"
  exec llama-server \
    --models-preset /models/models.ini \
    --models-max 1 \
    "${SERVER_ARGS[@]}"
fi

# --- Single-model mode
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

if [ -f "/models/mmproj.gguf" ]; then
  SERVER_ARGS+=(--mmproj "/models/mmproj.gguf")
fi

echo "Starting: llama-server ${MODEL_SOURCE[*]} ${SERVER_ARGS[*]} ${MODEL_ARGS[*]}"
exec llama-server "${MODEL_SOURCE[@]}" "${SERVER_ARGS[@]}" "${MODEL_ARGS[@]}"
