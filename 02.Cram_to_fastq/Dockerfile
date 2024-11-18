FROM ubuntu:24.04

LABEL \
  authors="Maxime HEBRARD <hebrardms@gis.a-star.edu.sg>" \
  description="HTSlib, Samtools, BCFTools image for use in workflows"

# APT-GET #
###########

RUN apt-get update \
  && apt-get install -y \
  bzip2 \
  gcc \
  libbz2-dev \
  libcurl4-openssl-dev \
  liblzma-dev \
  libncurses5-dev \
  make \
  wget \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# HTSlib #
##########

ENV HTSLIB_INSTALL_DIR=/opt/htslib
ENV HTSLIB_VERSION=1.21
  
WORKDIR /tmp
RUN wget https://github.com/samtools/htslib/releases/download/$HTSLIB_VERSION/htslib-$HTSLIB_VERSION.tar.bz2 \
  && tar --bzip2 -xvf htslib-$HTSLIB_VERSION.tar.bz2

WORKDIR /tmp/htslib-$HTSLIB_VERSION
RUN ./configure  --enable-plugins --prefix=$HTSLIB_INSTALL_DIR \
  && make \
  && make install \
  && cp $HTSLIB_INSTALL_DIR/lib/libhts.so* /usr/lib/
  
WORKDIR /
RUN rm -rf /tmp/htslib-$HTSLIB_VERSION
  
# Samtools #
############

ENV SAMTOOLS_INSTALL_DIR=/opt/samtools
ENV SAMTOOLS_VERSION=1.21
  
WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/$SAMTOOLS_VERSION/samtools-$SAMTOOLS_VERSION.tar.bz2 \
  && tar --bzip2 -xf samtools-$SAMTOOLS_VERSION.tar.bz2

WORKDIR /tmp/samtools-$SAMTOOLS_VERSION
RUN ./configure --with-htslib=$HTSLIB_INSTALL_DIR --prefix=$SAMTOOLS_INSTALL_DIR \
  && make \
  && make install

WORKDIR /
RUN rm -rf /tmp/samtools-$SAMTOOLS_VERSION

# Bcftools #
############

ENV BCFTOOLS_INSTALL_DIR=/opt/bcftools
ENV BCFTOOLS_VERSION=1.21
  
WORKDIR /tmp
RUN wget https://github.com/samtools/bcftools/releases/download/$BCFTOOLS_VERSION/bcftools-$BCFTOOLS_VERSION.tar.bz2 \
  && tar --bzip2 -xf bcftools-$BCFTOOLS_VERSION.tar.bz2

WORKDIR /tmp/bcftools-$BCFTOOLS_VERSION
RUN make prefix=$BCFTOOLS_INSTALL_DIR \
  && make prefix=$BCFTOOLS_INSTALL_DIR install

WORKDIR /tmp/bcftools-$BCFTOOLS_VERSION
RUN ./configure --with-htslib=$HTSLIB_INSTALL_DIR --prefix=$BCFTOOLS_INSTALL_DIR \
  && make \
  && make install
  
WORKDIR /
RUN rm -rf /tmp/bcftools-$BCFTOOLS_VERSION
  
# Fix Env #
###########

# add to path
ENV PATH /opt/htslib/bin:/opt/bcftools/bin:/opt/samtools/bin:${PATH}
# RUN echo "${PATH}" >> /etc/bash.bashrc

ENV BCFTOOLS_PLUGINS /opt/bcftools/libexec/bcftools
# RUN echo "${BCFTOOLS_PLUGINS}" >> /etc/bash.bashrc
