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
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN python -m pip install --upgrade pip
RUN python -m pip install diffusers==0.3.0
RUN python -m pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113
RUN python -m pip install omegaconf==2.2.3
RUN python -m pip install einops
RUN python -m pip install test-tube
RUN python -m pip install transformers
RUN python -m pip install kornia
RUN python -m pip install setuptools==59.5.0
RUN python -m pip install pillow==9.0.1
RUN python -m pip install torchmetrics==0.6.0
RUN python -m pip install pytorch-lightning==1.7.6
RUN python -m pip install git+https://github.com/TencentARC/GFPGAN.git@8d2447a2d918f8eba5a4a01463fd48e45126a379
RUN python -m pip install ftfy regex tqdm
RUN python -m pip install git+https://github.com/openai/CLIP.git@d50d76daa670286dd6cacf3bcd80b5e4823fc8e1

ADD start.sh /
RUN chmod +x /start.sh
CMD [ "/start.sh" ]