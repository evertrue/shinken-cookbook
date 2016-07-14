require 'spec_helper'

describe 'Environment' do
  context user('shinken') do
    it { should exist }
    it { should have_home_directory '/var/lib/shinken' }
    it { should have_login_shell '/bin/bash' }
  end

  %w(
    libcurl4-openssl-dev
    nagios-plugins
  ).each do |pkg|
    context package(pkg) do
      it { should be_installed }
    end
  end
end

describe 'Shinken Config' do
  context file('/etc/shinken/hosts/test-dns.cfg') do
    it { should be_file }
    its(:content) { should match(/address test-dns\.local/) }
  end

  context file('/etc/shinken/hosts/host-to-delete.cfg') do
    it { is_expected.to_not be_file }
  end

  context file('/etc/shinken/hostgroups/hostgroup-to-delete.cfg') do
    it { is_expected.to_not be_file }
  end

  context file('/etc/shinken/services/service-to-delete.cfg') do
    it { is_expected.to_not be_file }
  end

  context file('/etc/shinken/contacts/testuser.cfg') do
    it { should be_file }
    it { should be_mode 600 }
    its(:content) { should match(/email testuser@local/) }
  end

  describe file('/etc/shinken/commands/check_inodes.cfg') do
    it { is_expected.to be_file }
  end
end

describe 'Nagios Plugin Setup' do
  describe 'check_icmp' do
    context file('/usr/lib/nagios/plugins/check_icmp') do
      it { should be_mode 4750 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'shinken' }
      it { should be_executable.by_user 'shinken' }
    end

    context 'Inode situation CRITICAL' do
      describe command('/usr/lib/nagios/plugins/check_inodes_snmp -I localhost -t 1') do
        its(:stdout) { is_expected.to match(/^INODES CRITICAL: \/ \d{1,2}\/100;\n/) }
        its(:exit_status) { should eq 2 }
      end
    end

    context 'Inode situation OK' do
      describe command('/usr/lib/nagios/plugins/check_inodes_snmp -I localhost') do
        its(:stdout) { is_expected.to match(/^INODES OK\n/) }
        its(:exit_status) { should eq 0 }
      end
    end
  end

  describe 'check_cassandra' do
    context file('/usr/lib/nagios/plugins/check_cassandra') do
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_executable.by_user 'shinken' }
    end
  end

  context 'Bogus hostname is supplied' do
    describe command('/usr/lib/nagios/plugins/check_cassandra -I foobar') do
      its(:exit_status) { should eq 2 }
    end
  end
end

describe 'Shinken Services' do
  %w(
    shinken
    shinken-arbiter
    shinken-broker
    shinken-poller
    shinken-reactionner
    shinken-receiver
    shinken-scheduler
  ).each do |svc|
    context service(svc) do
      it { should be_enabled }
      it { should be_running }
    end
  end

  [
    7767,
    7768,
    7769,
    7771,
    7772,
    7773
  ].each do |p|
    context port(p) do
      # it { should be_listening.on('0.0.0.0').with('tcp') }
      it { should be_listening.with('tcp') }
    end
  end

  context port(7770) do
    # it { should be_listening.on('127.0.0.1').with('tcp') }
    it { should be_listening.with('tcp') }
  end
end

describe 'Shinken Web UI' do
  context command('rm -f /tmp/cookies.txt && curl -s -b /tmp/cookies.txt ' \
    '-c /tmp/cookies.txt http://localhost:7767/user/auth -d ' \
    '\'login=testuser&password=testpass&submit=submit\' && ' \
    'curl -s -b /tmp/cookies.txt -c /tmp/cookies.txt http://localhost:7767/all'
  ) do
    its(:stdout) { should match(/DNS Service Check/) }
  end
end

describe 'Event Handlers' do
  describe file('/etc/shinken/pagerduty.key') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
    its(:content) { is_expected.to_not eq '' }
  end

  describe command('/etc/shinken/notification-handlers/pagerduty_handler --help') do
    its(:stdout) { is_expected.to match('Options:
  -n, --description=<s>    Service Description
  -s, --state=<s>          Service State
  -e, --env=<s>            Environment
  -h, --host=<s>           Host Name
  -l, --help               Show this message') }
  end
end
