directory "#{node['shinken']['home']}/.ssh" do
  owner node['shinken']['user']
  group node['shinken']['group']
  mode 0700
  action :create
end

file "#{node['shinken']['home']}/.ssh/id_rsa" do
  owner node['shinken']['user']
  group node['shinken']['group']
  mode 0600
  content(
    Chef::EncryptedDataBagItem.load(
      node['shinken']['agent_key_data_bag'],
      node['shinken']['agent_key_data_bag_item']
    )['shinken']['agent_key']
  )
end
