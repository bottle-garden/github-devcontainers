#!/bin/sh -e

# TODO: Turn this into a makefile so I can see what's happening during the
# build.
#
# More importantly, I can define targets for individual tags. The targets can
# then specify what they want installed. If I set the dependency chains up
# properly, this will mean an efficient way of building exactly what is needed
# for each specific tag without the need for code duplication or a complex web
# of multiple install scripts.

apk update

# Most of this is needed for building Python packages
apk add --no-cache \
    coreutils \
    gcc \
    libc-dev \
    libxml2 \
    libxml2-dev \
    libxslt \
    libxslt-dev \
    libffi-dev \
    libtool \
    bzip2-dev \
    readline-dev \
    openssl-dev \
    sqlite-dev \
    autoconf \
    automake \
    make

apk add --no-cache python3-dev

PYENV_ROOT=/usr/local/pyenv
export PYENV_ROOT
curl https://pyenv.run | bash
echo 'PATH="/usr/local/pyenv/bin/:${PATH}"' > /etc/profile.d/pyenv.sh
echo 'eval "$(pyenv init --path)"' >> /etc/profile.d/pyenv.sh
. /etc/profile.d/pyenv.sh

# Reserved for Python specific images
# pyenv install 3.7.12
# pyenv install 3.8.12
pyenv install 3.9.9
pyenv global 3.9.9

pip install --upgrade pip
pip install pipx

PIPX_HOME=/usr/local/pipx
export PIPX_HOME
PIPX_BIN_DIR=/usr/local/bin
export PIPX_BIN_DIR
pipx install yamllint
pipx install proselint
pipx install snooty
pipx install prospector[with_everything]
pipx install reorder_python_imports
pipx install poetry

apk add --no-cache npm
npm install --global npm@latest
npm install --global --prefer-dedupe \
    editorconfig \
    cspell \
    prettier \
    dockerfilelint \
    markdownlint-cli \
    markdown-link-check \
    stylelint \
    stylelint-config-standard \
    pandoc \
    jscpd \
    snyk

# TODO: Can't seem to get remark-lint to work when I install it

# https://github.com/drewbourne/vscode-remark-lint
# https://github.com/remarkjs/remark-validate-links

# remark-cli \
# remark-lint \
# remark-preset-lint-markdown-style-guide \
# remark-stringify \

apk add --no-cache go
mkdir /usr/local/go
go get -u github.com/get-woke/woke
go get -u github.com/client9/misspell/cmd/misspell
go get -u github.com/pksunkara/whitespaces

apk add --no-cache \
    cargo
cargo install --root=/usr/local shellharden

apk add --no-cache \
    ruby \
    tidyhtml \
    github-cli \
    shellcheck \
    shfmt \
    bash-completion