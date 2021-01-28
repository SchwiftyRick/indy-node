FROM ubuntu:20.04

ARG uid=1000

RUN apt-get update -y && apt-get install -y \
        apt-transport-https \
        ca-certificates

RUN apt-get update -y && apt-get install -y \
    # common stuff
        git \
        wget \
        unzip \
        python3-pip \
        python3-venv \
        libsodium23 \
        iptables \
        at \
        supervisor \
        python3-nacl \
        rocksdb-tools \
        librocksdb5.17 \
        librocksdb-dev \
        libsnappy-dev \
        liblz4-dev \
        libbz2-dev \
    && rm -rf /var/lib/apt/lists/*

#setuptools v52.0.0 fails, because easy_install was removed https://setuptools.readthedocs.io/en/latest/history.html#v52-0-0

RUN pip3 install -U \ 
	'pip<10.0.0' \
	setuptools==50.3.2 \
	pep8==1.7.1 \
	pep8-naming==0.6.1 \
	flake8==3.5.0 \
    python-rocksdb==0.7 \
    indy_crypto==0.4.5



RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 || \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88
RUN echo "deb https://repo.sovrin.org/deb xenial stable" >> /etc/apt/sources.list
RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list

RUN apt-get update -y && apt-get install -y \
        libssl1.0.0 \
        libindy-crypto=0.4.5
        
       



RUN useradd -ms /bin/bash -u $uid indy

WORKDIR /root

ADD . /root
