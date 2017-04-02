FROM debian:stretch-slim
MAINTAINER Timo Hanke <timo.t.hanke@gmail.com>

# Use defaults.
ENV DEBIAN_FRONTEND noninteractive

# Install Debian packages.
RUN apt-get update && apt-get install -y \
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
RUN git checkout release20170402
WORKDIR /tmp/cybozulib
RUN git checkout release20170401
WORKDIR /tmp/mcl
RUN git checkout release20170402
WORKDIR /tmp/xbyak
RUN git checkout release20170401

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

# Install Go linting tools.
RUN go get -u github.com/alecthomas/gometalinter
RUN gometalinter --install

# Install Go-ethereum.
RUN go get -u github.com/ethereum/go-ethereum

# Set working directory.
WORKDIR /go/src
