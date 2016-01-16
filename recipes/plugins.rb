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
cookbook_file "#{node['shinken']['nagios_home']}/plugins/check_mesos_resource" do
  source 'plugins/check_mesos_resource'
  mode   0755
end
