#
# Cookbook Name:: shinken
# Recipe:: slack_handler
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

file '/etc/shinken/slack_webhook' do
  content(
    if node['slack'] && node['slack']['shinken']
      data_bag_item('secrets', 'api_keys')['slack']['shinken']
    else
      data_bag_item('secrets', 'api_keys')['slack_webhook_url']
    end
  )
  owner  'shinken'
  group  'shinken'
  mode 0600
end

gem_package 'slack-notifier'

cookbook_file '/etc/shinken/notification-handlers/slack_handler' do
  source 'event_handlers/slack_handler'
  owner  'shinken'
  group  'shinken'
  mode   0755
end
