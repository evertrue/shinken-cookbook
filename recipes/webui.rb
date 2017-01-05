#
# Cookbook Name:: shinken
# Recipe:: webui
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

ark 'mod-webui2' do
  url node['shinken']['webui']['source_url']
  checksum node['shinken']['webui']['source_checksum']
  path Chef::Config[:file_cache_path]
  action :put
  notifies :run, 'execute[install-webui2]'
  only_if { node['shinken']['install_type'] == 'source' }
end

python_pip 'bottle' do
  version '0.12.8'
end

python_pip 'pymongo'
package 'mongodb'

execute 'install-webui2' do
  if node['shinken']['install_type'] == 'source'
    command '/usr/bin/shinken install --local ' \
      "#{Chef::Config[:file_cache_path]}/mod-webui2"
  else
    command '/usr/bin/shinken install webui2'
  end
  user node['shinken']['user']
  environment('HOME' => node['shinken']['home'])
  creates "#{node['shinken']['home']}/modules/webui2"
  action  :run
  notifies :restart, 'service[shinken]'
end

%w(
  auth-cfg-password
  sqlitedb
  livestatus
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

directory "#{node['shinken']['home']}/var/rw" do
  recursive true
  owner node['shinken']['user']
  group node['shinken']['group']
end

template '/etc/shinken/modules/livestatus.cfg' do
  owner node['shinken']['user']
  group node['shinken']['group']
  notifies :restart, 'service[shinken]'
end

template '/etc/shinken/modules/webui2.cfg' do
  owner  node['shinken']['user']
  group  node['shinken']['group']
  notifies :restart, 'service[shinken]'
end

# Manually inserts Eric's custom-made copy to clipboard button
# a la https://github.com/shinken-monitoring/mod-webui/pull/544
%w(
  views/eltdetail.tpl
  htdocs/css/eltdetail.css
  htdocs/js/eltdetail.js
).each do |filename|
  cookbook_file "/var/lib/shinken/modules/webui2/plugins/eltdetail/#{filename}" do
    source "webui2/#{File.basename filename}"
    owner  node['shinken']['user']
  end
end
