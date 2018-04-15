#FROM arm32v6/alpine:latest
FROM playgali/alpine-qemu
MAINTAINER Galileo Martinez "playgali@gmail.com"
ENV REFRESHED_AT 2018-Apr-15

RUN [ "cross-build-start" ]

ADD https://github.com/openfaas/faas/releases/download/0.7.9/fwatchdog-armhf /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

RUN [ "cross-build-end" ]

HEALTHCHECK --interval=5s CMD [ -e /tmp/.lock ] || exit 1
CMD ["fwatchdog"]
