# Alpime
Alpine is a small image, however, due to imcompatibility with vscode gitpod doesn't support it

Current main difference with ubuntu is alpine uses adduser
```
RUN addgroup -g 33333 -S gitpod && adduser --disabled-password --uid 33333 --ingroup gitpod --home /home/gitpod --shell /bin/bash gitpod \
    && echo 'gitpod:gitpod' | chpasswd
```