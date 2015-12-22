# Installs Nagios plugins

package 'nagios-plugins' # Package plugins

include_recipe 'ruby_build'
include_recipe 'ruby_rbenv' # Needed to run our plugins

node['rbenv']['rubies'].each do |ver|
  rbenv_ruby ver
end

rbenv_global node['rbenv']['rubies'].first

%w(unirest trollop).each { |gem_name| rbenv_gem gem_name }

# Our plugins
%w(
  check_mesos_cpu
  check_mesos_mem
).each do |plugin|
  cookbook_file "#{node['shinken']['nagios_home']}/plugins/#{plugin}" do
    source "plugins/#{plugin}"
    mode   0755
  end
end
