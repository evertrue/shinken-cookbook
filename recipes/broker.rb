#
# Cookbook Name:: shinken
# Recipe:: broker
#
# Copyright (C) 2014 EverTrue, Inc.
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

template '/etc/shinken/brokers/broker-master.cfg' do
  source 'broker-master.cfg.erb'
  owner  'shinken'
  group  'shinken'
  mode   0644
  notifies :restart, 'service[shinken]'
end

%w(
  logstore-sqlite
).each do |mod|
  execute "install-#{mod}" do
    command "/usr/bin/shinken install #{mod}"
    user node['shinken']['user']
    environment('HOME' => node['shinken']['home'])
    creates "#{node['shinken']['home']}/modules/#{mod}"
    action  :run
    notifies :restart, 'service[shinken]'
  end
end

template '/etc/shinken/modules/livestatus.cfg' do
  owner 'shinken'
  group 'shinken'
  notifies :restart, 'service[shinken]'
end
