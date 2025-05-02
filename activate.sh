#!/usr/bin/env bash

[ "$1" == "" ] \
	&& echo "Usage: $0 [dry-build/switch/boot/home] [hostname(optional)] [...]" \
	&& exit 1

WORKDIR="/tmp/$USER-n1x0s"
RUNME="sudo nixos-rebuild"
ACTION=$1
TARGET=${2:-$(hostname)}

[ -d "$WORKDIR" ] \
	&& echo "Please remove $WORKDIR first" \
	&& exit 1

[ "$EUID" -eq 0 ] || [ "$1" == "dry-build" ] \
	&& RUNME="nixos-rebuild"

[ "$ACTION" == "home" ] \
	&& ACTION="switch" \
	&& RUNME="home-manager" \
	&& TARGET="$USER@$TARGET"

cd "$(dirname "$0")" || exit 1
install -d -m 700 "$WORKDIR"
cp -r hosts modules nixos options overlays packages resources flake.lock flake.nix \
	"$WORKDIR"

$RUNME -L --flake "$WORKDIR#$TARGET" "$ACTION" "${@:3}"

rm -rf "$WORKDIR"
