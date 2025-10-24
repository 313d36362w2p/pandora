# Use the supplied image and architecture for the base image
FROM docker.io/debian:latest

# Install required packages and tools
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
    build-essential \
    wget \
    unzip \
    libssl-dev \
    gcc \
    clang \
    musl-tools \
    libc6-dev \
    git \
    tmux \
    python3 \
    binutils \
    curl \
    file \
    ssh \
    gpg \
    python3-venv

# Set up SSH keys (optional step in Docker context)
RUN mkdir -p /root/.ssh && \
    ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519 -a 100 -C ""

# Setup Default Virtual Environment
RUN cd /root ; python3 -m venv pandora

WORKDIR /root

# Entry point
CMD [ "bash" ]
