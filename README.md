# Overview

This Dockerfile provides an environment for [Xilinx PetaLinux](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842250/PetaLinux) 2019.2 development.

# Getting started

## Install Docker

To install Docker on Ubuntu:

``` shell
# Install prerequisites
$ sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Install Docker
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt update
$ sudo apt install -y docker-ce

# Add ourselves to the docker group so we can run docker without sudo
$ sudo usermod -a -G docker "$(whoami)"

# Log out and log in, or restart the machine for the membership change to take effect
```

## Download PetaLinux installer

Download the [PetaLinux 2019.2 installer](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/2019-2.html) from Xilinx (Xilinx account required).

## Build Docker image

Clone this repository, e.g. `git clone https://github.com/hbk-world/petalinux-2019-2-docker`.

Move the PetaLinux installer to the repository folder alongside the Dockerfile. The installer should be named `petalinux-v2019.2-final-installer.run`.

Run `./build` to build the image.

# Running PetaLinux

Run the Docker image:

``` shell
$ ./run
```

The run script passes the -v option to mount the home folder on the host to the home folder inside the container.

With the container running, you can work in your home folder - clone repositories, edit code etc. - using all the tools available on the host.

When you need to build code, switch to the container to run the PetaLinux tools.

To exit the container, press Ctrl+D.
