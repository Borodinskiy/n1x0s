#!/usr/bin/env bash

print_help() {
	echo "Usage: $0 [dry-build/switch/boot] [hostname(optional)] [...]"
	exit 1
}

[ "$1" == "" ] && print_help

cd "$(dirname "$0")" || exit 1

WORKDIR="/tmp/$USER-n1x0s"
RUNME="nixos-rebuild"
ACTION=$1
TARGET=${2:-$(hostname)}

if [ ! -d "hosts/$2" ]; then
		echo "No such hostname "$2" in hosts directory"
	if [ -z "$3" ]; then
		echo "OR please specify hostname if using more then one argument"
		print_help
	fi
	exit 1
fi

[ -d "$WORKDIR" ] \
	&& echo "Please remove $WORKDIR first" \
	&& exit 1

install -d -m 700 "$WORKDIR"
cp -r assets hosts nixos options overlays packages flake.lock flake.nix \
	"$WORKDIR"

$RUNME -L --use-remote-sudo --flake "$WORKDIR#$TARGET" "$ACTION" "${@:3}"

rm -rf "$WORKDIR"
