# docker-debian-cups
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![platform: arm32v7](https://img.shields.io/badge/platform-arm32v7-brightgreen)
![os: debian](https://img.shields.io/badge/os-debian-red)

# Overview
Docker image based on Debian Latest including CUPS print server and printing drivers (installed from the Debian packages).
The image manages also usb printers exposing three volumes.
It is present an automated daily job to update all packages in the system.

## Builds image by yourself
To build by yourself the image, with Docker installed, you can use the following command, changing the tag name of the image (-t username/image-name:version).
```bash
docker build -t fulvio1982/debian-cups --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .
```

# Run the CUPS server
To run the container you can use the follwing command:
```bash
docker run -d --restart always -p 631:631 --privileged -v /var/run/dbus:/var/run/dbus -v /dev/bus/usb:/dev/bus/usb -v /etc/cups:/etc/cups -p 631:631 -e ADMIN_PASSWORD=mySecretPassword
```
