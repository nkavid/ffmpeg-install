#!/bin/bash

FFMPEG_BRANCH=$(git config --blob main:.gitmodules --get submodule.FFmpeg.branch)
FFMPEG_VERSION=$(echo "${FFMPEG_BRANCH}" | sed "s/release\///g" || exit 1)
echo "FFmpeg version: ${FFMPEG_VERSION}"

CUDA_VERSION="12.1"
CUDA_VERSION_DUMP=$(nvcc --version)
if [[ "${CUDA_VERSION_DUMP}" == *"release ${CUDA_VERSION}"* ]]; then
  echo "CUDA version: ${CUDA_VERSION}"
else
  echo "ERROR::Unexpected CUDA version, not ${CUDA_VERSION}:"
  echo "${CUDA_VERSION_DUMP}"
  exit 1
fi

GCC_VERSION="11.3.0"
GCC_VERSION_DUMP=$(gcc --version)
if [[ "${GCC_VERSION_DUMP}" == *"${GCC_VERSION}"* ]]; then
  echo "GCC version: ${GCC_VERSION}"
else
  echo "ERROR::Unexpected GCC version, not ${GCC_VERSION}:"
  echo "${GCC_VERSION_DUMP}"
  exit 1
fi

PREFIX_PATH="/usr/local/ffmpeg-${FFMPEG_VERSION}_gcc-${GCC_VERSION}_cuda-${CUDA_VERSION}"

cat > Makefile <<EOF
.SILENT:

FFMPEG_PREFIX_PATH="${PREFIX_PATH}"

CONFIGURE_FFMPEG = ./configure --enable-nonfree \\
--enable-cuda-nvcc \\
--enable-libnpp \\
--extra-cflags=-I/usr/local/cuda-${CUDA_VERSION}/include \\
--extra-ldflags=-L/usr/local/cuda-${CUDA_VERSION}/lib64 \\
--disable-static \\
--enable-shared \\
--prefix=\${FFMPEG_PREFIX_PATH}


FINISHED_INFO = echo "-- \033[1mFinished '\$@'\033[0m"

.PHONY: nvidia_headers
nvidia_headers:
	(cd nv-codec-headers && sudo make install)
	\$(FINISHED_INFO)

.PHONY: configure
configure:
	(cd FFmpeg && \$(CONFIGURE_FFMPEG))
	\$(FINISHED_INFO)

.PHONY: build
build:
	(cd FFmpeg && make -j6 all)
	\$(FINISHED_INFO)

.PHONY: install
install:
	(cd FFmpeg && sudo make install)
	\$(FINISHED_INFO)

.PHONY: help
help:
	echo "Configuration:"
	echo "-- FFmpeg prefix path: \${FFMPEG_PREFIX_PATH}"
	echo "Valid targets:"
	echo "-- nvidia_headers     Install nvidia headers"
	echo "-- configure          Configure FFmpeg for installation"
	echo "-- build              Compile configured FFmpeg"
	echo "-- install            Install FFmpeg in prefix path"

EOF
