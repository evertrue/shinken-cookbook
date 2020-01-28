#
# Cookbook Name:: shinken
# Recipe:: _handlers
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

package 'ruby2.2'
gem_package 'trollop'
gem_package 'optimist'

directory '/etc/shinken/notification-handlers' do
  owner  'shinken'
  group  'shinken'
end

include_recipe 'shinken::pagerduty_handler' if node['shinken']['handlers']['pagerduty']
include_recipe 'shinken::slack_handler' if node['shinken']['handlers']['slack']
