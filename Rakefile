desc 'Watch and compile CoffeeScript files'
task :watch do
  system 'coffee -cwj src/application.js src/*.coffee'
end

desc 'Start a local server'
task :server do
  system 'ruby -r un -e httpd . -p 8000'
end
