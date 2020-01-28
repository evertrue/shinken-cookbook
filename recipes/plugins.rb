# Installs Nagios plugins

include_recipe 'apt'
include_recipe 'build-essential' # Required by cassandra-driver gem which uses native code

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
package 'ruby2.2-dev'

%w(
  unirest
  trollop
  optimist
  snmp
  cassandra-driver
).each { |gem_name| gem_package gem_name }

# Our plugins
%w(
  check_cassandra
  check_elasticsearch
  check_inodes_snmp
  check_mesos_resource
  check_zookeeper_admin
).each do |plugin|
  cookbook_file "#{node['shinken']['nagios_home']}/plugins/#{plugin}" do
    source "plugins/#{plugin}"
    mode   0o755
  end
end
