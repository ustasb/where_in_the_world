FROM ruby:2.4.1-alpine3.6
MAINTAINER Brian Ustas <brianustas@gmail.com>

ARG APP_PATH="/opt/where_in_the_world"

RUN apk add --update \
  nodejs \
  nodejs-npm \
  build-base \
  && rm -rf /var/cache/apk/*

# CoffeeScript
RUN npm install -g coffeescript@1.6.3

# Sass
RUN gem install sass -v 3.5.1 --no-user-install

WORKDIR $APP_PATH
COPY . $APP_PATH

RUN rake build_public

VOLUME $APP_PATH
