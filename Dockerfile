FROM ubuntu:24.04

# Install dependencies (incl. dpkg-dev for shlibdeps)
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
    unzip \
    dpkg-dev && \
    rm -rf /var/lib/apt/lists/*

# Get, unpack, build, and install yaml-cpp (shared)
RUN mkdir /software && cd /software && \
    wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/yaml-cpp-0.6.3.zip && \
    unzip yaml-cpp-0.6.3.zip && \
    cd yaml-cpp-yaml-cpp-0.6.3 && \
    mkdir build && cd build && \
    cmake -DYAML_BUILD_SHARED_LIBS=ON .. && \
    make -j4 && \
    make install

# Make sure /usr/local is visible
ENV LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
ENV PATH=$PATH:/usr/local/bin/

# Script to configure, build (shared), and create packages automatically
RUN cat > /usr/local/bin/build-and-package.sh << 'EOF'
#!/bin/bash
set -euo pipefail

SRC_DIR=/mnt/cpack-exercise
BUILD_DIR=$(mktemp -d /tmp/cpack-build-XXXXXX)
INSTALL_PREFIX=/tmp/cpack-install
OUT_DIR=${CPACK_OUTPUT_DIR:-$SRC_DIR/packages}

echo "Using source directory: $SRC_DIR"
echo "Using build directory:  $BUILD_DIR"
echo "Using install prefix:   $INSTALL_PREFIX"
echo "Using output directory: $OUT_DIR"

mkdir -p "$OUT_DIR"

# Configure: shared library + install prefix
cmake -S "$SRC_DIR" -B "$BUILD_DIR" \
    -DCPACKEXAMPLE_BUILD_SHARED=ON \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX"

# Build
cmake --build "$BUILD_DIR" -- -j"$(nproc)"

# Create packages (TGZ + DEB)
cmake --build "$BUILD_DIR" --target package

# Copy only the final packages to the mounted output directory
cp "$BUILD_DIR"/cpackexample-*.tar.gz "$OUT_DIR"/
cp "$BUILD_DIR"/cpackexample_*.deb "$OUT_DIR"/

# Clean up temporary build and install dirs (container only)
rm -rf "$BUILD_DIR" "$INSTALL_PREFIX"

echo "Packages copied to: $OUT_DIR"
EOF

RUN chmod +x /usr/local/bin/build-and-package.sh

# Default: run the automated build-and-package script
CMD ["/usr/local/bin/build-and-package.sh"]
