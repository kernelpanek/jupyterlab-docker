FROM python:3

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get upgrade -y && \
  apt-get install -y nodejs \
    texlive-latex-extra \
    texlive-xetex \
    build-essential \
    cmake \
    && \
  rm -rf /var/lib/apt/lists/*

# install boost
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.71.0/source/boost_1_71_0.tar.gz --no-check-certificate >/dev/null 2>&1
RUN tar xfz boost_1_71_0.tar.gz
RUN cd boost_1_71_0 && ./bootstrap.sh
RUN cd boost_1_71_0 && ./b2 -j8 --with-program_options --with-filesystem --with-system install

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
  pip install -r requirements.txt


RUN rm -rf /usr/local/share/jupyter/lab/extensions/ /usr/local/share/jupyter/labextensions/
RUN jupyter lab clean
RUN jupyter labextension install \
    @jupyter-widgets/jupyterlab-manager \
    @jupyter-widgets/jupyterlab-sidecar \
    @finos/perspective-jupyterlab \
    @jupyterlab/git \
    @ryantam626/jupyterlab_code_formatter@1.4.10 \
    @krassowski/jupyterlab-lsp \
    jupyterlab-datawidgets \
    jupyterlab-scales \
    jupyter-threejs

COPY bin/entrypoint.sh /usr/local/bin/
COPY config/ /root/.jupyter/

RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 8888
VOLUME /notebooks
WORKDIR /notebooks
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
