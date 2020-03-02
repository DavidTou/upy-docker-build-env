Firmware builder on Docker container
======================

This repository is intended to create a simple environment to generate builds of custom micropython firmware you specify in the Dockerfile or as `build-args`. However, you can also freely use it providing links to your repo as the arguments.

Usage
------------------

Build the docker image:

```bash
  docker build -t upy-builder .
```

Use `build-args` to provide arguments such as:

```bash
  docker build -t upy-builder --build-arg REPO=<git_repo_url> .
```

Then create a container from the image using:

```bash
  docker create --name upy-builder upy-builder
```

Then copy the the firmware into your filesystem.

```bash
  docker cp upy-builder:/esp/micropython/ports/esp32/build/firmware.bin firmware.bin
```

Deployment
------------------

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
