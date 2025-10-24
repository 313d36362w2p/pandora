# pandora
Simple multi-architecture tool scripts, using podman, qemu, and chroot where applicable.

## Installation and Dependencies
This tool is a personal setup I use for automating access to architecture building and reversing tools with less fuss.

It relies on podman which has integrated qemu virtualization into it. So, simply install podman and clone this repository to use.

```zsh
sudo pacman -Sy podman
```

This should take care of all of the components you need, hence the reason for the project. No fuss.

Obviously however, this only works if you don't need to emulate a really uncommon architecture (no-iommu riscv for example). You'll be better off just building the kernel yourself and running qemu directly.

## Usage

The environments folder, contains the dockerfiles needed to build any environment you could want for a specific architecture. So, if you want to do some specific kind of work for a long period of time, it is worth it to build your own environment for that specific architecture.

Then to use it, just call the build script specifying the architecture, variant, and environment. This will build a local docker image for that environment and architecture.

```zsh
sudo ./build.sh amd64 none main
```

This is an example, that I use for the vast majority of the work I do.

Then, in order to run the image, just call the pandora script. This will allow you to configure image by image, project folder attachments and permissions just by modifying the pandora script.

```zsh
sudo ./pandora amd64 none main
```


## Notes
Overall this is just a tool to quickly spin up working environments if you're working on a wide variety of architectures at the same time. It's not as extensible or efficient as other solutions, but it is the easiest.

