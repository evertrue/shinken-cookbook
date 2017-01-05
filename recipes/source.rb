#
# Cookbook Name:: shinken
# Recipe:: source
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

package 'unzip'

ark 'shinken' do
  url node['shinken']['source_url']
  checksum node['shinken']['source_checksum']
  path Chef::Config[:file_cache_path]
  action :put
  notifies :run, 'execute[shinken_setup_py]'
end

execute 'shinken_setup_py' do
  command 'python setup.py install'
  creates '/usr/bin/shinken'
  cwd "#{Chef::Config[:file_cache_path]}/shinken"
end

directory '/var/run/shinken' do
  owner  'shinken'
  group  'shinken'
end
