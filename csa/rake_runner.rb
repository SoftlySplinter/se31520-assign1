# This makes running rake tasks (such as rake test:units) a little faster. 
# Run require './rake_runner' 
# this from a rails console. Rails console will load the rails environment once
# whereas rake 'task_id' will load rails environment
# every time. On my machine this reduced elapsed time from
# 80 secs to 25-30 secs for rake test:units
require 'rake'
class RakeRunner
    Csa::Application.load_tasks
	def self.run(task)
		Rake::Task[task].reenable
        Rake::Task[task].invoke
    rescue
    # Squelch any exception. Not good practice but a
    # fix for the test tasks that report failures. Currently
    # these are returning a status value of 2 and forcing
    # an exception to be raised
	end
end
