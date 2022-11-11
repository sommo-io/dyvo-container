FROM ubuntu:latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND noninteractive\
    SHELL=/bin/bash

RUN apt-get update --yes && \
    # - apt-get upgrade is run to patch known vulnerabilities in apt-get packages as
    #   the ubuntu base image is rebuilt too seldom sometimes (less than once a month)
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends\
    git\
    wget\
    bash\
    fonts-dejavu-core\
    python3\
    pip\
    curl\
    gnupg2\
    ffmpeg\
    libsm6\
    libxext6\
    python-is-python3\
    openssh-server &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# #Set of all dependencies needed for pyenv to work on Ubuntu
# RUN apt-get update \ 
#         && apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget ca-certificates curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev mecab-ipadic-utf8 git

# # Set-up necessary Env vars for PyEnv
# ENV PYENV_ROOT /root/.pyenv
# ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# # Install pyenv
# RUN set -ex \
#     && curl https://pyenv.run | bash \
#     && pyenv update \
#     && pyenv install 3.8.10 \
#     && pyenv install 3.10.6 \
#     && pyenv global $PYTHON_VERSION \
#     && pyenv rehash

RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

RUN apt-get update \
    && apt-get install -y wget \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# install miniconda
ENV PATH="/root/miniconda3/bin:$PATH"
RUN mkdir /root/.conda && bash Miniconda3-latest-Linux-x86_64.sh -b
# create conda environment
ADD env-automatic.yaml /
ADD env-ldm.yaml /
RUN conda init bash
RUN . ~/.bashrc
RUN conda install anaconda-client -n base
RUN conda env create --file ./env-ldm.yaml
RUN conda env create --file ./env-automatic.yaml
RUN conda init bash

ADD start.sh /
RUN chmod +x /start.sh
CMD [ "/start.sh" ]