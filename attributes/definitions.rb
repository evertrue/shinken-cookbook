default['shinken']['global_defaults'] = {
  'max_check_attempts' => 1,
  'check_period' => '24x7',
  'notification_period' => '24x7'
}
default['shinken']['service_defaults'] =
  node['shinken']['global_defaults'].merge(
    'use' => 'generic-service',
    'check_interval' => 5,
    'retry_interval' => 10,
    'notification_interval' => 30
  )
default['shinken']['host_defaults'] =
  node['shinken']['global_defaults'].merge(
    'use' => 'generic-host'
  )

default['shinken']['agent_user'] = 'shinkenagent'

default['shinken']['commands'] = {
  'check_cassandra' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_cassandra -I $HOSTADDRESS$'
  },
  'check_elasticsearch' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_elasticsearch -I $HOSTADDRESS$'
  },
  'check_http' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_http -I $HOSTADDRESS$ ' \
      '-H $HOSTADDRESS$ --onredirect=follow --no-body --port=$ARG1$ --url=$ARG2$'
  },
  'check_http_content' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_http -I $HOSTADDRESS$ ' \
      '-H $HOSTADDRESS$ --onredirect=follow --port=$ARG1$ --url=$ARG2$ --regex=$ARG3$'
  },
  'check_https' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_http -I $HOSTADDRESS$ ' \
      '-H $HOSTADDRESS$ -S --onredirect=follow --no-body --port=$ARG1$ --url=$ARG2$'
  },
  'check_https_content' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_http -I $HOSTADDRESS$ ' \
      '-H $HOSTADDRESS$ -S --onredirect=follow --port=$ARG1$ --url=$ARG2$ ' \
      '--regex=$ARG3$'
  },
  'check_inodes' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_inodes_snmp -I $HOSTADDRESS$ ' \
      '--community $ARG1$'
  },
  'check_mesos_cpus' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_mesos_resource ' \
      '-I $HOSTADDRESS$ -m cpus -t $ARG1$'
  },
  'check_mesos_mem' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_mesos_resource ' \
      '-I $HOSTADDRESS$ -m mem -t $ARG1$'
  },
  'check_reboot_required' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_by_ssh ' \
      '--hostname=$HOSTADDRESS$ ' \
      "--logname=#{node['shinken']['agent_user']} " \
      '--command=\'test -f /var/run/reboot-required\' ' \
      "--identity=#{node['shinken']['home']}/.ssh/id_rsa"
  },
  'check_remote_process' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_by_ssh ' \
                      '-H $HOSTADDRESS$ ' \
                      "--logname #{node['shinken']['agent_user']} " \
                      "--command='pgrep -f $ARG1$' " \
                      '-o StrictHostKeyChecking=no ' \
                      "--identity=#{node['shinken']['home']}/.ssh/id_rsa"
  },
  'check_remote_process_memory' => {
    'command_line' => '$NAGIOSPLUGINSDIR$/check_by_ssh ' \
                      '-H $HOSTADDRESS$ ' \
                      "--logname #{node['shinken']['agent_user']} " \
                      "--command='[ $$(ps ho rss $$(pgrep $ARG1$)) -le $ARG2$ ]' " \
                      '-o StrictHostKeyChecking=no ' \
                      "--identity=#{node['shinken']['home']}/.ssh/id_rsa"
  },
  'notify_pagerduty_for_service' => {
    'command_line' => "#{node['shinken']['conf_dir']}/notification-handlers/pagerduty_handler " \
      '--description="$SERVICEDESC$" ' \
      "--env=#{node.chef_environment} " \
      '--state=$SERVICESTATE$'
  },
  'notify_pagerduty_for_host' => {
    'command_line' => "#{node['shinken']['conf_dir']}/notification-handlers/pagerduty_handler " \
      '--description="Host Ping" ' \
      "--env=#{node.chef_environment} " \
      '--host=$HOSTNAME$ ' \
      '--state=$HOSTSTATE$'
  },
  'notify_pagerduty_for_host_service' => {
    'command_line' => "#{node['shinken']['conf_dir']}/notification-handlers/pagerduty_handler " \
      '--description="Host Service $SERVICEDESC$" ' \
      "--env=#{node.chef_environment} " \
      '--host=$HOSTNAME$ ' \
      '--state=$SERVICESTATE$'
  },
  'notify_slack_for_host' => {
    'command_line' => "#{node['shinken']['conf_dir']}/notification-handlers/slack_handler " \
      '--description="Host Ping" ' \
      "--env=#{node.chef_environment} " \
      '--state=$HOSTSTATE$ ' \
      '--output="$HOSTOUTPUT$" ' \
      '--host=$HOSTNAME$ ' \
      '--channel=$ARG1$'
  },
  'notify_slack_for_host_service' => {
    'command_line' => "#{node['shinken']['conf_dir']}/notification-handlers/slack_handler " \
      '--description="Host Service $SERVICEDESC$" ' \
      "--env=#{node.chef_environment} " \
      '--state=$SERVICESTATE$ ' \
      '--output="$SERVICEOUTPUT$" ' \
      '--host=$HOSTNAME$ ' \
      '--channel=$ARG1$'
  },
  'notify_slack_for_service' => {
    'command_line' => "#{node['shinken']['conf_dir']}/notification-handlers/slack_handler " \
      '--description="$SERVICEDESC$" ' \
      "--env=#{node.chef_environment} " \
      '--state=$SERVICESTATE$ ' \
      '--output="$SERVICEOUTPUT$" ' \
      '--channel=$ARG1$ ' \
      '--url=$ARG2$'
  }
}

default['shinken']['host_search_query'] =
  "chef_environment:#{node.chef_environment}"
