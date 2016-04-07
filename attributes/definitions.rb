default['shinken']['global_defaults'] = {
  'max_check_attempts' => 4,
  'check_period' => '24x7',
  'notification_period' => '24x7'
}
default['shinken']['service_defaults'] =
  node['shinken']['global_defaults'].merge(
    'check_interval' => 60,
    'retry_interval' => 10,
    'notification_interval' => 30
  )
default['shinken']['host_defaults'] =
  node['shinken']['global_defaults'].merge(
    'use' => 'generic-host'
  )

default['shinken']['agent_user'] = 'shinkenagent'

default['shinken']['commands'] = {
  'check_http' => {
    'command_name' => 'check_http',
    'command_line' => '$NAGIOSPLUGINSDIR$/check_http -I $HOSTADDRESS$ ' \
      '--onredirect=follow --port=$ARG1$ --url=$ARG2$'
  },
  'check_http_content' => {
    'command_name' => 'check_http_content',
    'command_line' => '$NAGIOSPLUGINSDIR$/check_http -I $HOSTADDRESS$ ' \
      '--onredirect=follow --port=$ARG1$ --url=$ARG2$ --regex=$ARG3$'
  },
  'check_inodes' => {
    'command_name' => 'check_inodes',
    'command_line' => '$NAGIOSPLUGINSDIR$/check_inodes_snmp -I $HOSTADDRESS$ ' \
      '--community $ARG1$'
  },
  'check_mesos_cpus' => {
    'command_name' => 'check_mesos_cpus',
    'command_line' => '$NAGIOSPLUGINSDIR$/check_mesos_resource ' \
      '-I $HOSTADDRESS$ -m cpus -t $ARG1$'
  },
  'check_mesos_mem' => {
    'command_name' => 'check_mesos_mem',
    'command_line' => '$NAGIOSPLUGINSDIR$/check_mesos_resource ' \
      '-I $HOSTADDRESS$ -m mem -t $ARG1$'
  },
  'check_reboot_required' => {
    'command_name' => 'check_reboot_required',
    'command_line' => '$NAGIOSPLUGINSDIR$/check_by_ssh ' \
      '--hostname=$HOSTADDRESS$ ' \
      "--logname=#{node['shinken']['agent_user']} " \
      '--command=\'test -f /var/run/reboot-required\' ' \
      "--identity=#{node['shinken']['home']}/.ssh/id_rsa"
  }
}

default['shinken']['host_search_query'] =
  "chef_environment:#{node.chef_environment}"
