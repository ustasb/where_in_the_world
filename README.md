# Where in the World

[ustasb.com/where-in-the-world](http://ustasb.com/where-in-the-world)

A quiz to aid the learning of world country locations and capitals.

Initial release: 01/04/14

## Usage

First build the Docker image:

    docker build -t where_in_the_world .

Compile SASS and CoffeeScript with:

    rake docker_build_dist

    # To recompile assets when files change (uses fswatch):

    rake docker_build_dist_and_watch

Serve assets via a local server:

    cd src && python -m SimpleHTTPServer

Navigate to `http://localhost:8000` in your browser.

## Production

To build the `public/` folder:

    rake docker_build_public

Open `public/index.html`.
