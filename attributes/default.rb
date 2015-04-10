default['shinken']['user'] = 'shinken'
default['shinken']['group'] = 'shinken'
default['shinken']['home'] = '/var/lib/shinken'
default['shinken']['conf_dir'] = '/etc/shinken'
default['shinken']['install_type'] = 'package'
default['shinken']['source_url'] =
  'https://github.com/naparuba/shinken/archive/2.2.zip'
default['shinken']['source_checksum'] =
  'd7f726e47e76ad66b125e19f22315e7f583936e2ba36207243a7a48d2a239014'

default['shinken']['agent_key_data_bag'] = 'secrets'
default['shinken']['agent_key_data_bag_item'] = 'monitoring'
