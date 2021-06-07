
FROM alpine:3.13
MAINTAINER Mike Oertli

WORKDIR /temp

RUN wget -q https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
  && tar xJf /temp/ffmpeg-*.tar.xz \
  && mv /temp/ffmpeg-*-static/ffprobe /usr/local/bin/ \
  && rm -rf /temp/ffmpeg*

CMD ["--help"]
ENTRYPOINT ["ffprobe"]
