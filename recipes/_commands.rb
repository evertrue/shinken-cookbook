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
