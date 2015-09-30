if Dir.exist?("#{node['shinken']['conf_dir']}/hostgroups")
  active_hostgroups_list = node['shinken']['hostgroups'].keys + ['linux']
  current_hostgroups_list = (Dir.entries("#{node['shinken']['conf_dir']}/hostgroups") -
                             %w(. ..)).map do |e|
                               e.sub(/\.cfg/, '')
                             end

  deleted_hostgroups_list = current_hostgroups_list - active_hostgroups_list

  deleted_hostgroups_list.each do |hg|
    file "#{node['shinken']['conf_dir']}/hostgroups/#{hg}.cfg" do
      action :delete
      notifies :restart, 'service[shinken-arbiter]'
    end
  end
end

node['shinken']['hostgroups'].each do |hg_name, hg_conf|
  conf = { 'hostgroup_name' => hg_name }

  if hg_conf['search_str']
    conf['members'] = search(
      :node,
      node['shinken']['host_search_query'] + " AND " + hg_conf['search_str']
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
