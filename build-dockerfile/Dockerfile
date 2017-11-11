FROM ubuntu:16.04
MAINTAINER Mingshen Sun <sunmingshen@baidu.com>

ENV PATH="/root/.cargo/bin:/usr/lib/go-1.9/bin:${PATH}"

RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
        curl \
        git \
        build-essential \
        wget \
        bc \
        gawk \
        parallel \
        pigz \
        cpio \
        xorriso \
        fakeroot \
        syslinux-utils \
        uuid-dev \
        libmpc-dev \
        libisl-dev \
        libz-dev \
        software-properties-common && \
    add-apt-repository -y ppa:gophers/archive && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends \
        golang-1.9-go

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    rustup default nightly
