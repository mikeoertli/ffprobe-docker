# ffprobe-docker

![build image and push to docker hub workflow](https://github.com/mikeoertli/ffprobe-docker/actions/workflows/publish-image-to-docker-hub.yml/badge.svg)

## Overview

Simple lightweight container to run `ffprobe`.

This uses Alpine `v3.15.1` and `ffprobe v4.4.1`.

Note: I haven't explored [`buildx`](https://docs.docker.com/desktop/multi-arch/) yet as a multi-arch solution.

## Docker Hub

This project is now on Docker Hub under the same name ([mikeoertli/ffprobe-docker](https://hub.docker.com/r/mikeoertli/ffprobe-docker))! Instead of needing to clone this repo and build, you can just pull down the pre-built images and run with those.

The `docker pull` command is:

```bash
docker pull mikeoertli/ffprobe-docker
```

## What is FFprobe?

![FFmpeg logo](https://trac.ffmpeg.org/ffmpeg-logo.png)

`ffprobe` [is a part](https://ffmpeg.org/ffprobe.html) of the [FFmpeg](https://ffmpeg.org) library.

## Usage

### Build

The `ffprobe` version number is kept in `ffprobe-version.txt` so this build command doesn't need to change.

However, the `Dockerfile` is currently manually kept in sync with the `txt` file.

Building ARM:

```bash
docker build --platform linux/arm64 -t mikeoertli/ffprobe-docker:"$(cat ffprobe-version.txt)-arm64" -t mikeoertli/ffprobe-docker:latest .
```

Building AMD:

```bash
docker build --platform linux/amd64 -t mikeoertli/ffprobe-docker:"$(cat ffprobe-version.txt)-amd64" -t mikeoertli/ffprobe-docker:latest -f Dockerfile.amd64 .
```

### Publishing to Docker Hub

These images are published to [Docker Hub under `mikeoertli/ffprobe-docker`](https://hub.docker.com/r/mikeoertli/ffprobe-docker/tags).

Right now, GitHub actions [only support](https://www.mess.org/2022/01/17/Creating-a-linux-arm64-github-actions-runner/) `amd64` architecture, so for now, those are the only images that are build and published automatically.

#### Publishing ARM64 Images (Manual)

Images for `arm64` architecture must be pushed manually, the command to do that is:

```bash
docker push mikeoertli/ffprobe-docker:"$(cat ffprobe-version.txt)"-arm64
```

#### Publishing AMD64 Images

Images for `amd64` architecture are pushed when tagging the repo with a tag matching the format of `v*.*-*`.

In addition to automatic publication via GitHub Actions, repos can also be pushed manually, the command to do that is:

```bash
docker push mikeoertli/ffprobe-docker:"$(cat ffprobe-version.txt)"-amd64
```

### Run

There are a couple important items to note:

1. You will need to provide a file name.
2. As shown below, a [Docker Volume](https://docs.docker.com/storage/volumes/) is created that maps the *current working directory on the host machine* to `/temp` inside the container.
3. The `WORKDIR` is `/temp`, since this is where files are expected, a relative file reference is fine.

#### Run Equivalent of 'ffprobe FILE'

```bash
docker run -it --name ffprobe --rm -v $(pwd):/temp mikeoertli/ffprobe-docker:latest "<FILE>"
```

#### Passing CLI args

You can still pass command line args, for example, if you want to print the format using the `flat` format with `-show_format -print_format flat`, you can.

```bash
docker run -it --name ffprobe --rm -v $(pwd):/temp mikeoertli/ffprobe-docker:latest -show_format -print_format flat "/temp/<your_file>.m4a"
```

## Tips and Misc. Info

### ffprobe man pages

More useful info about options for `ffprobe` can be found via [helpmanual.io](https://helpmanual.io/man1/ffprobe-all/) among many other sources.

### Auto-remove Container

The `--rm` on the `run` command will auto-delete the container when it stops ([you can read more about this here](https://docs.docker.com/engine/reference/commandline/rm/)). This makes it easier to use this containerized `ffprobe` solution in a way more similar to running it natively (this can be helpful when called from a script, too).

### Default Command

The container sets a `CMD` value of `--help`, this serves as the default parameter if none is provided when the container is run. According to the [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint):
> The best use for `ENTRYPOINT` is to set the image’s main command, allowing that image to be run as though it was that command (and then use `CMD` as the default flags).

To put it differently, if you don't pass an audio file argument to the `docker run` command, you're effectively performing the equivalent of executing `ffprobe --help` from a native command line.

### Drop-in Replacement for ffprobe

In order to make this (appear to be) a "true" drop-in replacement for running `ffprobe` natively, you could define an alias... something like this:

```bash
alias ffprobe='docker run -it --name ffprobe --rm -v $(pwd):/temp mikeoertli/ffprobe-docker:latest'
```
