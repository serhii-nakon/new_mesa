# Target platform - "linux/amd64" for 64 bit, "linux/386" for 32 bit build
# (global ARG, so it must be declared again after FROM to be used below)
ARG PLATFORM=linux/amd64
FROM --platform=${PLATFORM} debian:trixie

# Install needle dependencies
RUN apt update
RUN apt full-upgrade -y
RUN apt -y install apt-utils lsb-release gnupg2 sudo git python3 python3-setuptools python3-mako python3-pip wget \
    mesa-utils vulkan-tools gcc g++ pkg-config ninja-build gettext valgrind bison flex dpkg-dev glslang-tools \
    libc6-dev xutils-dev libvdpau-dev libvulkan-dev libxv-dev libva-dev zlib1g-dev \
    libzstd-dev libexpat1-dev libelf-dev libglvnd-dev libunwind-dev wayland-protocols libwayland-dev \
    libwayland-egl-backend-dev libx11-dev libxext-dev libxfixes-dev libxcb-glx0-dev libxcb-shm0-dev \
    libxcb1-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libxcb-sync-dev \
    libxcb-keysyms1-dev libxshmfence-dev x11proto-dev libxxf86vm-dev libxcb-xfixes0-dev libxcb-randr0-dev \
    libxrandr-dev libxcb-sync-dev libsensors-dev libx11-dev libudev-dev libpciaccess-dev libcairo-dev \
    wayland-protocols libwayland-bin directx-headers-dev

# Create regular user, its uid must match the host user that owns the
# mounted /home/jenkins/out, otherwise result cannot be copied out
ARG HOST_UID=1000
RUN useradd -m -u ${HOST_UID} jenkins
RUN echo 'jenkins ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/nopassword

USER jenkins
WORKDIR /home/jenkins

# Need newer meson than exist in Debian repository
RUN pip3 install --break-system-packages meson pyyaml
ENV PATH /home/jenkins/.local/bin:${PATH}
RUN meson --version

# Bitness and multiarch triplet of the build - "32" and "i386-linux-gnu" for 32 bit
ARG BITS=64
ARG TRIPLET=x86_64-linux-gnu
ENV PREFIX=/opt/mesa${BITS}

# Create dirictory to install binaries
RUN sudo mkdir ${PREFIX}
RUN sudo chmod -Rv o+rw,g+rw ${PREFIX}

# Versions to build (can be overridden - "docker compose build --build-arg MESA_VERSION=26.2.2")
ARG MESA_VERSION=26.2.2
ARG LIBDRM_VERSION=2.4.134

# Clone Mesa and libdrm
RUN git clone --depth=1 --branch=libdrm-${LIBDRM_VERSION} --single-branch https://gitlab.freedesktop.org/mesa/drm.git
RUN git clone --depth=1 --branch=mesa-${MESA_VERSION} --single-branch https://gitlab.freedesktop.org/mesa/mesa.git

# Build and install libdrm
WORKDIR /home/jenkins/drm
RUN meson setup builddir/ \
    --prefix=${PREFIX} \
    --buildtype=release \
    -Db_ndebug=true \
    -Dvalgrind=enabled
RUN ninja -C builddir/
RUN ninja -C builddir/ install

ENV PKG_CONFIG_PATH=${PREFIX}/lib/${TRIPLET}/pkgconfig

# Build and install Mesa
WORKDIR /home/jenkins/mesa
RUN meson setup builddir/ \
    --prefix=${PREFIX} \
    -Dplatforms=x11,wayland \
    -Dgallium-extra-hud=true \
    -Dvulkan-drivers=amd \
    -Dgallium-drivers=radeonsi,zink \
    -Dshader-cache=enabled \
    -Dvulkan-layers=device-select,overlay \
    -Dopengl=true \
    -Dgles1=enabled \
    -Dgles2=enabled \
    -Degl=enabled \
    -Dllvm=disabled \
    -Dlmsensors=enabled \
    -Dtools=glsl,nir \
    -Dgallium-va=enabled \
    -Dglvnd=enabled \
    -Dgbm=enabled \
    -Dlibunwind=enabled \
    -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc,av1dec,av1enc,vp9dec \
    --buildtype=release \
    -Db_ndebug=true \
    -Dvalgrind=enabled
RUN ninja -C builddir/
RUN ninja -C builddir/ install

WORKDIR /home/jenkins

RUN mkdir /home/jenkins/out

# Set proper groups to test inside container
# RUN sudo groupadd -g 106 render
# RUN sudo usermod -a -G sasl root
# RUN sudo usermod -a -G render root
# RUN sudo usermod -a -G render jenkins
# RUN sudo usermod -a -G sasl jenkins

# Copy to host (shell form, exec form does not expand ${PREFIX})
# ENTRYPOINT tail -f /dev/null
ENTRYPOINT cp -vr ${PREFIX} /home/jenkins/out
# ENTRYPOINT ls -al ${PREFIX}/lib
