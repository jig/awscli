FROM debian:jessie

MAINTAINER Jordi Íñigo
# from https://github.com/yaronr/dockerfile/tree/master/awscli

RUN apt-get update && \
    apt-get install -yq --no-install-recommends awscli groff-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp
