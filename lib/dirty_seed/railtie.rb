module DirtySeed
	class MyRailtie < Rails::Railtie
	  rake_tasks do
	    load "tasks/dirty_seed.rake"
	  end
	end
end