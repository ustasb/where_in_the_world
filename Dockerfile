FROM ubuntu:14.04
MAINTAINER Brian Ustas <brianustas@gmail.com>

RUN apt-get -y update && \
    apt-get -y install git

RUN git clone https://github.com/ustasb/where_in_the_world.git /srv/www/where_in_the_world && \
    rm -rf /srv/www/where_in_the_world/.git

WORKDIR /srv/www/where_in_the_world

VOLUME /srv/www/where_in_the_world
