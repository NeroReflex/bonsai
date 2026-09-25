FROM nousresearch/hermes-agent:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ccache \
    clang \
    llvm \
    lld \
    gdb \
    lldb \
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
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo "hermes:hermes" | chpasswd
RUN usermod -aG sudo hermes

USER hermes

CMD [ "gateway", "run" ]

EXPOSE 8642/tcp
EXPOSE 9119/tcp

