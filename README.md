# dockerfiles
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![platform: arm32v7](https://img.shields.io/badge/platform-arm32v7-brightgreen)
![os: debian](https://img.shields.io/badge/os-debian-red)

A collection of Dockerfiles for arm32v7 architecture, thinked to be used with raspberry pi 3.

## Images
* [Debian CUPS](docker-debian-cups/)
* [Debian slim CUPS](docker-debian-slim-cups/)
* [Debian CUPS+SANE](docker-debian-cups+sane/)

__Note__: images are based on the debian:latest and refreshed only for new version with relevant changes. Inside all images there is a daily cron job with the full upgrade of all packages.


## Dependencies
* bash
* sudo
* rsyslog
* cron
