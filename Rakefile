def docker_run(cmd)
  system("docker run -v #{Dir.pwd}:/opt/where_in_the_world where_in_the_world #{cmd}")
end

task :build_dist do
  system("rm -rf src/dist && mkdir src/dist")
  system("sass --update src/css:src/dist")
  system("coffee --compile --join src/dist/application.js src/js/*.coffee")
end

task :build_public => [:build_dist] do
  system("rm -rf public && mkdir public")
  system("cp -r src/dist src/imgs src/vendor src/index.html public")
end

task :docker_build_dist do
  docker_run("rake build_dist")
end

task :docker_build_dist_and_watch do
  system("fswatch -o src/js src/css | xargs -n1 -I{} rake docker_build_dist")
end

task :docker_build_public do
  docker_run("rake build_public")
end
