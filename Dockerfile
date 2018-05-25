FROM alpine:latest
MAINTAINER Galileo Martinez "playgali@gmail.com"
ENV REFRESHED_AT 2018-Apr-15

ADD https://github.com/openfaas/faas/releases/download/0.8.2/fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

HEALTHCHECK --interval=5s CMD [ -e /tmp/.lock ] || exit 1
CMD ["fwatchdog"]
