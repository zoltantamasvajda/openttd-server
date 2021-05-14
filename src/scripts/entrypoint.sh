#!/bin/bash
set -u

# This script is based fairly heavily off bateau84/openttd's. Thanks, man!
savepath="${HOME}/.local/share/openttd/save"
loadgame="$(snapctl get loadgame)"

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
