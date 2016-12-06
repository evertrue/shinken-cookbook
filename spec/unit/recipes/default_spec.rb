#
# Cookbook Name => => shinken
# Spec => => default
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

require 'spec_helper'

describe 'shinken::default' do
  context 'When all attributes are default, on Ubuntu 14.04' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        server.create_environment 'test', {}

        node.chef_environment = 'test'

        server.create_data_bag(
          'secrets',
          'api_keys' => {
            'pagerduty' => {
              'shinken' => 'SHINKEN_PD_KEY'
            },
            'slack_webhook_url' => '@@TEST_SLACK_WEBHOOK_URL@@'
          },
          'monitoring' => {
            'shinken' => {
              'testadmin' => 'PASSWORD'
            }
          }
        )

        server.create_data_bag(
          'users',
          'testadmin' => {
            'ssh_keys' => [],
            'groups'   => %w(
              sysadmin
              darksky
            ),
            'uid'     => 1001,
            'shell'   => '/bin/bash',
            'comment' => 'Test sysadmin, set up by Chef',
            'shinken' => {
              'email'    => 'testadmin@darksky.net',
              'phone'    => '5555555555',
              'is_admin' => '1'
            }
          }

        )
      end.converge described_recipe
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
