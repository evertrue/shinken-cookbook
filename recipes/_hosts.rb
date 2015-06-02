active_hosts_list = search(
  :node,
  node['shinken']['host_search_query']
)

if Dir.exist?("#{node['shinken']['conf_dir']}/hosts")
  current_hosts_list = (Dir.entries("#{node['shinken']['conf_dir']}/hosts") -
                        %w(. ..)).map do |e|
                          e.sub(/\.cfg/, '')
                        end

  deleted_hosts_list = current_hosts_list - active_hosts_list.map(&:name)

  deleted_hosts_list.each do |h|
    file "#{node['shinken']['conf_dir']}/hosts/#{h}.cfg" do
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
