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
RUN python -m pip install transformers==4.19.2
RUN python -m pip install setuptools==59.5.0
RUN python -m pip install pillow==9.2.0
RUN python -m pip install torchmetrics==0.6.0
RUN python -m pip install torchdiffeq==0.2.3
RUN python -m pip install pytorch-lightning==1.7.6
RUN python -m pip install git+https://github.com/TencentARC/GFPGAN.git@8d2447a2d918f8eba5a4a01463fd48e45126a379
RUN python -m pip install ftfy regex tqdm
RUN python -m pip install git+https://github.com/openai/CLIP.git@d50d76daa670286dd6cacf3bcd80b5e4823fc8e1
RUN python -m pip install -qq "ipywidgets>=7,<8"
RUN python -m pip install ipywidgets==7.7.1
RUN python -m pip install captionizer==1.0.1
RUN python -m pip install protobuf==3.20.1
RUN python -m pip install timm==0.6.7
RUN python -m pip install fairscale==0.4.9
RUN python -m pip install piexif==1.1.3
RUN python -m pip install einops==0.4.1
RUN python -m pip install jsonmerge==1.8.0
RUN python -m pip install clean-fid==0.1.29
RUN python -m pip install resize-right==0.0.2
RUN python -m pip install torchdiffeq==0.2.3
RUN python -m pip install kornia==0.6.7
RUN python -m pip install lark==1.1.2
RUN python -m pip install inflection==0.5.1
RUN python -m pip install GitPython==3.1.27
RUN python -m pip install torch-fidelity==0.3.0

ADD start.sh /
RUN chmod +x /start.sh
CMD [ "/start.sh" ]