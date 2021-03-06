FROM alpine:3.15.1
LABEL maintainer="Mike Oertli"
LABEL build_date="2022.03.19"
LABEL description="This is intended to use as a near-drop-in-replacement for running ffprobe natively."

WORKDIR /temp

# The latest ffmpeg binary is available here: https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
# List of versions can be found here: https://www.johnvansickle.com/ffmpeg/old-releases/

# This points to the release archive specific version:
RUN wget -q https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.4.1-arm64-static.tar.xz \
  && tar xJf /temp/ffmpeg-*.tar.xz \
  && mv /temp/ffmpeg-*-static/ffprobe /usr/local/bin/ \
  && rm -rf /temp/ffmpeg*

# the CMD arg is the default flag passed if none is provided when the container is run
# More info here: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint
ENTRYPOINT ["ffprobe"]
CMD ["--help"]