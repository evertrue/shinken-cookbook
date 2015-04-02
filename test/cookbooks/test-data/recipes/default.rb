directory '/etc/shinken/hosts' do
  owner     'shinken'
  group     'shinken'
  mode      0755
  action    :create
  recursive true
end

file '/etc/shinken/hosts/host-to-delete.cfg' do
  action :create
  owner  'shinken'
  group  'shinken'
  mode   0644
end

file '/etc/shinken/hostgroups/hostgroup-to-delete.cfg' do
  action :create
  owner  'shinken'
  group  'shinken'
  mode   0644
end
