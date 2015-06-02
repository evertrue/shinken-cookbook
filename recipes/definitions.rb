if Chef::Config[:solo]
  Chef::Log.warn 'This recipe uses search. Chef Solo does not support search.'
end

node['shinken']['services'].each do |svc_name, svc_conf|
  if svc_conf['hostgroup_name'] &&
     !node['shinken']['hostgroups'][svc_conf['hostgroup_name']]
    fail "Service #{svc_name} refers to hostgroup " \
      "#{svc_conf['hostgroup_name']} but that hostgroup does not seem to " \
      'exist.'
  end

  template "#{node['shinken']['conf_dir']}/services/#{svc_name}.cfg" do
    source 'generic-definition.cfg.erb'
    owner  node['shinken']['user']
    group  node['shinken']['group']
    mode   0644
    variables(
      type: 'service',
      conf: svc_conf.merge(node['shinken']['service_defaults'])
    )
    notifies :restart, 'service[shinken]'
  end
end

node['shinken']['commands'].each do |cmd_name, cmd_conf|
  template "#{node['shinken']['conf_dir']}/commands/#{cmd_name}.cfg" do
    source 'generic-definition.cfg.erb'
    owner  node['shinken']['user']
    group  node['shinken']['group']
    mode   0644
    variables(
      type: 'command',
      conf: cmd_conf
    )
    notifies :restart, 'service[shinken]'
  end
end

active_hosts_list = search(
  :node,
  node['shinken']['host_search_query']
)

if Dir.exist?('/etc/shinken/hosts')
  current_hosts_list = (Dir.entries('/etc/shinken/hosts') - ['.', '..']).map do |e|
    e.sub(/\.cfg/, '')
  end

  deleted_hosts_list = current_hosts_list - active_hosts_list.map(&:name)

  deleted_hosts_list.each do |h|
    file "/etc/shinken/hosts/#{h}.cfg" do
      action :delete
      notifies :restart, 'service[shinken-arbiter]'
    end
  end
end

active_hosts_list.each do |n|
  host_conf = {
    'host_name' => n.name,
    'alias' => n.name,
    'address' => n['fqdn']
  }

  template "#{node['shinken']['conf_dir']}/hosts/#{n.name}.cfg" do
    source 'generic-definition.cfg.erb'
    owner  node['shinken']['user']
    group  node['shinken']['group']
    mode   0644
    variables(
      type: 'host',
      conf: host_conf.merge(node['shinken']['host_defaults'])
    )
    notifies :restart, 'service[shinken-arbiter]'
  end
end

if Dir.exist?('/etc/shinken/hostgroups')
  active_hostgroups_list = node['shinken']['hostgroups'].keys + ['linux']
  current_hostgroups_list = (Dir.entries('/etc/shinken/hostgroups') - ['.', '..']).map do |e|
    e.sub(/\.cfg/, '')
  end

  deleted_hostgroups_list = current_hostgroups_list - active_hostgroups_list

  deleted_hostgroups_list.each do |hg|
    file "/etc/shinken/hostgroups/#{hg}.cfg" do
      action :delete
      notifies :restart, 'service[shinken-arbiter]'
    end
  end
end

node['shinken']['hostgroups'].each do |hg_name, hg_conf|
  conf = {}
  conf['hostgroup_name'] = hg_name

  if hg_conf['search_str']
    conf['members'] = search(
      :node,
      "chef_environment:#{node.chef_environment} AND " + hg_conf['search_str']
    ).map(&:name).join(',')
  elsif hg_conf['members']
    conf['members'] = hg_conf['members'].join(',')
  else
    fail "Hostgroup #{hg_name} must contain either `search_str` or `members`."
  end

  template "#{node['shinken']['conf_dir']}/hostgroups/#{hg_name}.cfg" do
    source 'generic-definition.cfg.erb'
    owner  node['shinken']['user']
    group  node['shinken']['group']
    mode   0644
    variables(
      type: 'hostgroup',
      conf: hg_conf['conf'].merge(conf)
    )
    notifies :restart, 'service[shinken-arbiter]'
  end
end
