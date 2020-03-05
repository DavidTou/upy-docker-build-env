Firmware builder on Docker container
======================

This repository is intended to create a simple environment to generate builds of custom micropython firmware you specify in the Dockerfile or as `build-args`.

Usage
------------------

Build the docker image:

```bash
  docker build -t upy-build-image .
```

Use `build-args` to provide arguments such as:

```bash
  docker build -t upy-build-image --build-arg REPO=<git_repo_url> .
```

Then create a container from the image using:

```bash
   docker create --name upy upy-build-image
```

Then copy the the firmware into your filesystem.

```bash
  docker cp upy:/esp/micropython/ports/esp32/build/firmware.bin firmware.bin
```
or simply mount the volume you want to access through Docker Desktop App's Kitematic.

Remove unused data (images etc. )

```bash
  docker system prune
Deployment
```

Clear your ESP:

```bash
  esptool.py --chip esp32 --port /dev/tty.SLAB_USBtoUART erase_flash
```

Install firmware into the ESP:

```bash
  esptool.py --chip esp32 --port /dev/tty.SLAB_USBtoUART --baud 460800 write_flash -z 0x1000 firmware.bin
```

Configurations
------------------

Provided arguments are following:

`REPO` - Link to your fork of micropython.

`VERSION_HASH` - Hash of supported ESP-IDF version.

Build docker image
```bash
  docker build -t bubba .
```

Run image with specified environment variables
```bash
  docker run -ti --name bubba -e VERSION_UPY=v1.12 -e REPO=https://github.com/DavidTou/micropython bubba bash
```

When shell prompt:
```bash
  /run.sh
  exit
```
Restart container
```bash
  docker restart bubba
```

Attach local standard input, output, and error streams to a running container (see if running)
```bash
  docker attach bubba
```
Remove container (-f, force if running)
```bash
  docker rm -f bubba
```
