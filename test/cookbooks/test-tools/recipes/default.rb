package 'curl'
package 'vim'

if node['platform_family'] == 'debian'
  include_recipe 'apt'
  resources(execute: 'apt-get update').run_action(:run)
end

include_recipe 'snmp'
