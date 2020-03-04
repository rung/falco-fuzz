FROM ubuntu:bionic

RUN apt update -y 
RUN apt install -y libssl-dev libyaml-dev libncurses-dev libc-ares-dev libprotobuf-dev protobuf-compiler libjq-dev libyaml-cpp-dev libgrpc++-dev protobuf-compiler-grpc rpm linux-headers-$(uname -r) libelf-dev cmake build-essential libcurl4-openssl-dev
RUN apt install -y git vim unzip wget

RUN git clone https://github.com/google/AFL.git && \
    cd AFL && \
    make && \
    make install

RUN git clone https://github.com/falcosecurity/falco.git
RUN mkdir falco/build && cd falco/build && \
    cmake -DCMAKE_C_COMPILER=afl-gcc -DCMAKE_CXX_COMPILER=afl-g++ .. && \
    make -j4 all && \
    make install

WORKDIR /root

RUN wget https://s3.amazonaws.com/download.draios.com/falco-tests/traces-positive.zip && \
    unzip traces-positive.zip
RUN falco -r /usr/local/etc/falco/falco_rules.yaml -e traces-positive/change-thread-namespace.scap

ADD falco-fuzz.sh .
