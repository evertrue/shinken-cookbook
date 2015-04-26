# encoding: utf-8

def run_command(command)
  if File.exist?('Gemfile.lock')
    sh %(bundle exec #{command})
  else
    sh %(chef exec #{command})
  end
end

namespace :berks do
  desc 'vendor the cookbooks'
  task :vendor do
    run_command('rm -rvf berks-cookbooks Berksfile.lock')
    run_command('berks vendor')
  end
end

namespace :ci do
  desc 'run the unit tests'
  task :unit do
    run_command('rubocop')
    run_command('foodcritic . ')
    # run_command('rspec --format RspecJunitFormatter  --out rspec.xml')
    run_command('rspec ')
  end
  desc 'run the integration tests'
  task :integration do
    run_command('kitchen test')
  end
end

desc 'converge the node and leave it running'
task :run do
  run_command('kitchen converge')
end

desc 'stop the node and destroy it'
task :stop do
  run_command('kitchen destroy')
end

# The default rake task should just pull all cookbooks cleanly
task default: ['berks:vendor']
