FROM debian:stretch-slim
MAINTAINER Timo Hanke <timo.t.hanke@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# debian packages
## install
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    git \
    golang \
    libgmp-dev \
    libssl-dev \
    python \
    vim 
## clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# build binaries
## create and switch to build directory
RUN mkdir /build
WORKDIR /build
## build herumi's tools
RUN mkdir herumi 
WORKDIR herumi
RUN git clone git://github.com/herumi/xbyak.git 
RUN git clone git://github.com/herumi/cybozulib.git
RUN git clone git://github.com/herumi/mcl.git
RUN git clone git://github.com/herumi/bls.git
WORKDIR bls
# patch the Makefile to add building of bls_tool.exe 
RUN sed -i -e "s/^\(sample_test.*\)/\1 \$(EXE_DIR)\/bls_tool.exe/" Makefile
RUN make test && make sample_test
ENV PATH=/build/herumi/bls/bin:$PATH
ENV LIBRARY_PATH=/build/herumi/bls/lib:/build/herumi/mcl/lib:$LIBRARY_PATH
ENV CPATH=/build/herumi/bls/include:$CPATH

# install frequent dependencies
## create and switch to src directory
RUN mkdir /src
WORKDIR /src
ENV GOPATH=/

# install gometalinter
RUN go get -u github.com/alecthomas/gometalinter
RUN gometalinter --install

## clone go-ethereum 
RUN mkdir -p github.com/ethereum
WORKDIR github.com/ethereum
RUN git clone git://github.com/ethereum/go-ethereum.git 

# create a go build directory
RUN mkdir /go
ENV GOPATH=/go:${GOPATH}

# switch to work directory
WORKDIR /go
