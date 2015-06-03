default['shinken']['user'] = 'shinken'
default['shinken']['group'] = 'shinken'
default['shinken']['home'] = '/var/lib/shinken'
default['shinken']['conf_dir'] = '/etc/shinken'
default['shinken']['install_type'] = 'package'
default['shinken']['source_url'] =
  'https://github.com/naparuba/shinken/archive/2.4.zip'
default['shinken']['source_checksum'] =
  '758f1baf5f9e218deb9f2487bfdc19d7aef0bb5a3b541c87369c0dcde034def2'

default['shinken']['agent_key_data_bag'] = 'secrets'
default['shinken']['agent_key_data_bag_item'] = 'monitoring'
