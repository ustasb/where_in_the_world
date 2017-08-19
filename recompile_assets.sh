#!/usr/bin/env bash

COFFEE_CMD="coffee --compile --join dist/application.js src/*.coffee"
SASS_CMD="sass --update css:dist"

docker run -v $(pwd):/srv/www/where_in_the_world where_in_the_world $COFFEE_CMD && $SASS_CMD
