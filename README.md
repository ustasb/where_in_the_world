# Where in the World

- [brianustas.com/where-in-the-world/](http://brianustas.com/where-in-the-world/)
- Initial release: 01/04/14
- Author: [Brian Ustas](http://brianustas.com)

An interactive quiz to aid the learning of world country locations and capitals.

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
