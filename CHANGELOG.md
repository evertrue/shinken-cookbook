# CHANGELOG

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
