FROM nvidia/cuda:13.4.1-cudnn-devel-ubuntu26.04

RUN mkdir /workspace
WORKDIR /workspace

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ccache \
    libssl-dev \
    pkg-config \
    openssl \
    cmake \
    git \
    wget \
    curl \
    unzip \
    ca-certificates \
    python3 \
    python3-venv \
    python3-pip \
    libopenblas-dev \
    libomp-dev \
    && rm -rf /var/lib/apt/lists/*

# Download sources
#RUN wget https://github.com/ggml-org/llama.cpp/archive/refs/tags/b9158.zip
#RUN unzip b9158.zip && rm b9158.zip
#RUN mv llama.cpp-b9158 llama.cpp

#RUN git clone https://github.com/johndpope/llama-cpp-turboquant.git

#RUN git clone https://gitlab.neroreflex.duckdns.org/NeroReflex/llama.cpp.git
#RUN cd llama.cpp && git checkout feature/turboquant-kv-cache

RUN git clone https://github.com/PrismML-Eng/llama.cpp
RUN cd llama.cpp

WORKDIR /workspace/llama.cpp

# Build with CUDA support - flags may vary by llama.cpp version
RUN cmake -B build -DGGML_CUDA=ON -DGGML_CUDA_GRAPH=ON \
        -DGGML_NATIVE=ON -DGGML_CUDA_F16=ON -DGGML_CUDA_FA=ON -DGGML_CUDA_FA_ALL_QUANTS=ON -DGGML_LTO=ON  -DCMAKE_CUDA_ARCHITECTURES="89" \
        -DLLAMA_BUILD_EXAMPLES=OFF -DLLAMA_BUILD_IS_DEV=OFF -DLLAMA_BUILD_TESTS=OFF \
        -DCMAKE_BUILD_TYPE=Release

RUN cmake --build build --config Release --parallel 28
RUN cmake --install build

VOLUME /models

COPY entrypoint.sh /llama.sh
RUN chmod a+x /llama.sh

CMD [ "/llama.sh" ]

EXPOSE 8080/tcp

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8080/v1/health || exit 1
