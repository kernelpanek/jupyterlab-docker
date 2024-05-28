ARG BASE_IMAGE_VERSION=3.10.5
FROM python:${BASE_IMAGE_VERSION}

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get upgrade -y && \
  apt-get install -y nodejs \
    texlive-latex-extra \
    texlive-xetex \
    build-essential \
    cmake \
    libboost-all-dev \
    && \
  rm -rf /var/lib/apt/lists/*

# install flatbuffers
RUN mkdir -p /usr/local \
    && cd /usr/local \
    && git clone https://github.com/google/flatbuffers.git \
    && cd flatbuffers \
    && cmake -G "Unix Makefiles" \
    && make \
    && cp -r /usr/local/flatbuffers/include/flatbuffers /usr/local/include \
    && ln -s /usr/local/flatbuffers/flatc /usr/local/bin/flatc \
    && chmod +x /usr/local/flatbuffers/flatc

COPY requirements.txt requirements.txt

RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    rm -rf /root/.cache/pip


RUN rm -rf /usr/local/share/jupyter/lab/extensions/ /usr/local/share/jupyter/labextensions/
RUN jupyter lab clean
RUN jupyter labextension install \
    @jupyter-widgets/jupyterlab-manager@5.0.10 \
    @jupyter-widgets/jupyterlab-sidecar@0.6.1 \
    @finos/perspective-jupyterlab@2.2.1 \
    @jupyterlab/git@0.44.0 \
    @krassowski/jupyterlab-lsp@3.10.2 \
    jupyter-threejs@2.3.0 \
    dask-labextension@5.2.0

COPY bin/entrypoint.sh /usr/local/bin/
COPY config/ /root/.jupyter/

RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 8888
VOLUME /notebooks
WORKDIR /notebooks
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
