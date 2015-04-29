![Shinken Logo](http://www.shinken-monitoring.org/img/LogoFrameworkBlack.png)

# shinken-cookbook

Set up the [Shinken Monitor Server](http://www.shinken-monitoring.org/) and its built in Web UI module.

## Supported Platforms

Currently only tested on Ubuntu (and almost certainly will not work on RedHat).

## Data Bags (Required)

These define the access credentials, email addresses, and phone numbers of the users for your Shinken system.  You will need two data bag items, one encrypted and one unencrypted:

### Users (this one's unencrypted)

Ideally this data bag is based on the structure from the [Chef Users Cookbook](https://github.com/sethvargo-cookbooks/users), but all that's really required is that you create a data bag called `users` with one user per item, and the user items should look (at minimum) like this:

```json
{
  "id": "testuser",
  "shinken": {
    "email": "testuser@domain.com",
    "phone": "6175551212",
    "is_admin": "1"
  }
}
```

…with `is_admin` being optional.

### Credentials

This one can be anywhere you want.  It's location is defined by these attributes:

- `node['shinken']['webui']['credentials_data_bag']`
- `node['shinken']['webui']['credentials_data_bag_item']`

…and its structure should look like this:

```json
{
  "id": "example_credentials_data_bag_item",
  "shinken": {
    "testuser": "PASSWORD"
  }
}
```

Note that only the `shinken` key is sourced, so it does not have to be in its own data bag.

## Attributes

All attributes live under the `node['shinken']` key.  Attributes fall into two basic groups, *global configuration* and *resource definitions*

Currently only *services* and *hostgroups* resources can be defined.  Everything else is automatically populated.

### Global Configuration
- `user` - **String** - User to run Shinken (and all plugins) as (and own all of its config files).
- `group` - **String** - Group to run Shinken (and all plugins) as.

The following will be parsed into their respective resource definition as such:

`['key'] = 'value'` becomes `key value`

…so you can pretty much add any key detailed in the linked configuration and expect it to end up in the config files.

- `global_defaults` - **Hash** - Subkeys to this key will appear in resource definitions for all *hosts* and *services*.
- `service_defaults` - **Hash** - Defaults for services (detailed [here](https://shinken.readthedocs.org/en/latest/08_configobjects/service.html "Shinken>>Docs>>Service Definition"))
- `host_defaults` - **Hash** - Defaults for hosts (detailed [here](https://shinken.readthedocs.org/en/latest/08_configobjects/host.html "Shinken>>Docs>>Host Definition"))

### Resource Definitions

- `hostgroups` - Hostgroups can either be defined with a search, e.g.:
    ```json
    {
      "shinken": {
        "hostgroups": {
          "my-hostgroup": {
            "search_str": "recipes:important-recipe\\:\\:default"
            "conf": {
              "alias": "My HostGroup"
            }
          }
        }
      }
    }
    ```

    …or they can be defined with an array of server names:

    ```json
    {
      "shinken": {
        "hostgroups": {
          "my-hostgroup": {
            "members": [
              "server-1",
              "server-2"
            ]
            "conf": {
              "alias": "My HostGroup"
            }
          }
        }
      }
    }
    ```

    either way, `conf` defines the other keys in the resource, all of which are detailed [in the Shinken docs](https://shinken.readthedocs.org/en/latest/08_configobjects/hostgroup.html "Shinken>>Docs>>Host Group Definition").  `hostgroup_name` in the above example will automatically be set to "my-hostgroup".
- `services` - Defined exactly according to [the Shinken docs](https://shinken.readthedocs.org/en/latest/08_configobjects/service.html) with little automation, e.g.:
    ```json
    {
      "shinken": {
        "services": {
          "my-service": {
            "hostgroup_name": "my-hostgroup",
            "service_description": "My Service Check",
            "check_command": "some_check_command",
            "contact_groups": "admins"
          }
        }
      }
    }
    ```
    
    key/value pairs are parsed directly into the resource definition file with defaults (defined above) automatically being merged in.

## Usage

### shinken::default

Include `shinken` in a wrapper cookbook (or a node run list):

```ruby
include_recipe 'shinken::default'
include_recipe 'shinken::webui'
include_recipe 'shinken::broker'
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: EverTrue, Inc. (<devops@evertrue.com>)
