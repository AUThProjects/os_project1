BUGS
====

List of chromium PIDs cannot be refreshed at the same rate the Chromium process manager changes the PIDs of its processes.

### Handling:

* Ensure that the list we are iterating over has the relevant pid directories under /proc
* If a pid is absent under /proc, we do not account it inside the statistics

### Potential solutions

* Instructions towards the Chromium browser about its process handling
* Chromium logs as a source of statistics
