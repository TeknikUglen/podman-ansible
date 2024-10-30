# Ansible in a Container

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/isc)
[![Podman](https://img.shields.io/badge/Podman-grey?logo=podman&logoColor=ffffff)](https://github.com/containers/podman)
[![Ansible](https://img.shields.io/badge/Automation-Ansible-green)](https://ansible.com)

This repository holds the means to build containers for automation using ansible. 

I wanted to compare the container image sizes, so I made container files for different operating systems. All of them will have a 2-stage build.

The build command is based on podman, however it should work fine for docker as well.

> [!WARNING]
> The included container build files also adds a SSH config file to the ansible users home which disables host key check as well as discards the host key.  
> This is a no go in a corporate environment, but I am only using it in a secured LAN nobody else has access to. And it makes it easier to run when the server is re-installed.

## Scripts

Scripts are supplied for building and test-starting the container. It is meant as a guide to implement the container into your workflow.

- build_image.sh - build the container image. (defaults to alpine)
- start-container.sh - example of running the image.
- resources/container-entrypoint.sh - will setup the Python virtual environment before running the arguments from the `podman run` command.

## Build commands

```sh
podman build -t teknikuglen/ansible:opensuse -f Containerfile.opensuse .
podman build -t teknikuglen/ansible:debian -f Containerfile.debian .
podman build -t teknikuglen/ansible:alpine -f Containerfile.alpine .
podman build -t teknikuglen/ansible:python -f Containerfile.python .
```

## Image size

These are the sizes I ended up with.

| base                   | base image size | build image size|
|------------------------|----------------:|----------------:|
| Opensuse Tumbleweed    |       100.00 MB |          709 MB |
| Debian Bullseye (slim) |        84.20 MB |          586 MB |
| Alpine                 |         7.65 MB |          508 MB |
| Python 3.10 (slim)     |       132.00 MB |          613 MB |

## Run container

This is just a short example how the container can be used.

```sh
podman run --rm -v "$PWD/workdir:/home/ansible/workdir" localhost/teknikuglen/ansible:alpine ansible-workbook -i inventory main.yml --ask-become-pass
```

## Open command prompt inside container

```sh
podman run --rm -it -v "$PWD/workdir:/home/ansible/workdir" localhost/teknikuglen/ansible:alpine bash
```

## Permission problem

The image created here works perfectly fine with **docker**, but with **podman** we're running into a problem due to the way permissions are handled.

When the volume is mounted into the container it will be mounted with "internal" root permissions, which means our ansible user will not have access to write files.  
If you only need to read files it's not really a problem though. Otherwise either make sure the permissions are set correctly or use a root container. The containerfile for this is also included and named `Containerfile.alpinex`

## Notes

The size on the build image doesn't change that much regardless of the distro used as the base. This is due to Python and Ansible being rather on the large side by themselves.

The related blog post can be found [here](https://teknikuglen.com/posts/ansible-container)