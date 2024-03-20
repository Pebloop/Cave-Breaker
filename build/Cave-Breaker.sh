#!/bin/sh
echo -ne '\033c\033]0;CaveBreaker\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Cave-Breaker.x86_64" "$@"
