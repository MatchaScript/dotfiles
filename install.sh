#!/bin/sh

set -e # -e: exit on error

# Check if --one-shot flag is provided
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

# If --one-shot is specified, use the one-shot installation method
if [ "$one_shot" = true ]; then
    sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --one-shot --source="$script_dir"
    exit 0
fi

# Regular installation method
if [ ! "$(command -v chezmoi)" ]; then
    bin_dir="$HOME/.local/bin"
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

# exec: replace current process with chezmoi init
exec "$chezmoi" init --apply "--source=$script_dir"
