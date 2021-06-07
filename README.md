# ffprobe-docker
Simple lightweight container to run `ffprobe` (ex: on Apple Silicon Macs since there is [no plan to support official static binaries releases for Apple Silicon](https://evermeet.cx/ffmpeg/apple-silicon-arm)).

This uses Alpine v3.13 and `ffprobe` v4.4.

## Running

```shell
docker build -t <TAG>:latest .
docker run -it --rm -v $(pwd):/temp <TAG> /temp/<FILE>
```

**Note:** The `WORKDIR` is `/temp`.
