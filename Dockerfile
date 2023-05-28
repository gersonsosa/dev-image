FROM ubuntu:latest

RUN apt-get update && apt-get install -yq \
    sudo \
    software-properties-common \
    ninja-build \
    build-essential \
    iputils-ping \
    man-db \
    stow \
    time \
    multitail \
    ssl-cert \
    pkg-config \
    libssh-dev \
    locales \
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
    tmux \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && locale-gen en_US.UTF-8

RUN add-apt-repository -y ppa:git-core/ppa
RUN apt-get update && apt-get install -yq \
    git git-lfs

RUN git lfs install --system --skip-repo

RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

# start installing dev tools with final user
USER gitpod

ENV HOME=/home/gitpod
WORKDIR $HOME
# install dev tools: ripgrep, fd, exa using cargo
ENV PATH=$HOME/.cargo/bin:$PATH

RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path --default-toolchain stable \
        -c rls rust-analysis rust-src rustfmt clippy miri rust-analyzer \
    && mkdir -p ~/.config/fish/completions \
    && rustup completions fish > "$HOME/.config/fish/completions/rustup.fish" \
    && mkdir -p ~/.config/fish/conf.d \
    && printf '%s\n'    'export CARGO_HOME=$HOME/.cargo' \
                        'mkdir -m 0755 -p "$CARGO_HOME/bin" 2>/dev/null' \
                        'export PATH=$CARGO_HOME/bin:$PATH' \
                        'test ! -e "$CARGO_HOME/bin/rustup"; and mv (command -v rustup) "$CARGO_HOME/bin"' > $HOME/.config/fish/conf.d/rust.fish \
    && cargo install cargo-watch cargo-edit cargo-workspaces ripgrep fd-find procs du-dust exa bat tree-sitter-cli fnm

ENV TOOLS=$HOME/tools
RUN mkdir -p $TOOLS
WORKDIR $TOOLS

# build neovim
RUN git clone https://github.com/neovim/neovim \
    && cd neovim \
    && git checkout stable \
    && make CMAKE_INSTALL_PREFIX=$HOME/local/nvim install

ENV PATH=$HOME/local/nvim/bin:$PATH

RUN mkdir -p $HOME/local/share/fonts \
    && cd $HOME/local/share/fonts \
    && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraMono/Regular/FiraMonoNerdFont-Regular.otf

RUN cargo install starship --locked \
    && mkdir -p $HOME/.config/fish \
    && echo 'starship init fish | source' > $HOME/.config/fish/conf.d/starship.fish

RUN fnm install v20 && fnm default v20 \
    && fnm completions > $HOME/.config/fish/completions/fnm.fish \
    && echo 'fnm env --use-on-cd | source' > $HOME/.config/fish/conf.d/fnm.fish

ENV SHELL=/usr/bin/fish
