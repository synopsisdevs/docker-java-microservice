FROM alpine:edge
RUN apk add --no-cache openjdk11-jdk

MAINTAINER developers@synopsis.cz

CMD tail -f /dev/null