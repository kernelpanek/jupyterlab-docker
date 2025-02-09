ARG BASE_IMAGE_VERSION=3.10.5
FROM python:${BASE_IMAGE_VERSION} AS build

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get upgrade -y && \
  apt-get install -y nodejs \
    build-essential \
    cmake \
    libboost-all-dev \
    && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sL -o /tmp/flatc.zip https://github.com/google/flatbuffers/releases/download/v25.1.24/Linux.flatc.binary.g++-13.zip \
    && unzip /tmp/flatc.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/flatc

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /root/.cache/pip

RUN rm -rf /usr/local/share/jupyter/lab/extensions/ /usr/local/share/jupyter/labextensions/
RUN jupyter lab clean
RUN jupyter labextension install \
    @jupyter-widgets/jupyterlab-manager@5.0.10 \
    @jupyter-widgets/jupyterlab-sidecar@0.6.1 \
    @finos/perspective-jupyterlab@2.2.1 \
    @jupyterlab/git@0.44.0 \
    @krassowski/jupyterlab-lsp@3.10.2 \
    jupyter-threejs@2.3.0

FROM python:${BASE_IMAGE_VERSION}-slim

COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY --from=build /usr/local/lib/python3.10/site-packages/ /usr/local/lib/python3.10/site-packages/
COPY --from=build /usr/local/share/jupyter/ /usr/local/share/jupyter/

COPY bin/entrypoint.sh /usr/local/bin/
COPY config/ /root/.jupyter/

RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 8888
VOLUME /notebooks
WORKDIR /notebooks
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
