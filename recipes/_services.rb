#
# Cookbook Name:: shinken
# Recipe:: _services
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

if Dir.exist?("#{node['shinken']['conf_dir']}/services")
  active_services_list = node['shinken']['services'].keys
  current_services_list = (Dir.entries("#{node['shinken']['conf_dir']}/services") -
                           %w(. ..)).map do |e|
                             e.sub(/\.cfg/, '')
                           end
  deleted_services_list = current_services_list - active_services_list

  deleted_services_list.each do |svc|
    file "#{node['shinken']['conf_dir']}/services/#{svc}.cfg" do
      action :delete
      notifies :restart, 'service[shinken-arbiter]'
    end
  end
end

node['shinken']['services'].each do |svc_name, svc_conf|
  # Enable the event handler if one is specified unless it has been explicitly
  # disabled.
  svc_conf = { 'event_handler_enabled' => 0 }.merge(svc_conf) if svc_conf['event_handler']

  if svc_conf['hostgroup_name'] &&
     !node['shinken']['hostgroups'][svc_conf['hostgroup_name']]
    fail "Service #{svc_name} refers to hostgroup " \
      "#{svc_conf['hostgroup_name']} but that hostgroup does not seem to " \
      'exist.'
  end

  template "#{node['shinken']['conf_dir']}/services/#{svc_name}.cfg" do
    source 'generic-definition.cfg.erb'
    owner  node['shinken']['user']
    group  node['shinken']['group']
    mode   0644
    variables(
      type: 'service',
      conf: node['shinken']['service_defaults'].merge(svc_conf)
    )
    notifies :restart, 'service[shinken]'
  end
end
