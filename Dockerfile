FROM ubuntu:24.04

# install dependencies
RUN apt-get -qq update && \
    apt-get -qq -y install \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    wget \
    libdeal.ii-dev \
    vim \
    tree \
    lintian \
    unzip 

# yaml-cpp (shared)
RUN mkdir /software && cd /software && \
    wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.6.3.zip && \
    unzip yaml-cpp-0.6.3.zip && \
    cd yaml-cpp-yaml-cpp-0.6.3 && \
    mkdir build && cd build && \
    cmake -DYAML_BUILD_SHARED_LIBS=ON .. && \
    make -j"$(nproc)" && \
    make install

ENV LIBRARY_PATH=${LIBRARY_PATH}:/usr/local/lib/
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/
ENV PATH=${PATH}:/usr/local/bin/

CMD ["/bin/bash"]

# Copying automation script
COPY docker-build.sh /docker-build.sh
RUN chmod +x /docker-build.sh

# Run packaging automatically
ENTRYPOINT ["/docker-build.sh"]
