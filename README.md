# Synopsis
[Object Bench](https://github.com/bigbitbus/objectbench) is a load generation tool to measure object store latencies of different public cloud providers. This [salt formula](https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html) can be used to install and execute it.
# Usage Example

There are 2 states:

Use the _objbench.install_ state to install Objbench on the targeted minion(s) using the objbench code in the specified branch from its [code repository](https://github.com/bigbitbus/objectbench).
```
salt minion state.apply objbench.install
```

The _objbench.execute_ state will execute object bench on the minion, overriding information in the map.jinja file with any pillars under the objbench:lookup:execute keys for that minion.
