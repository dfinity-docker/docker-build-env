FROM debian:stretch-slim
MAINTAINER Timo Hanke <timo.t.hanke@gmail.com>

# Use defaults.
ENV DEBIAN_FRONTEND noninteractive

# Install Debian packages.
RUN apt-get update
RUN apt-get install -y \
    apt-utils \
    build-essential \
    git \
    golang \
    libgmp-dev \
    libssl-dev \
    python \
    vim
RUN apt-get clean

# Get C/C++ libraries.
WORKDIR /tmp
RUN git clone git://github.com/herumi/bls.git
RUN git clone git://github.com/herumi/cybozulib.git
RUN git clone git://github.com/herumi/mcl.git
RUN git clone git://github.com/herumi/xbyak.git
WORKDIR /tmp/bls
RUN git checkout b68b35d9cb4c307e2ee85651fef59397c7369b70
WORKDIR /tmp/cybozulib
RUN git checkout d8ad6d345c6aac010f9df08f72af5c9e74e27bb6
WORKDIR /tmp/mcl
RUN git checkout 5315d82b431945b563a24d8e22ed6e18a8a3a544
WORKDIR /tmp/xbyak
RUN git checkout a8d4c1fff30542cb45afc03e85cd1f2d451c527e

# Install C/C++ libraries.
WORKDIR /tmp/bls
RUN make test
WORKDIR /tmp
RUN cp bls/lib/*.a mcl/lib/*.a /usr/local/lib
RUN cp bls/include/*.h /usr/local/include

# Set environment variable.
RUN mkdir /go
ENV LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
ENV CPATH=/usr/local/include:$CPATH
ENV GOPATH=/go
ENV PATH=/go/bin:$PATH

# Get Go libraries.
RUN go get -u github.com/alecthomas/gometalinter
RUN go get -u github.com/ethereum/go-ethereum

# Install Go linting tools.
RUN gometalinter --install

# Set working directory.
WORKDIR /go/src
