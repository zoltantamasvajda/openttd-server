#!/bin/bash
set -u

# This script is based fairly heavily off bateau84/openttd's. Thanks, man!
savepath="${HOME}/.local/share/openttd/save"
loadgame="$(snapctl get loadgame)"
rcon_passwd="$(snapctl get rcon-passwd)"

if [ -z "$loadgame" ]; then
    loadgame="last-autosave"
fi

if [ -z "$rcon_passwd" ]; then
    rcon_passwd="default"
fi

CONFIG_FILE=$SNAP_USER_DATA/.config/openttd/openttd.cfg
SECRETS_FILE=$SNAP_USER_DATA/.config/openttd/secrets.cfg
FILE_TO_WRITE=$CONFIG_FILE

if test -f "$CONFIG_FILE"; then
    echo "$CONFIG_FILE exists."
    if test -f "$SECRETS_FILE"; then
        echo "$SECRETS_FILE exists."
        FILE_TO_WRITE=$SECRETS_FILE
    fi
    if [ -z "$(grep rcon_password $FILE_TO_WRITE)" ]; then
        sed -i "/\[network\]/a rcon_password = $rcon_passwd" $FILE_TO_WRITE
    else
        sed -i "s/^rcon_password .*$/rcon_password = $rcon_passwd/" $FILE_TO_WRITE
    fi
else
    echo "$CONFIG_FILE does not exist. Creating."
    mkdir -p $SNAP_USER_DATA/.config/openttd
    touch $CONFIG_FILE
    echo '[network]' >> $CONFIG_FILE
    echo "rcon_password = $rcon_password" >> $CONFIG_FILE
fi

echo ${loadgame}

if [[ -v loadgame ]]; then
    case "${loadgame}" in
    'false')
        echo "Creating a new game."
        exec ${SNAP}/usr/games/openttd/openttd -D -x
        exit 0
        ;;
    'last-autosave')
        savegame_target=${savepath}/autosave/$(ls -rt ${savepath}/autosave/ | tail -n1)

        if [ -r ${savegame_target} ]; then
            echo "Loading from autosave - ${savegame_target}"
            exec ${SNAP}/usr/games/openttd/openttd -D -g ${savegame_target} -x
            exit 0
        else
            echo "${savegame_target} not found..."
            exec ${SNAP}/usr/games/openttd/openttd -D -x
            exit 0
        fi
        ;;
    *)
        savegame_target="${savepath}/${loadgame}"
        if [ -f ${savegame_target} ]; then
            echo "Loading ${savegame_target}"
            exec ${SNAP}/usr/games/openttd/openttd -D -g ${savegame_target} -x
            exit 0
        else
            echo "${savegame_target} not found..."
            exec ${SNAP}/usr/games/openttd/openttd -D -x
            exit 0
        fi
        ;;
    esac
else
    echo "loadgame not set - Creating a new game."
    exec ${SNAP}/usr/games/openttd/openttd -D -x
    exit 0
fi
