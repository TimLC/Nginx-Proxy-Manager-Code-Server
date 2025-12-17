FROM codercom/code-server:latest

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PYTHON_VERSION=3.12.12

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential wget curl libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev \
    libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev \
    liblzma-dev tk-dev libffi-dev ca-certificates xz-utils \
 && rm -rf /var/lib/apt/lists/*

RUN cd /usr/src \
 && wget -q "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz" \
 && tar xzf Python-${PYTHON_VERSION}.tgz \
 && cd Python-${PYTHON_VERSION} \
 && ./configure --enable-optimizations --with-ensurepip=install \
 && make -j"$(nproc)" \
 && make altinstall \
 && cd / && rm -rf /usr/src/Python-${PYTHON_VERSION} /usr/src/Python-${PYTHON_VERSION}.tgz

# créer liens pour coder
RUN mkdir -p /home/coder/.local/bin \
 && ln -sf /usr/local/bin/python${PYTHON_VERSION%.*} /home/coder/.local/bin/python \
 && ln -sf /usr/local/bin/python${PYTHON_VERSION%.*} /home/coder/.local/bin/python3 \
 && ln -sf /usr/local/bin/pip${PYTHON_VERSION%.*} /home/coder/.local/bin/pip \
 && chown -R coder:coder /home/coder

USER coder
ENV PATH=/home/coder/.local/bin:$PATH

RUN mkdir -p /home/coder/.local/share/code-server/extensions \
  && code-server --install-extension ms-python.python --force


USER coder
ARG NVM_VERSION=0.40.3
ARG NODE_VERSION=24
ENV NVM_DIR=/home/coder/.nvm

RUN mkdir -p $NVM_DIR \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && echo 'export NVM_DIR="$HOME/.nvm"' >> /home/coder/.bashrc \
  && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/coder/.bashrc \