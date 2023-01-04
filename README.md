# install ffmpeg

> Notes on configuring FFmpeg builds

```bash
# in nv-codec-headers repository
# see PREFIX variable in Makefile
cd nv-codec-headers && sudo make install
```

```bash
# in FFmpeg repository
./configure --enable-nonfree \
--enable-cuda-nvcc \
--enable-libnpp \
--extra-cflags=-I/usr/local/cuda/include \
--extra-ldflags=-L/usr/local/cuda/lib64 \
--disable-static \
--enable-shared \
--prefix=/usr/local/ffmpeg-5.1_gcc-11.3_cuda-12.0
```

```bash
./configure --enable-nonfree \
--enable-libnpp \
--extra-cflags=-I/usr/local/cuda/include \
--extra-ldflags=-L/usr/local/cuda/lib64 \
--cc=clang \
--cxx=clang \
--as=clang \
--nvcc=clang \
--nvccflags=--cuda-gpu-arch=75 \
--disable-static \
--enable-shared \
--prefix=/usr/local/ffmpeg-5.1_llvm-15.0_cuda-12.0
```
