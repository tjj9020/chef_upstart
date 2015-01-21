# Upstart

This cookbook has a reletively narrow focus.  It solves a need to run
multiple processes of the same script.  A use case would be for running
multiple ruby scripts for a particular environment.

## Supported Platforms

CentOS 6.x

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['upstart']['config']</tt></td>
    <td>array</td>
    <td>An array of configuration files to be placed in /etc/init</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### upstart::default

Include `upstart` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[upstart::default]"
  ]
}
```

## License and Authors

Author:: tim johnson (tjj9020@gmail.com)
