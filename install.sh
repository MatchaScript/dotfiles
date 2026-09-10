#!/bin/sh

set -e

if [ "$(uname -s)" = "Darwin" ]; then
    export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/Library/Local/Executables}"
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/Library/Caches}"
    export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/Library/Local/Configuration}"
    export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/Library/Local/Library}"
    export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/Library/Local/State}"
fi

one_shot=false
for arg in "$@"; do
    case $arg in
        --one-shot)
            one_shot=true
            break
            ;;
    esac
done

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

if [ "$one_shot" = true ]; then
    sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --one-shot --source="$script_dir"
    exit 0
fi

if [ ! "$(command -v chezmoi)" ]; then
    bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
    chezmoi="$bin_dir/chezmoi"
    if [ "$(command -v curl)" ]; then
        sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
    elif [ "$(command -v wget)" ]; then
        sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
    else
        echo "To install chezmoi, you must have curl or wget installed." >&2
        exit 1
    fi
else
    chezmoi=chezmoi
fi

exec "$chezmoi" init --apply "--source=$script_dir"
