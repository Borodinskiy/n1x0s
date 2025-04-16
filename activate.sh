#!/usr/bin/env bash

if [ "$1" == "" ]
then
	echo "Usage: $0 [dry-build/switch/boot] [hostname(optional)]"
	exit 1
fi

WORKDIR="/tmp/$UID-n1x0s"
RUNME="sudo nixos-rebuild"

if [ "$EUID" -eq 0 ] || [ "$1" == "dry-build" ]
then
	RUNME=nixos-rebuild
fi

if [ -f "$WORKDIR" ]
then
	echo "Please remove $WORKDIR first"
	exit 1
fi

install -d -m 700 "$WORKDIR"
cp -r hosts modules nixos options overlays pkgs resources flake.lock flake.nix \
	"$WORKDIR"

$RUNME --flake "$WORKDIR#${2:-$(hostname)}" -L "$1"

rm -rf "$WORKDIR"
