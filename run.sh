## GET LATEST VERSION OF SPECIFIED Micropython Repository and version
# REPO=https://github.com/DavidTou/micropython
# VERSION_UPY_TAG=v1.12
cd /esp && git clone --recursive ${REPO} && cd micropython && git checkout ${VERSION_UPY_TAG}

## Build MicroPython cross-compiler
cd /esp/micropython && make -C mpy-cross

## Mak sure we have the Berkeley DB external dependency
cd /esp/micropython && git submodule init lib/berkeley-db-1.xx && git submodule update

cd ports/esp32 && make
# move firmare build to /
cp build-GENERIC/firmware.bin /firmware.bin