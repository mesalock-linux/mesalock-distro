# Mesalock Linux

Mesalock Linux is a general purpose Linux distribution which aims to provide a
safe and secure user space environment. All user space applications are written
in memory safe programming languages like Rust and Go, even for init and core
utilities. This extremely reduces attack surfaces of an operating system
exposed in the wild.

## Build Mesalock Linux

Currently, Mesalock Linux is provided in live ISO and rootfs. The live ISO image
can be used to create a bootable live USB, or boot in a Virtual Machine. The
rootfs can be used as the root images of a container.

### Requirements

#### Build in Docker

We provide a `Dockerfile` for building Mesalock Linux with all dependencies
installed. Build the docker images first and then build packages, live ISO, and
rootfs in the container.

```
$ sudo docker build -t mesalock-linux/build-mesalock-linux --rm build-dockerfile
$ sudo docker run -v $(pwd):/mesalock-distro -w /mesalock-distro \
    -it mesalock-linux/build-mesalock-linux /bin/bash
```

#### Build on Ubuntu

Install building dependencies:

```
$ # install packages
$ sudo apt-get update; \
  sudo apt-get install -q -y --no-install-recommends \
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
           software-properties-common; \

$ # install Go
$ sudo add-apt-repository -y ppa:gophers/archive; \
  sudo apt-get update; \
  sudo apt-get install -q -y --no-install-recommends \
           golang-1.9-go

$ # install Rust
$ curl https://sh.rustup.rs -sSf | sh -s -- -y; \
    rustup default nightly

$ # setup PATH
$ export PATH="$HOME/.cargo/bin:/usr/lib/go-1.9/bin:$PATH"
```

### Build packages, live ISO, and rootfs

After installing building dependencies, you can run following commands to build
packages, live ISO, and rootfs.

  - First build all packages: `$ ./x.sh -j$(nproc)`
  - Build the live ISO: `$ ./mesalockiso`
  - Build the container rootfs: `$ ./mesalockrootfs`
  - Build a specific package only: `$ ./mkpkg <package_name>`

## Try Mesalock Linux

Mesalock Linux can be run in real devices (e.g., from a Live USB), virtual
machine, and docker container.

### Virtual machine

You can try Mesalock Linux in Live ISO or docker container. Here are steps to
try Mesalock Linux in VirtualBox.

  1. Open VirtualBox and "New" a VM.
  2. In the VM settings, choose `mesalock-linux.iso` as "Optical Drive".
  3. Start the VM and explore Mesalock Linux.

### Docker container

We provide a simple `Dockerfile` for Mesalock Linux. Here are steps to try
Mesalock Linux in a docker container.

  1. Build the docker image: `sudo docker build --rm -t mesalock-linux/mesalock-linux docker`
  2. Run the image: `sudo docker run --rm -it mesalock-linux/mesalock-linux`

### Demo: web server

The `mesalock-demo` package provides several examples and will be installed
under the `/root/mesalock-demo` directory. For instance, we made several
web server demos written in Rocket, which is a web framework written in Rust.
To try these demos in the VM, please refer to following instructions.

  1. In the VM settings, select "NAT" for network adapter and use port
     forwarding function in the advanced settings to bind host and guest
     machines. Here we add a new rule to bind host IP (127.0.0.1:8080) with
     guest IP (10.0.2.15:8000).
  2. Start Mesalock Linux.
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

## Packages

Mesalock Linux provides following packages. All user space applications are
written in Rust and Go. The number of packages will increase as the time goes
on.

  - `brotli`: compression tool written in Rust
  - `busybox`: busybox tool set for testing only
  - `exa`: replacement for ls written in Rust
  - `fd-find`: simple, fast and user-friendly alternative to find
  - `filesystem`: base filesystem layout
  - `gcc-libs`: GCC library, only libgcc_s.so is used
  - `giproute2`: ip tool written in Go
  - `glibc`: glibc library
  - `init`: init script
  - `ion-shell`: shell written in Rust
  - `linux`: Linux kernel
  - `mesalock-demo`: some demo projects
  - `mgetty`: getty written in Rust
  - `micro`: modern and intuitive terminal-based text editor in written Go
  - `minit`: init written in Rust
  - `ripgrep`: ripgrep combines the usability of The Silver Searcher with the raw
    speed of grep, written in Rust
  - `syslinux`: bootloader
  - `tokei`: count your code, quickly, in Rust
  - `tzdata`: timezone data
  - `uutils-coreutils`: cross-platform Rust rewrite of the GNU coreutils
  - `uutils-findutils`: rust implementation of findutils
  - `xi-core`: a modern editor with a backend written in Rust
  - `xi-tui`: a tui frontend for Xi

## Contributing

Mesalock Linux is very young and at an early stage. Some important components
are still missing. Building a safe and secure Linux distro relies on the whole
community. You are very welcome to contribute to the Mesalock Linux project.

You can get involved in various forms:

  - Improving Mesalock Linux: building process, integration issues, etc.
  - Contributing to core packages of Mesalock Linux: minit, mgetty, etc.
  - Writing system tools with security in mind: tools written in memory safe
    language such as Rust and Go.

## License
TBA
