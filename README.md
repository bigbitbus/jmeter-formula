# Synopsis
[Jmeter](https://jmeter.apache.org/) is a load generation tool. This [salt formula](https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html) can be used to install it and execute a jmx test file on jmeter.
# Usage Example

There are 2 states:

Use the _jmeter.install_ state to install Java, Jmeter, and the Mysql JDBC driver required into the _jmeter/lib_ directory (to be expanded to generic plugins in the future).
```
salt minion state.apply jmeter.install
```

This will pick up the file specified as part of the pillar at "jmeter:execute:lookup:jmx_template_file"; apply a jinja template (if needed), and run jmeter on that file. CLI arguments can be specified via the "jmeter:execute:lookup:cmd_cli_args" pillar. Look at the other options in the jmeter-formula/jmeter/map.jinja file.
```
salt minion state.apply jmeter.execute
```
