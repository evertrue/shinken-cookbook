user 'shinken'
group 'shinken'

%w(hosts
   hostgroups
   services).each do |dir|
  directory "/etc/shinken/#{dir}" do
    owner     'shinken'
    group     'shinken'
    mode      0755
    action    :create
    recursive true
  end
end

%w(hosts/host-to-delete
   hostgroups/hostgroup-to-delete
   services/service-to-delete).each do |f|
  file f do
    path "/etc/shinken/#{f}.cfg"
    action :create
    owner 'shinken'
    group 'shinken'
    mode 0644
  end
end
