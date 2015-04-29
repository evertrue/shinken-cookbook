%w(
  hosts
  hostgroups
).each do |d|
  directory "/etc/shinken/#{d}" do
    recursive true
  end
end

file '/etc/shinken/hosts/host-to-delete.cfg'

file '/etc/shinken/hostgroups/hostgroup-to-delete.cfg'
