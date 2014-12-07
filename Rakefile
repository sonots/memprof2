# encoding: utf-8
require "bundler/gem_tasks"

require 'rake/testtask'
desc 'Run test'
Rake::TestTask.new do |t|
  t.pattern = "test/test_*.rb"
end
task :default => :test

desc 'Open an irb session preloaded with the gem library'
task :console do
    sh 'irb -rubygems -I lib'
end
task :c => :console
