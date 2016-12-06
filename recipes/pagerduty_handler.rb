#
# Cookbook Name:: shinken
# Recipe:: pagerduty_handler
#
# Copyright (C) 2016 EverTrue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

file '/etc/shinken/pagerduty.key' do
  content data_bag_item('secrets', 'api_keys')['pagerduty']['shinken']
  owner  node['shinken']['user']
  group  node['shinken']['group']
  mode 0600
end

gem_package 'pagerduty'

cookbook_file '/etc/shinken/notification-handlers/pagerduty_handler' do
  source 'event_handlers/pagerduty_handler'
  owner  node['shinken']['user']
  group  node['shinken']['group']
  mode   0755
end
