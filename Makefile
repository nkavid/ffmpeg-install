.SILENT:

GCC_VERSION=$(shell gcc --version | grep ^gcc | sed 's/^.* //g')
CUDA_VERSION=$(shell nvcc --version | grep "Cuda compilation tools" | sed 's/^.* V//g')

FFMPEG_PREFIX_PATH="/usr/local/ffmpeg-6.0_gcc-${GCC_VERSION}_cuda-${CUDA_VERSION}"

CONFIGURE_FFMPEG = ./configure --enable-nonfree \
--enable-cuda-nvcc \
--enable-libnpp \
--disable-static \
--enable-shared \
--prefix=${FFMPEG_PREFIX_PATH}


FINISHED_INFO = echo "-- \033[1mFinished '$@'\033[0m"

.PHONY: nvidia_headers
nvidia_headers:
	(cd nv-codec-headers && sudo make install)
	$(FINISHED_INFO)

.PHONY: configure
configure:
	(cd FFmpeg && $(CONFIGURE_FFMPEG))
	$(FINISHED_INFO)

.PHONY: build
build:
	(cd FFmpeg && make -j$(nproc) all)
	$(FINISHED_INFO)

.PHONY: install
install:
	(cd FFmpeg && sudo make install)
	$(FINISHED_INFO)

.PHONY: help
help:
	echo "Configuration:"
	echo "-- FFmpeg prefix path: ${FFMPEG_PREFIX_PATH}"
	echo "Valid targets:"
	echo "-- nvidia_headers     Install nvidia headers"
	echo "-- configure          Configure FFmpeg for installation"
	echo "-- build              Compile configured FFmpeg"
	echo "-- install            Install FFmpeg in prefix path"

