#!/bin/bash

set -euo pipefail

if [ -f "/models/model.conf" ]; then
    echo "Loading /models/model.conf"
    source /models/model.conf
else
    echo "Missing /models/model.conf: ignoring..."
    readonly MODELS_ARGS=()
fi

SERVER_ARGS=(
    -m "/models/model.gguf"
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

llama-server "${SERVER_ARGS[@]}" "${MODEL_ARGS[@]}"
