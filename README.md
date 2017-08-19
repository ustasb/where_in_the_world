# Where in the World

[ustasb.com/whereintheworld](http://ustasb.com/whereintheworld)

A quiz to aid the learning of world country locations and capitals.

## Usage

First, build the Docker image:

    docker build -t where_in_the_world .

Compile SASS and CoffeeScript with:

    ./recompile_assets.sh

## Development

To recompile assets when files change:

    fswatch -o src css | xargs -n1 -I{} ./recompile_assets.sh

To serve assets via a local server:

    python -m SimpleHTTPServer

Navigate to `http://localhost:8000` in your browser.
