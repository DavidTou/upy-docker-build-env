FROM ubuntu:18.04
## ESP-IDF version (3.3)
ARG VERSION_HASH=143d26aa49df524e10fb8e41a71d12e731b9b71d
ARG VERSION_UPY_TAG=v1.12
ARG REPO=https://github.com/DavidTou/micropython

RUN apt-get update \
  && apt-get install -y gcc git curl make libncurses-dev flex bison gperf python3 python3-pip python-setuptools python-serial \
    python-cryptography python-future python-pyparsing python-pyelftools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && useradd --no-create-home esp

RUN mkdir /esp && chown esp:esp /esp
USER esp

## Install crosstool compiler
WORKDIR /esp
RUN curl -O https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz \
  && tar -xzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz \
  && rm xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

## Checkout esp-idf fix permissions. Use release branch instead of commit hash so any fixes get pulled in as well.
RUN cd /esp && git clone https://github.com/espressif/esp-idf.git
RUN cd /esp/esp-idf && git checkout ${VERSION_HASH} && git submodule update --init --recursive

## Checkout MicroPython
#RUN cd /esp && git clone --recursive ${REPO} && cd micropython && git checkout ${VERSION_UPY_TAG}

## Set environmental variables before building, but after code is checked out
ENV ESPIDF=/esp/esp-idf
ENV PATH=/esp/xtensa-esp32-elf/bin:$PATH

USER root
#RUN ln -s /usr/bin/python3.6 /usr/bin/python3
## Set environmental variables needed if flashing from images (only possible when the host system is linux)
#ENV PORT = /dev/ttyUSB0
#ENV FLASH_MODE = qio
#ENV FLASH_SIZE = 4MB
#ENV CROSS_COMPILE = xtensa-esp32-elf-

## Build MicroPython cross-compiler
#RUN cd /esp/micropython && make -C mpy-cross

## Mak sure we have the Berkeley DB external dependency

#RUN cd /esp/micropython && git submodule init lib/berkeley-db-1.xx && git submodule update

#WORKDIR /esp/micropython/ports/esp32
COPY run.sh /run.sh
COPY requirements.txt /requirements.txt
# install python3 modules
RUN pip3 install -r /requirements.txt
#VOLUME ["/esp/micropython/ports/esp32/build", "/esp/micropython/ports/esp32/modules", "/esp/micropython/ports/esp32/scripts"]
RUN chmod +x /run.sh

## Build base clean firmware image by default
#CMD ["make"]
#CMD ["make USER_C_MODULES=/esp/micropython/pmtmodules/ CFLAGS_EXTRA=-DMODULE_EXAMPLE_ENABLED=1 PYTHON=python2"]
## CMD ["sleep","infinity"]