FROM debian:jessie

MAINTAINER Jordi Íñigo

RUN apt-get update && \
    apt-get install -yq --no-install-recommends less awscli groff-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp

ENV LANG C.UTF-8

CMD ["/usr/bin/aws", "help"]