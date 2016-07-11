file '/etc/shinken/pagerduty.key' do
  content data_bag_item('secrets', 'api_keys')['pagerduty']['shinken']
  owner  'shinken'
  group  'shinken'
  mode 0600
end

package 'ruby2.2'

gem_package 'pagerduty'
gem_package 'trollop'

directory '/etc/shinken/notification-handlers' do
  owner  'shinken'
  group  'shinken'
end

cookbook_file '/etc/shinken/notification-handlers/pagerduty_handler' do
  source 'event_handlers/pagerduty_handler'
  owner  'shinken'
  group  'shinken'
  mode   0755
end
