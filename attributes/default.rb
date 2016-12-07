default['shinken']['home'] = '/var/lib/shinken'
default['shinken']['conf_dir'] = '/etc/shinken'
default['shinken']['install_type'] = 'package'
default['shinken']['source_url'] =
  'https://github.com/naparuba/shinken/archive/2.4.3.tar.gz'
default['shinken']['source_checksum'] =
  '393f28c6887bcbacab597f78903e961fbc8ed63a62d486e4783f3bfe50c51400'

default['shinken']['agent_key_data_bag'] = 'secrets'
default['shinken']['agent_key_data_bag_item'] = 'monitoring'

default['shinken']['services'] = {}
default['shinken']['hostgroups'] = {}
