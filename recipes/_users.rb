#
# Cookbook Name:: shinken
# Recipe:: _users
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

credentials =
  data_bag_item(
    node['shinken']['webui']['credentials_data_bag'],
    node['shinken']['webui']['credentials_data_bag_item']
  )

if credentials['shinken']
  shinken_users = search(:users, 'shinken:*')

  shinken_users.each do |contact|
    raise "Missing credentials for #{contact['id']} in data_bag_item[" \
      "#{node['shinken']['webui']['credentials_data_bag']}::" \
      "#{node['shinken']['webui']['credentials_data_bag_item']}]" unless credentials['shinken'][contact['id']]
    template "#{node['shinken']['conf_dir']}/contacts/#{contact['id']}.cfg" do
      source 'generic-contact.cfg.erb'
      owner  'shinken'
      group  'shinken'
      mode   0600
      variables(
        contact: contact,
        password: credentials['shinken'][contact['id']]
      )
      notifies :restart, 'service[shinken]'
    end
  end

  template "#{node['shinken']['conf_dir']}/contactgroups/admins.cfg" do
    source 'generic-contactgroups.cfg.erb'
    owner  'shinken'
    group  'shinken'
    mode   0644
    variables(
      cg_name: 'admins',
      cg_alias: 'admins',
      members: shinken_users.select { |u| u['shinken']['is_admin'] == '1' }.map { |u| u['id'] }
    )
    notifies :restart, 'service[shinken]'
  end

  template "#{node['shinken']['conf_dir']}/contactgroups/users.cfg" do
    source 'generic-contactgroups.cfg.erb'
    owner  'shinken'
    group  'shinken'
    mode   0644
    variables(
      cg_name: 'users',
      cg_alias: 'users',
      members: shinken_users.map { |u| u['id'] }
    )
    notifies :restart, 'service[shinken]'
  end
else
  Chef::Log.warn 'No secret credentials found.'
end
