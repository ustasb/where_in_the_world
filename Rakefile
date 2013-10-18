desc 'Watch and compile CoffeeScript files'
task :coffee_watch do
  system 'coffee -cwj src/application.js src/*.coffee'
end

desc 'Watch and compile SASS files'
task :sass_watch do
  system 'sass --watch css:css'
end

desc 'Start a local server'
task :server do
  system 'ruby -r un -e httpd . -p 8000'
end

desc 'Run all the tasks'
task :all do
  Thread.new { Rake::Task['coffee_watch'].invoke }
  Thread.new { Rake::Task['sass_watch'].invoke }
  Thread.new { Rake::Task['server'].invoke }
end

task :default => [:all]
