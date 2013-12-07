# -*- mode: ruby -*-
# vim: set ft=ruby:

require 'rspec/core/rake_task'


desc 'Run unit tests'
task 'unit-test' do
  RSpec::Core::RakeTask.new :t
  Rake::Task[:t].invoke
end

desc 'Run style and best practice checks'
task :lint do
  %x{bundle exec knife cookbook test --cookbook-path .. bats-runner}
end

desc 'Remove all generated files'
task 'maintainer-clean' do
  %x{vagrant destroy -f}
  rmtree 'tmp'
  rmtree 'vendor'
  rmtree '.vagrant'
end


begin
  require 'foodcritic'
  FoodCritic::Rake::LintTask.new :foodcritic do |t|
    t.options = {:fail_tags => ['correctness']}
  end
  Rake::Task[:lint].enhance [:foodcritic]
rescue LoadError
  puts '>>>>> FoodCritic gem failed to load.'
  puts '>>>>> Lint will not included FC checks.'
end

begin
  require 'tailor/rake_task'
  Tailor::RakeTask.new :tailor
  Rake::Task[:lint].enhance [:tailor]
rescue LoadError
  puts '>>>>> Tailor gem failed to load.'
  puts '>>>>> Lint will not run tailor checks.'
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new

  task 'kitchen-clean' do
    %x{bundle exec kitchen destroy -f}
    rmtree '.kitchen'
  end
  Rake::Task['maintainer-clean'].enhance ['kitchen-clean']
rescue LoadError
  puts '>>>>> Kitchen gem failed to load.'
  puts '>>>>> Test Kitchen is not available.'
end
