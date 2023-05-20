.SILENT:

FFMPEG_PREFIX_PATH="/usr/local/ffmpeg-6.0_gcc-11.3.0_cuda-12.1"

CONFIGURE_FFMPEG = ./configure --enable-nonfree \
--enable-cuda-nvcc \
--enable-libnpp \
--extra-cflags=-I/usr/local/cuda-12.1/include \
--extra-ldflags=-L/usr/local/cuda-12.1/lib64 \
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
	(cd FFmpeg && make -j6 all)
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

