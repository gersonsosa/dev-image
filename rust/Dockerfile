FROM hghar/arch-dev-gitpod:latest

# install rust dev tools
ENV PATH=$HOME/.cargo/bin:$PATH

RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path --default-toolchain stable \
        -c rls rust-analysis rust-src rustfmt clippy miri rust-analyzer \
    && mkdir -p ~/.config/fish/completions \
    && rustup completions fish > "$HOME/.config/fish/completions/rustup.fish" \
    && mkdir -p ~/.config/fish/conf.d \
    && printf '%s\n'    'set -x CARGO_HOME $HOME/.cargo' \
                        'mkdir -m 0755 -p "$CARGO_HOME/bin" 2>/dev/null' \
                        'fish_add_path $CARGO_HOME/bin' \
                        'test ! -e "$CARGO_HOME/bin/rustup"; and mv (command -v rustup) "$CARGO_HOME/bin"' > $HOME/.config/fish/conf.d/rust.fish

RUN cargo install cargo-workspaces cargo-watch cargo-edit
