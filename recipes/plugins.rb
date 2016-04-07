# Installs Nagios plugins

include_recipe 'apt'

%w(
  nagios-plugins
  nagios-snmp-plugins
).each { |pkg| package pkg }

apt_repository 'brightbox-ruby' do
  uri 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
  distribution node['lsb']['codename']
  components %w(main)
  keyserver 'keyserver.ubuntu.com'
  key 'C3173AA6'
end

package 'ruby2.2'

%w(unirest trollop snmp).each { |gem_name| gem_package gem_name }

# Our plugins
%w(
  check_inodes_snmp
  check_mesos_resource
).each do |plugin|
  cookbook_file "#{node['shinken']['nagios_home']}/plugins/#{plugin}" do
    source "plugins/#{plugin}"
    mode   0755
  end
end
