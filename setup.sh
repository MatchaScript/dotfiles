#!/bin/sh

script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --one-shot --source="$script_dir"