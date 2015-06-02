if Dir.exist?("#{node['shinken']['conf_dir']}/services")
  active_services_list = node['shinken']['services'].keys
  current_services_list = (Dir.entries("#{node['shinken']['conf_dir']}/services") -
                           %w(. ..)).map do |e|
                             e.sub(/\.cfg/, '')
                           end
  deleted_services_list = current_services_list - active_services_list

  deleted_services_list.each do |svc|
    file "#{node['shinken']['conf_dir']}/services/#{svc}.cfg" do
      action :delete
      notifies :restart, 'service[shinken-arbiter]'
    end
  end
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
