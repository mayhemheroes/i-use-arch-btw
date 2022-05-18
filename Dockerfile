FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential

ADD . /repo
WORKDIR /repo
ENV LD_LIBRARY_PATH=/repo/build
RUN ldconfig
RUN make -j8
