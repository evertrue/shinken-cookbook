user 'shinken'
group 'shinken'

%w(/etc/shinken/hosts
   /etc/shinken/hostgroups).each do |dir|
  directory dir do
    owner     'shinken'
    group     'shinken'
    mode      0755
    action    :create
    recursive true
  end
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
