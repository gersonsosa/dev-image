FROM hghar/arch-dev-gitpod:latest

ARG JAVA_VERSION

USER gitpod

ENV HOME=/home/gitpod
WORKDIR $HOME

RUN curl -fsSL "https://get.sdkman.io" | bash \
 && bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
             && sed -i 's/sdkman_selfupdate_enable=true/sdkman_selfupdate_enable=false/g' /home/gitpod/.sdkman/etc/config \
             && sed -i 's/sdkman_selfupdate_feature=true/sdkman_selfupdate_feature=false/g' /home/gitpod/.sdkman/etc/config \
             && sdk install java ${JAVA_VERSION} \
             && sdk install java 17.0.7.fx-zulu \
             && sdk default java ${JAVA_VERSION} \
             && sdk install gradle \
             && sdk install maven \
             && sdk flush archives \
             && sdk flush temp \
             && mkdir /home/gitpod/.m2 \
             && printf '<settings>\n  <localRepository>/workspace/m2-repository/</localRepository>\n</settings>\n' > /home/gitpod/.m2/settings.xml"

# above, we are adding the sdkman init to .bashrc (executing sdkman-init.sh does that), because one is executed on interactive shells, the other for non-interactive shells (e.g. plugin-host)
ENV GRADLE_USER_HOME=/workspace/.gradle/

# install scala tools
# run in tools
RUN curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs \
    && chmod +x cs && ./cs setup --yes \
    && export PATH=$HOME/.local/share/coursier/bin:$PATH \
    && cs install bloop scala-cli \
    && fish -c "fish_add_path $HOME/.local/share/coursier/bin" \
    && printf '%s\n'    'cs setup --yes' > $HOME/.config/fish/conf.d/scala.fish
