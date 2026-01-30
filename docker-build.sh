#!/bin/bash
set -euo pipefail

SRC_DIR=/mnt/cpack-exercise
BUILD_DIR=$(mktemp -d /tmp/cpack-build-XXXXXX)
INSTALL_DIR=$(mktemp -d /tmp/cpack-install-XXXXXX)
OUT_DIR="$SRC_DIR/packages"

echo "Source directory:  $SRC_DIR"
echo "Build directory:   $BUILD_DIR"
echo "Install prefix:    $INSTALL_DIR"
echo "Output directory:  $OUT_DIR"

mkdir -p "$OUT_DIR"

echo "Configuring project..."
cmake -S "$SRC_DIR" -B "$BUILD_DIR" \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"cmake -S "$SRC_DIR" -B "$BUILD_DIR" \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"

echo "Building project..."
cmake --build "$BUILD_DIR" -- -j"$(nproc)"

echo "Packaging..."
cmake --build "$BUILD_DIR" --target package

echo "Copying packages to host..."
cp "$BUILD_DIR"/*.deb "$OUT_DIR"/
cp "$BUILD_DIR"/*.tar.gz "$OUT_DIR"/

echo "Done. Packages are available in:"
ls -lh "$OUT_DIR"
