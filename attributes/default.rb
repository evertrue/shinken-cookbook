default['shinken']['user'] = 'shinken'
default['shinken']['group'] = 'shinken'
default['shinken']['home'] = '/var/lib/shinken'
default['shinken']['conf_dir'] = '/etc/shinken'
default['shinken']['install_type'] = 'package'
default['shinken']['source_url'] =
  'https://github.com/naparuba/shinken/archive/' \
    '6f3e5a0b477508c4856c2b73c0d9bc4390754115.zip'
default['shinken']['source_checksum'] =
  'a61064aa2f1c0713fd541b224b98435d6e6e3d2822683af672b9c1b5521c9f5b'

default['shinken']['agent_key_data_bag'] = 'secrets'
default['shinken']['agent_key_data_bag_item'] = 'monitoring'
