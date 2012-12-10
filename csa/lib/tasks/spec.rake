require 'rspec/core/rake_task'

task("spec").clear

RSpec::Core::RakeTask.new(:spec)

namespace :test do
  task :rspec => :spec
end
