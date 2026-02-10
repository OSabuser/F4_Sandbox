# Fetch ubuntu image
FROM ubuntu:22.04

LABEL maintainer="von.akimov@gmail.com" \
      version="0.0.1"

# Install prerequisites
RUN \
    apt update && apt-get install -y \
    cmake \
    build-essential \
    ninja-build \
    git \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*


# Загрузка ARM Toolchain
ARG TOOLCHAIN_VERSION=13.3.rel1
ARG HOST_ARCH=aarch64 

RUN wget -qO- "https://developer.arm.com/-/media/Files/downloads/gnu/${TOOLCHAIN_VERSION}/binrel/arm-gnu-toolchain-${TOOLCHAIN_VERSION}-${HOST_ARCH}-arm-none-eabi.tar.xz" \
    | tar -xJ -C /opt && \
    ln -s /opt/arm-gnu-toolchain-${TOOLCHAIN_VERSION}-${HOST_ARCH}-arm-none-eabi /opt/arm-toolchain


ENV PATH="/opt/arm-toolchain/bin:${PATH}"
ENV ARM_TOOLCHAIN_PATH="/opt/arm-toolchain"
ENV PATH="/usr/lib/ccache:$PATH"

WORKDIR /usr/workspace
RUN chmod 777 /usr/workspace