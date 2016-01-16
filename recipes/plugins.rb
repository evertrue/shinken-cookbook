# Installs Nagios plugins

package 'nagios-plugins' # Package plugins

include_recipe 'apt'

apt_repository 'brightbox-ruby' do
  uri 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
  distribution node['lsb']['codename']
  components %w(main)
  keyserver 'keyserver.ubuntu.com'
  key 'C3173AA6'
end

package 'ruby2.2'

%w(unirest trollop).each { |gem_name| gem_package gem_name }

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
