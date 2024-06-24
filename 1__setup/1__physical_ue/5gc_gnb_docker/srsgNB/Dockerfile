ARG OS_VERSION=24.04

##################
# Stage 1: Build #
##################
FROM ubuntu:$OS_VERSION as builder
ENV DEBIAN_FRONTEND=noninteractive

# Build args
################
# OS_VERSION            Ubuntu OS version
# LIB                   uhd or dpdk (lowercase)
# LIB_VERSION           UHD or DPDK version number
# ARCH                  gcc/clang compatible arch
# NUM_CORES             Number or empty for all
# EXTRA_CMAKE_ARGS      Extra flags for srsRAN Project

ARG LIB=uhd
ARG LIB_VERSION=4.6.0.0
ARG ARCH=native
ARG NUM_CORES=$(nproc)
ARG SRSRAN_PROJECT_SHA256=d7ddea6b70d8d8506dda7d6fe0c0509a855f49eb1d231db4b790fcaa9f70bd09
ARG SRSRAN_PROJECT_COMMIT=1483bda3091420cf7270eacdf31de932865c6294

# Adding the complete repo to the context, in /src folder
# ADD . /src
# An alternative could be to download the repo
RUN set -eux \
    && apt-get update -qq \
    && apt-get -qq install -y --no-install-recommends git git-lfs \
    && apt-get -qq --no-install-recommends install -y ca-certificates wget

RUN wget -O srsRAN_Project.tar.gz https://github.com/srsran/srsRAN_Project/archive/refs/tags/release_24_04.tar.gz \
    && sha256sum srsRAN_Project.tar.gz \
    && echo "${SRSRAN_PROJECT_SHA256} srsRAN_Project.tar.gz" | sha256sum --check --status \
    && mkdir /src \
    && tar -xzf srsRAN_Project.tar.gz --strip-components=1 -C /src;

# # Install srsRAN all dependencies
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -qq -y --no-install-recommends \
        cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev \
    && apt-get install -qq -y --no-install-recommends \
        libzmq3-dev libuhd-dev uhd-host libboost-program-options-dev libdpdk-dev libelf-dev libdwarf-dev \
    && apt-get install -qq -y --no-install-recommends \
        libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev


# Build srsRAN Project with default options & # Install
COPY install_scripts/builder.sh /src/scripts
RUN /src/scripts/builder.sh \
    && cd /src/build && make install

################
# Stage 2: Run #
################
FROM ubuntu:$OS_VERSION

# Copy srsRAN binaries and libraries installed in previous stage
COPY --from=builder /usr/local /usr/local

# # Install srsRAN runtime dependencies and uhd dependencies
RUN set -eux \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -qq -y --no-install-recommends \
        libzmq3-dev libuhd-dev uhd-host libboost-program-options-dev libdpdk-dev libelf-dev libdwarf-dev \
    && apt-get install -qq -y --no-install-recommends \
        libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev \
    && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && uhd_images_downloader -t b2xx \ 
    && uhd_images_downloader -t n300    

# # Copy the install dependencies script
# ADD .gitlab/ci/builders/install_dependencies.sh /usr/local/bin

# # Install runtime dependencies and extra libs such as UHD/ZMQ
# RUN /usr/local/bin/install_dependencies.sh run && \
#     /usr/local/bin/install_dependencies.sh extra && \
#     apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

# Uncomment this to download uhd images inside the container 
# instead of sharing them with the host (in the docker-compose.yml)
RUN uhd_images_downloader -t b2xx && \
    uhd_images_downloader -t n300    
