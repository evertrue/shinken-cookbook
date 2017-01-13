default['shinken']['broker']['port'] = '7772'
default['shinken']['broker']['modules'] = %w(
  webui2
  livestatus
)

# Documentation for this config file is available here:
# https://shinken.readthedocs.io/en/1.4.2/89_packages/enable_livestatus_module.html
default['shinken']['broker']['livestatus']['cfg_file'] = {
  'host' => '*',
  'port' => 50_000,
  'socket' => "#{node['shinken']['home']}/var/rw/live",
  'modules' => 'logstore-sqlite'
}
