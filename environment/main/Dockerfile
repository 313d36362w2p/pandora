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
    libusb-dev \
    xz-utils \
    gcc \
    clang \
    musl-tools \
    libc6-dev \
    git \
    tmux \
    python3 \
    opensc \
    adb \
    binutils \
    bridge-utils \
    usbutils \
    curl \
    wget \
    file \
    ssh \
    gpg \
    python3-venv \
    jq \
    gdb \
    ripgrep \
    npm \
    fzf

# Setup Rust installation
RUN if ! command -v rustc &> /dev/null; then \
    echo "Rust not found. Installing Rust..."; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; \
    echo ". '$HOME/.cargo/env'" >> $HOME/.bashrc; \
    else \
    echo "Rust is already installed."; \
    fi

# Set up SSH keys (optional step in Docker context)
RUN mkdir -p /root/.ssh && \
    ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519 -a 100 -C ""

# Copy Local Tools (Mostly Useful Configurations)
COPY tools/ /root/tools

# Get the Latest Binaries for Frida
RUN wget -O /root/tools/binaries/frida-server.xz $(curl -s https://api.github.com/repos/frida/frida/releases/latest | jq -r '.assets[] | select(.name | test("frida-server.*android-arm64\\.xz$")) | .browser_download_url') && \
xz -f -d /root/tools/binaries/frida-server.xz

# Setup Frida Virtual Environment
RUN cd /root ; python3 -m venv frida

# Install Radare2
RUN cd /root/tools/ ; git clone https://github.com/radareorg/radare2 && \
    cd radare2 ; sys/install.sh

# Install NeoVIM and AstroNVIM Template
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> /root/.bashrc && \
    echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.bashrc && \
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin" && \
    export PATH="/root/.local/bin:$PATH" && \
    git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim && \
    rm -rf /root/.config/nvim/.git


WORKDIR /root

# Entry point
CMD [ "bash", "&&", "source", "frida/bin/activate" ]
