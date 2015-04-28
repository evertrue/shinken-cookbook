ark 'mod-webui' do
  url node['shinken']['webui']['source_url']
  checksum node['shinken']['webui']['source_checksum']
  path Chef::Config[:file_cache_path]
  action :put
  notifies :run, 'execute[install-webui]'
  only_if { node['shinken']['install_type'] == 'source' }
end

execute 'install-webui' do
  if node['shinken']['install_type'] == 'source'
    command '/usr/bin/shinken install --local ' \
      "#{Chef::Config[:file_cache_path]}/mod-webui"
  else
    command '/usr/bin/shinken install webui'
  end
  user node['shinken']['user']
  environment('HOME' => node['shinken']['home'])
  creates "#{node['shinken']['home']}/modules/webui"
  action  :run
  notifies :restart, 'service[shinken]'
end

%w(
  auth-cfg-password
  sqlitedb
).each do |mod|
  execute "install-#{mod}" do
    command "/usr/bin/shinken install #{mod}"
    user node['shinken']['user']
    environment('HOME' => node['shinken']['home'])
    creates "#{node['shinken']['home']}/modules/#{mod}"
    action  :run
    notifies :restart, 'service[shinken]'
  end
end

template '/etc/shinken/modules/webui.cfg' do
  source 'webui.cfg.erb'
  owner  node['shinken']['user']
  group  node['shinken']['group']
  mode   0644
  notifies :restart, 'service[shinken]'
end
