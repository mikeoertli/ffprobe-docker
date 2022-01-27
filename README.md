# ffprobe-docker

## Overview
Simple lightweight container to run `ffprobe` (ex: on Apple Silicon Macs since there is [no plan to support official static binaries releases for Apple Silicon](https://evermeet.cx/ffmpeg/apple-silicon-arm)).

This uses Alpine v3.15 and `ffprobe` v4.4.1.

## What is FFprobe?

![FFmpeg logo](https://trac.ffmpeg.org/ffmpeg-logo.png)

`ffprobe` [is a part](https://ffmpeg.org/ffprobe.html) of the [FFmpeg](https://ffmpeg.org) library.

## Usage

### Build

```bash
docker build -t mikeoertli/ffprobe:4.4.1 -t mikeoertli/ffprobe:latest .
```

### Run

There are a couple important items to note:

1. You will need to provide a file name. 
2. As shown below, a [Docker Volume](https://docs.docker.com/storage/volumes/) is created that maps the *current working directory on the host machine* to `/temp` inside the container.
3. The `WORKDIR` is `/temp`, since this is where files are expected, a relative file reference is fine.

#### Run Equivalent of 'ffprobe FILE'

```bash
docker run -it --name ffprobe --rm -v $(pwd):/temp mikeoertli/ffprobe:latest "<FILE>"
```

#### Passing CLI args

You can still pass command line args, for example, if you want to print the format using the `flat` format with `-show_format -print_format flat`, you can.

```bash
docker run -it --name ffprobe --rm -v $(pwd):/temp mikeoertli/ffprobe:latest -show_format -print_format flat "/temp/<your_file>.m4a"
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
