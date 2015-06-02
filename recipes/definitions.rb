if Chef::Config[:solo]
  Chef::Log.warn 'This recipe uses search. Chef Solo does not support search.'
end

include_recipe 'shinken::_services'
include_recipe 'shinken::_commands'
include_recipe 'shinken::_hosts'
include_recipe 'shinken::_hostgroups'
