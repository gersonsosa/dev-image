FROM archlinux:base-devel

RUN pacman -Syu --noconfirm \
    sudo \
    gettext \
    cmake \
    zip \
    unzip \
    curl \
    wget \
    jq \
    less \
    htop \
    bottom \
    lsof \
    fish \
    fzf \
    fzy \
    tmux \
    git \
    git-lfs \
    neovim \
    ripgrep \
    fd \
    procs \
    dust \
    exa \
    bat \
    starship \
    tree-sitter \
    && locale-gen en_US.UTF-8

RUN git lfs install --system --skip-repo

RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod

# configure the basics with user
USER gitpod

ENV HOME=/home/gitpod
WORKDIR $HOME

RUN mkdir -p $HOME/.config/fish/conf.d \
    && mkdir -p $HOME/.config/fish/completions

# install node tools
RUN curl -fLO https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh \
    && chmod +x install.sh \
    && ./install.sh

ENV PATH=$HOME/.local/share/fnm:$PATH

RUN fnm install v20 && fnm default v20 \
    && fnm completions --shell=fish > $HOME/.config/fish/completions/fnm.fish \
    && printf '%s\n' 'fnm env --use-on-cd | source' > $HOME/.config/fish/conf.d/fnm.fish \
    && fish -c 'fish_add_path $HOME/.local/share/fnm'

# configure fish
RUN mkdir -p $HOME/local/share/fonts \
    && cd $HOME/local/share/fonts \
    && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraMono/Regular/FiraMonoNerdFont-Regular.otf \
    && printf '%s\n' 'starship init fish | source' > $HOME/.config/fish/conf.d/starship.fish

ENV SHELL=/usr/bin/fish
