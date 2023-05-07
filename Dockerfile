FROM ubuntu:latest

RUN apt-get update && apt-get install -yq \
    sudo \
    software-properties-common \
    ninja-build \
    gettext \
    cmake \
    zip \
    unzip \
    curl \
    wget \
    jq \
    less \
    htop \
    lsof \
    fish \
    fzf \
    fzy \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN add-apt-repository -y ppa:git-core/ppa
RUN apt-get update && apt-get install -yq \
    git git-lfs

# install dev tools: ripgrep, fd, exa using cargo

RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

ENV HOME=/home/gitpod
WORKDIR $HOME
RUN git lfs install --system --skip-repo

# build neovim
RUN git clone https://github.com/neovim/neovim && cd neovim \
    && make CMAKE_INSTALL_PREFIX=$HOME/local/nvim install \
    && sudo ln -s $HOME/local/nvim/bin/nvim /usr/local/bin/

USER gitpod