<p align="center"><img src="img/logo.png" height="86" /></p>

# MesaLock Linux: A Memory-Safe Linux Distribution

[![GitHub Release](https://img.shields.io/github/release/mesalock-linux/mesalock-distro.svg)](https://github.com/mesalock-linux/mesalock-distro/releases)
[![Build Status](https://ci.mesalock-linux.org/api/badges/mesalock-linux/mesalock-distro/status.svg?branch=master)](https://ci.mesalock-linux.org/mesalock-linux/mesalock-distro)
[![Chat on Matrix](https://img.shields.io/badge/style-matrix-blue.svg?style=flat&label=chat)](https://riot.im/app/#/room/#mesalock-linux:matrix.org)
[![IRC: #rocket on chat.freenode.net](https://img.shields.io/badge/style-%23mesalock--linux-blue.svg?style=flat&label=freenode)](https://kiwiirc.com/client/chat.freenode.net/#mesalock-linux)

MesaLock Linux is a general purpose Linux distribution which aims to provide a
*safe* and *secure* user space environment. To eliminate high-severe
vulnerabilities caused by memory corruption, the whole user space applications
are rewritten in *memory-safe* programming languages like Rust and Go.  This
extremely reduces attack surfaces of an operating system exposed in the wild,
leaving the remaining attack surfaces auditable and restricted. Therefore,
MesaLock Linux can substantially improve the security of the Linux ecosystem.
Additionally, thanks to the Linux kernel, MesaLock Linux supports a broad
hardware environment, making it deployable in many places.  Two main usage
scenarios of MesaLock Linux are for containers and security-sensitive embedded
devices. With the growth of the ecosystem, MesaLock Linux would also be adopted
in the server environment in the future.

To get better functionality along with strong security guarantees, MesaLock
Linux follows the following rules-of-thumb for hybrid memory-safe architecture
designing proposed by the [Rust SGX SDK](https://github.com/baidu/rust-sgx-sdk)
project.

1. Unsafe components must not taint safe components, especially for public APIs
   and data structures.
2. Unsafe components should be as small as possible and decoupled from safe
   components.
3. Unsafe components should be explicitly marked during deployment and ready to
   upgrade.


## Quick Start

You can quickly experience MesaLock Linux in the container environment using
Docker.

```sh
$ docker run -it mesalocklinux/mesalock-linux
```

## Building

Currently, MesaLock Linux is provided in two versions: live ISO and rootfs. The
live ISO image can be used to create a bootable live USB, or boot in a virtual
machine. The rootfs (i.e., root file system) can be used as a minimal root
image for a container.

### Requirements

#### Clone MesaLock repository

Clone `mesalock-distro` and `pacakges` repositories.

```sh
$ mkdir mesalock-linux && cd mesalock-linux
$ git clone https://github.com/mesalock-linux/mesalock-distro.git
$ git clone https://github.com/mesalock-linux/packages.git
$ cd mesalock-distro
```

#### Build in Docker

We provide a `Dockerfile` for building MesaLock Linux with all dependencies
installed. You can build the docker image first and then in the building
container environment, you can build packages, live ISO, and rootfs.

```sh
$ docker build --rm -t mesalocklinux/build-mesalock-linux -f Dockerfile.build .
$ docker run -v $(dirname $(pwd)):/mesalock-linux -w /mesalock-linux/mesalock-distro \
    -it mesalocklinux/build-mesalock-linux /bin/bash
```

The image of building environment are also provided from [Docker
Hub](https://hub.docker.com/r/mesalocklinux/build-mesalock-linux/). You can
pull and run the container with the repo name `mesalocklinux/build-mesalock-linux`.

#### Build on Ubuntu

You can also build a Ubuntu machine, please install these building dependencies
first:

```sh
$ # install packages
$ apt-get update && \
  apt-get install -q -y --no-install-recommends \
           curl \
           git \
           build-essential \
           wget \
           bc \
           gawk \
           parallel \
           pigz \
           cpio \
           xorriso \
           fakeroot \
           syslinux-utils \
           uuid-dev \
           libmpc-dev \
           libisl-dev \
           libz-dev \
	   python-pip \
	   python-setuptools \
           software-properties-common

$ # install sphinx
$ pip install wheel
$ pip install sphinx

$ # install Go
$ add-apt-repository -y ppa:gophers/archive && \
  apt-get update && \
  apt-get install -q -y --no-install-recommends \
           golang-1.9-go

$ # install Rust
$ curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    rustup override set nightly-2018-01-14

$ # setup PATH
$ export PATH="$HOME/.cargo/bin:/usr/lib/go-1.9/bin:$PATH"
```

### Build packages, live ISO, and rootfs

After installing building dependencies, you can run following commands to build
packages, live ISO, and rootfs.

  - First build all packages: `./mkpkg`
  - Build the live ISO: `./mesalockiso`
  - Build the container rootfs: `./mesalockrootfs`
  - Build a specific package only: `./mkpkg <package_name>`

The live ISO (`mesalock-linux.iso`) and rootfs (`rootfs.tar.xz`) can be found
in the `build` directory.

## Trying

MesaLock Linux can be run in real devices (e.g., boot from a Live USB), virtual
machines, and docker containers.

### Virtual machine

You can try MesaLock Linux with Live ISO or in a docker container. Here are
steps to try MesaLock Linux in VirtualBox.

  1. Open VirtualBox and "New" a VM.
  2. In the VM settings, choose `mesalock-linux.iso` as "Optical Drive".
  3. Start the VM and explore MesaLock Linux.

### Docker container

We provide a simple `Dockerfile` for MesaLock Linux. Here are steps to try
MesaLock Linux in a docker container.

  1. Build packages and rootfs: `./mkpkg && ./mesalockrootfs`
  2. Build the docker image: `docker build --rm -t mesalocklinux/mesalock-linux .`
  3. Run the image and expeience MesaLock Linux: `docker run --rm -it mesalocklinux/mesalock-linux`

The latest rootfs image with all pacakges are pushed to [Docker
Hub](https://hub.docker.com/r/mesalocklinux/mesalock-linux/). You can also
directly run the image with the repo name `mesalocklinux/mesalock-linux`.

### Demos

#### Hosting web servers

The `mesalock-demo` package provides several examples and will be installed
under the `/root/mesalock-demo` directory. For instance, we made several web
server demos written in [Rocket](https://github.com/SergioBenitez/Rocket/),
which is a web framework written in Rust.  To try these demos in the VM, please
follow these instructions.

  1. In the VM settings, select "NAT" for network adapter and use port
     forwarding function in the advanced settings to bind host and guest
     machines. Here we add a new rule to bind host IP (127.0.0.1:8080) with
     guest IP (10.0.2.15:8000).
  2. Start MesaLock Linux.
  3. Bring up all network devices. Here we use `ip` command:

    ```
    $ ip link set lo up
    $ ip link set eth0 up
    ```

  4. Setup IP address of the network devices.

    ```
    $ ip address add 10.0.2.15/24 dev eth0
    ```

  5. Run a web server.

    ```
    $ cd /root/mesalock-demo/rocket-hello-world && ./hello_world
    $ # or
    $ cd /root/mesalock-demo/rocket-tls && ./tls
    ```

  6. Finally, connect to the web server using a browser. In this example, type
     in http://127.0.0.1:8080 in the browser.

You can also try our demos in the docker image directly.

  1. Run the MesaLock docker and export port 8000 to 8000: `docker run -it -p 8000:8000 mesalocklinux/mesalock-linux`
  2. Run a web server in the `/root/mesalock-demo/` directory.
  3. Visit the website in the browser.

#### Working on machine learning tasks

[Rusty-machine](https://github.com/AtheMathmo/rusty-machine) is a general
purpose machine learning library implemented entirely in Rust. We put several
demo examples of machine learning tasks in the `mesalock-demo` package. You can
find them in the `/root/mesalock-demo/rusty-machine/` directory.

## Packages

MesaLock Linux provides many packages with memory safety in mind. All user
space applications are written in Rust and Go. Thanks to the open source
community, they have crated many useful and high-quality tools. The number of
packages will increase as the time goes on.

  - `brotli`: compression tool written in Rust ([dropbox/rust-brotli](https://github.com/dropbox/rust-brotli))
  - `busybox`: busybox tool set for testing only ([busybox](https://busybox.net))
  - `exa`: replacement for ls written in Rust ([ogham/exa](https://the.exa.website))
  - `fd-find`: simple, fast and user-friendly alternative to find ([sharkdp/fd](https://github.com/sharkdp/fd))
  - `filesystem`: base filesystem layout (maintained by MesaLock Linux)
  - `gcc-libs`: GCC library, only libgcc_s.so is used ([gcc](https://gcc.gnu.org/))
  - `giproute2`: ip tool written in Go (maintained by MesaLock Linux)
  - `glibc`: the GNU C library ([glibc](https://www.gnu.org/software/libc/))
  - `init`: init script (maintained by MesaLock Linux)
  - `ion-shell`: shell written in Rust ([redox-os/ion](https://github.com/redox-os/ion))
  - `linux`: Linux kernel ([linux](https://www.kernel.org/))
  - `mesalock-demo`: some demo projects (maintained by MesaLock Linux)
  - `mgetty`: getty written in Rust (maintained by MesaLock Linux)
  - `micro`: modern and intuitive terminal-based text editor in written Go ([zyedidia/micro](https://github.com/zyedidia/micro))
  - `minit`: init written in Rust (maintained by MesaLock Linux)
  - `ripgrep`: ripgrep combines the usability of The Silver Searcher with the raw
    speed of grep, written in Rust ([BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep))
  - `syslinux`: bootloader ([syslinux](http://www.syslinux.org/wiki/index.php?title=The_Syslinux_Project))
  - `tokei`: count your code, quickly, in Rust ([Aaronepower/tokei](https://github.com/Aaronepower/tokei))
  - `tzdata`: timezone data ([tzdata](https://www.iana.org/time-zones))
  - `uutils-coreutils`: cross-platform Rust rewrite of the GNU coreutils ([uutils/coreutils](https://github.com/uutils/coreutils))
  - `uutils-findutils`: rust implementation of findutils ([uutils/findutils](https://github.com/uutils/findutils))
  - `xi-core`: a modern editor with a backend written in Rust ([google/xi-editor](https://github.com/google/xi-editor))
  - `xi-tui`: a tui frontend for Xi ([little-dude/xi-tui](https://github.com/little-dude/xi-tui))

## Contributing

MesaLock Linux is very young and at an early stage. Some important components
are still missing or work-in-progress. Building a safe and secure Linux distro
relies on the whole community, and you are very welcome to contribute to the
MesaLock Linux project.

You can get involved in various forms:

  - Try to use MesaLock Linux, report issue, enhancement suggestions, etc
  - Contribute to MesaLock Linux: optimize development process, improve
    documents, closing issues, etc
  - Contribute to core packages of MesaLock Linux: improving `minit`, `mgetty`,
    `giproute2`, etc
  - Writing applications using memory safe programming languages like Rust/Go,
    and joining the the MesaLock Linux packages
  - Auditing source code of the MesaLock Linux projects and related packages

You are welcome to send pull requests and report issues on GitHub. Note that
the MesaLock Linux project follows the [Git
flow](http://nvie.com/posts/a-successful-git-branching-model/) development
model.

## Community

If you are interested in the MesaLock Linux project, please find us on the
`#mesalock-linux` or `#mesalock-linux-cn` (in Chinese) IRC channels at the [freenode
server](irc://chat.freenode.net)
and the bridged room on Matrix. If you're not familiar with IRC, we recommend
chatting through [Matrix via
Riot](https://riot.im/app/#/room/#mesalock-linux:matrix.org) or via the [Kiwi
web IRC client](https://kiwiirc.com/client/irc.mozilla.org/#mesalock-linux).

List of our IRC channels:
  - [#mesalock-linux](https://riot.im/app/#/room/#mesalock-linux:matrix.org): general discussion on MesaLock Linux
  - [#mesalock-linux-cn](https://riot.im/app/#/room/#mesalock-linux-cn:matrix.org): discussion in Chinese
  - [#medalock-linux-devel](https://riot.im/app/#/room/#mesalock-linux-devel:matrix.org): discussion on design and development

## Maintainer

  - Mingshen Sun `<mssun@mesalock-linux.org>` [@mssun](https://github.com/mssun)

## License

MesaLock Linux is provided under the [BSD license](LICENSE).
