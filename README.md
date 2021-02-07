# CMO DEBUG
Debug tools for creating *Command: Modern Operations* scenarios. Adds a number of Special Actions to speed up repetitive/tedious tasks, such as:

* Finding/labeling coordinates by latitude/longitude
* Setting heading & speed for groups of units
* Setting fuel quantity for groups of units
* Disabling AI on large sets of facilities
* and more...

### Build prerequisites
* A Bash shell (on Windows 10, install the [WSL](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/))
* [luamin](https://github.com/mathiasbynens/luamin)
* [Python 3](https://www.python.org/downloads/)

#### Quick prerequisite install instructions on Windows 10

Assuming you've installed the [WSL](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) and Ubuntu, run the following commands from the shell:
```
sudo apt-get install npm
sudo npm install -g luamin
```

### How to compile

#### Release
```
./build.sh
```

The compiled, minified Lua code will be placed in `release/debug_min.lua`. This is suitable for adding to your scenario by pasting it into the Lua Code Editor and clicking RUN as the final step in the scenario creation process.
 
#### Debug
```
./build.sh debug
```

This will produce compiled but unminified Lua code in `debug/debug_debug.lua`. This is mostly useful to observe how the final released Lua is composed from the source files.
