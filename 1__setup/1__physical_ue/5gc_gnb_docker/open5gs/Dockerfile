FROM ubuntu:22.04 as base

ENV DEBIAN_FRONTEND=noninteractive

RUN set eux \
    && apt-get update \
    && apt-get install -y software-properties-common\
    && rm -rf /var/lib/apt/lists/*
    
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    ninja-build \
    build-essential \
    flex \
    bison \
    git \
    libsctp-dev \
    libgnutls28-dev \
    libgcrypt-dev \
    libssl-dev \
    libidn11-dev \
    libmongoc-dev \
    libbson-dev \
    libyaml-dev \
    libnghttp2-dev \
    libmicrohttpd-dev \
    libcurl4-gnutls-dev \
    libnghttp2-dev \
    libtins-dev \
    meson \
    curl \
    gettext \
    gdb \
    iproute2 \
    iptables \
    iputils-ping \
    netcat-openbsd \
    iperf \
    iperf3 \
    libtalloc-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

ARG MONGO_MAJOR_VERSION=6
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends wget gnupg \
    && wget -qO - https://www.mongodb.org/static/pgp/server-${MONGO_MAJOR_VERSION}.0.asc | apt-key add \
    && . /etc/os-release \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $UBUNTU_CODENAME/mongodb-org/${MONGO_MAJOR_VERSION}.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-${MONGO_MAJOR_VERSION}.0.list \
    && DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends mongodb-org \
    && apt-get autoremove && apt-get clean

# To set a fixed version of open5gs use
ARG OPEN5GS_VERSION=v2.7.1
# open5gs
RUN git clone --depth 1 --branch ${OPEN5GS_VERSION} https://github.com/open5gs/open5gs open5gs\
    && cd open5gs \
    && meson build --prefix=`pwd`/install \
    && ninja -C build \
    && cd build \
    && ninja install

# webgui
ARG NODE_MAJOR=20
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get install -y nodejs \
    && cd open5gs/webui \
    && npm ci --no-optional

# mongodb python prerequisites
RUN python3 -m pip install pymongo click pyroute2 ipaddress python-iptables

FROM base as open5gs
WORKDIR /open5gs

# COPY open5gs-5gc.yml open5gs-5gc.yml.in

# The wildcard for the subscriber_db.csv tries to copy "subscriber_db.csv" but will not fail if the file doesn't exist
COPY open5gs_entrypoint.sh add_users.py setup_tun.py subscriber_db.cs[v] ./

# configuration copy
COPY open5gs /open5gs/install/etc/open5gs/
COPY launch_nf.sh /open5gs/install/bin/ 

ENV PATH="${PATH}:/open5gs/build/tests/app/"
ENV PATH="${PATH}:/open5gs/install/bin"

ENTRYPOINT [ "./open5gs_entrypoint.sh" ]
# RUN sudo echo; # stop build