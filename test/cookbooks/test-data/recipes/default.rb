directory '/etc/shinken/hosts' do
  owner     'shinken'
  group     'shinken'
  recursive true
end

file '/etc/shinken/hosts/host-to-delete.cfg' do
  owner  'shinken'
  group  'shinken'
end

file '/etc/shinken/hostgroups/hostgroup-to-delete.cfg' do
  owner  'shinken'
  group  'shinken'
end
