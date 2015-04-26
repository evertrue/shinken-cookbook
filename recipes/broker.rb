template '/etc/shinken/brokers/broker-master.cfg' do
  source 'broker-master.cfg.erb'
  owner node['shinken']['user']
  group node['shinken']['group']
  mode 0644
  notifies :restart, 'service[shinken]'
end
