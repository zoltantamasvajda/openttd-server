OpenTTD is an open source simulation game based upon the popular Microprose game Transport Tycoon Deluxe, written by Chris Sawyer.

It attempts to mimic the original game as closely as possible while extending it with new features.

This is an unofficial snap containing both the engine and open* asset packs, that can be run as a service to act as a dedicated server.

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/openttd-server)

Based on work by: Daniel Llewellyn

[https://github.com/diddlesnaps/openttd](https://github.com/diddlesnaps/openttd)

Upstream project:

[https://github.com/openttd/openttd](https://github.com/openttd/openttd)

## Configuring: 

### Editing the config file

The configuration file can be found under `/root/snap/openttd-server/current/.config/openttd/openttd.cfg` and can be used the [usual way](https://wiki.openttd.org/en/Archive/Manual/Settings/Openttd.cfg) to set up the server (root access required). The file persists between restarts and updates. In order for the change to persist the server has to be stopped using `sudo snap stop openttd-server` before editing the config file. After the edits are saved the server can be restarted using `sudo snap start openttd-server`.

### Using rcon

Alternatively [rcon](https://wiki.openttd.org/en/Manual/Dedicated%20server#controlling-the-server-with-rcon) can be used to set up the server. The default rcon password is `default` and can be changed by running:

`sudo snap stop openttd-server`

`sudo snap set openttd-server rcon-passwd=YourChosenPassword`

`sudo snap start openttd-server`

## Setting savegame behavior

The snap exposes another configuration option which allows to control the savegame being loaded:

`sudo snap set openttd-server loadgame={last-autosave | false | filename.sav}`

The default behavior is `last-autosave` and it loads the latest savefile from the autosave folder.

Using the value `false` will generate a new game on each restart.

Lastly specifying a filename will load that file (if it exists inside the savegame folder `/root/snap/openttd-server/current/.local/share/openttd/save`).
