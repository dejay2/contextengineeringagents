# Multi-purpose development container for Claude Code
# Includes Node.js, Python, and common development tools

FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install basic system dependencies and development tools
RUN apt-get update && apt-get install -y \
    # Basic utilities
    curl \
    wget \
    git \
    vim \
    nano \
    zip \
    unzip \
    jq \
    tree \
    htop \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    locales \
    tzdata \
    # Network tools
    net-tools \
    iputils-ping \
    dnsutils \
    netcat \
    telnet \
    # Development tools
    make \
    gcc \
    g++ \
    cmake \
    pkg-config \
    # Python and pip
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    # Additional libraries
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm, yarn, and common global npm packages
RUN npm install -g \
    pnpm \
    yarn \
    typescript \
    tsx \
    ts-node \
    nodemon \
    pm2 \
    jest \
    mocha \
    vitest \
    eslint \
    prettier \
    @biomejs/biome \
    rimraf \
    concurrently \
    wait-on \
    cross-env

# Install Python packages for testing and development
RUN pip3 install --no-cache-dir \
    pytest \
    pytest-cov \
    pytest-asyncio \
    pytest-mock \
    black \
    flake8 \
    mypy \
    ruff \
    pylint \
    autopep8 \
    ipython \
    jupyter \
    pandas \
    numpy \
    requests \
    httpx \
    fastapi \
    uvicorn \
    python-dotenv \
    pydantic \
    rich

# Install Rust (useful for some npm packages that need to compile)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Go (useful for some tools)
RUN wget -q https://go.dev/dl/go1.21.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz \
    && rm go1.21.0.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Docker CLI (for Docker-in-Docker scenarios)
RUN curl -fsSL https://get.docker.com | sh

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install ripgrep for fast searching
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb \
    && dpkg -i ripgrep_14.1.0-1_amd64.deb \
    && rm ripgrep_14.1.0-1_amd64.deb

# Install bat for better file viewing
RUN curl -LO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb \
    && dpkg -i bat_0.24.0_amd64.deb \
    && rm bat_0.24.0_amd64.deb

# Install fzf for fuzzy finding
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install --all

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create a workspace directory
WORKDIR /workspace

# Set up a non-root user (optional, but can be enabled)
# RUN useradd -m -s /bin/bash developer && \
#     echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# USER developer

# Set bash as default shell
SHELL ["/bin/bash", "-c"]

# Keep container running
CMD ["bash"]