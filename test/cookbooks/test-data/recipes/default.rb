directory '/etc/shinken/hosts' do
  recursive true
end

file '/etc/shinken/hosts/host-to-delete.cfg'

file '/etc/shinken/hostgroups/hostgroup-to-delete.cfg'
