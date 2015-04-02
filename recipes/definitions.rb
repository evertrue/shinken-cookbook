credentials =
  Chef::EncryptedDataBagItem.load(
    node['shinken']['webui']['credentials_data_bag'],
    node['shinken']['webui']['credentials_data_bag_item']
  )

if credentials['shinken']
  shinken_users = search(:users, 'shinken:*')

  shinken_users.each do |contact|
    fail "Missing credentials for #{contact['id']} in data_bag_item[" \
      "#{node['shinken']['webui']['credentials_data_bag']}::" \
      "#{node['shinken']['webui']['credentials_data_bag_item']}]" unless credentials['shinken'][contact['id']]
    template "#{node['shinken']['conf_dir']}/contacts/#{contact['id']}.cfg" do
      source 'generic-contact.cfg.erb'
      owner  node['shinken']['user']
      group  node['shinken']['group']
      mode   0600
      variables(
        contact: contact,
        password: credentials['shinken'][contact['id']]
      )
      notifies :restart, 'service[shinken]'
    end
  end

  template "#{node['shinken']['conf_dir']}/contactgroups/admins.cfg" do
    source 'generic-contactgroups.cfg.erb'
    owner  node['shinken']['user']
    group  node['shinken']['group']
    mode   0644
    variables(
      cg_name: 'admins',
      cg_alias: 'admins',
      members: shinken_users.select { |u| u['shinken']['is_admin'] == '1' }.map { |u| u['id'] }
    )
    notifies :restart, 'service[shinken]'
  end

  template "#{node['shinken']['conf_dir']}/contactgroups/users.cfg" do
    source 'generic-contactgroups.cfg.erb'
    owner  node['shinken']['user']
    group  node['shinken']['group']
    mode   0644
    variables(
      cg_name: 'users',
      cg_alias: 'users',
      members: shinken_users.map { |u| u['id'] }
    )
    notifies :restart, 'service[shinken]'
  end
else
  Chef::Log.warn 'No secret credentials found.'
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

search(
  :node,
  node['shinken']['host_search_query']
).each do |n|
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
