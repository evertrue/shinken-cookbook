# CHANGELOG

## 1.15.3

* Another missing space...

## 1.15.2

* Add missing space to notify_slack_for_service definition

## 1.15.1

* Escape $ in command definition so that Shinken doesn't interpret it

## 1.15.0

* Use the same value for command name and command definition file name (if `command_name` is undefined)
* Include build-essential cookbook (cassandra-driver gem requires it for building native code)
* Add new command definitions
    * check_remote_process - Moved from the wrapper cookbook, just checks (using `check_by_ssh` with `pgrep`) to see if a process is running on a remote server.
    * check_remote_process_memory - This one's completely new and checks (again using `check_by_ssh`) to see if `ARG1` has a resident memory size ("RSS") greater than `ARG2` kilobytes.

## 1.14.0

* New plugin: check_elasticsearch

## 1.13.2

* Fix the supplied arguments for notify_slack_for_host

## 1.13.1

* Add missing quote to Slack notifier message

## 1.13.0

* Bump Shinken source install to 2.4.3
* kitchen yaml: test host_defaults
* Add notify_slack_for_host command
* Oops: handler_enabled should be 1 not 0

# 1.12.6

* Always enable event_handler if one is specified

# 1.12.5

* Set default max_check_attempts to 1

# 1.12.4

* Check that test-dns config is merged correctly
* When merging, override defaults with specifics, not the other way around

# 1.12.3

* Inherit generic-service in all services
* Serverspec: Expect status code 2 from cassandra check

# 1.12.2

* check_cassandra: Fail with 2 on connection refused

# 1.12.1

* Add missing arguments to slack notifier command
* Dramatically shorten the default check_interval from 60m to 5m

# 1.12.0

* Add a Slack notification event handler
* Don't fail if `node['shinken']['hosts']` not defined

# 1.11.0

* Add ability to check an API

# 1.10.0

* Add a Pagerduty notification event handler

# 1.9.0

* Add plugin: cassandra_check
* Set an IAM profile so we can test with Fog

# 1.8.2

* Don't check fake filesystems for inodes

# 1.8.1

* Allow check_inodes_snmp script to take community as a parameter

# 1.8.0

* Create a plugin to check for inode counts via snmp
* Include nagios-snmp-plugins package of plugins
* Test on real-life ec2

# 1.7.0

* Add Mesos CPU/Memory check
* Run shinken-init before setting up services

# 1.6.1

* Attributize `_hostgroups` search (#4)
* Clean up Test Kitchen config
* Consistently use user/group attributes
* Update `ec2dnsserver` to bring in bugfix

# 1.6.0

* Bump shinken package version to 2.4 and update webui package

# 1.5.0

* Move different definition types into their own recipies
* Update install sources and associated checksums
* Delete old services and hostgroups

## v1.4.0

* Add RuboCop config (#3)
* Fix convergence by removing nonexistent user from test-data cookbook (#3)
* Clean up unused files
* Clean up README
* Add Rakefile with test tasks
* Fix up some Foodcritic violations
* Fix up some RuboCop violations
* Add integration testing on Ubuntu 14.04
* Other misc. fixes to configs

## v1.3.0

* Update source-based install URLs to point to more recent copies of Shinken & its Web UI
* Add install of cherrypy library as per Shinken’s `pip install` instruction

## v1.2.1

* Forgot super-important "map" method call

## v1.2.0

* Delete hosts and hostgroups if they no longer exist in the environment
* Replace references to /etc/shinken with an attribute
* Switch to rspec3 test syntax

## v1.1.2

* Add attribute for shinken agent user

## v1.1.1

* Add private key install code so that we can use check_by_ssh

## v1.1.0

* Add a "from source" install method and include a way to differentiate between that and "from package"

## v1.0.6

* Fix command name in check_http_content (to make it reflect the file name)

## v1.0.5

* Add command: check_http_content

## v1.0.4

* Attribute-ize host search string

## v1.0.3

* Move definitions to earlier in the process

## v1.0.2

* Add check_http command

## v1.0.1

Initial release of shinken

* Enhancements
  * an enhancement

* Bug Fixes
  * a bug fix
