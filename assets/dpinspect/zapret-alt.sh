#!/usr/bin/env bash

[ "$EUID" -ne 0 ] \
	&& echo "Run as root" \
	&& exit 1

QUEUE_NUMBER="200"

ASSETS_DIR="$(dirname "$0")"
WORK_DIR="/tmp/zapret-$UID"
GAMEFILTER="0" # "1024-6553"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cp -r "$ASSETS_DIR"/* "$WORK_DIR"

ALT_PARAMS=(
	"--filter-udp=443" "--hostlist=${WORK_DIR}/list-general.txt" 
	"--dpi-desync=fake" "--dpi-desync-repeats=6" 
	"--dpi-desync-fake-quic=${WORK_DIR}/quic_initial_www_google_com.bin"

	"--new"
	"--filter-udp=50000-50100" "--filter-l7=discord,stun"
	"--dpi-desync=fake" "--dpi-desync-repeats=6"

	"--new"
	"--filter-tcp=80" "--hostlist=${WORK_DIR}/list-general.txt"
	"--dpi-desync=fake,multisplit" "--dpi-desync-autottl=2" "--dpi-desync-fooling=md5sig"

	"--new"
	"--filter-tcp=443" "--hostlist=${WORK_DIR}/list-general.txt"
	"--dpi-desync=fake,fakedsplit" "--dpi-desync-autottl=5" "--dpi-desync-repeats=6" "--dpi-desync-fooling=badseq"
	"--dpi-desync-fake-tls=${WORK_DIR}/tls_clienthello_www_google_com.bin"

	"--new"
	"--filter-udp=443" "--ipset=${WORK_DIR}/ipset-all.txt"
	"--dpi-desync=fake" "--dpi-desync-repeats=6"
	"--dpi-desync-fake-quic=${WORK_DIR}/quic_initial_www_google_com.bin"

	"--new"
	"--filter-tcp=80" "--ipset=${WORK_DIR}/ipset-all.txt"
	"--dpi-desync=fake,multisplit" "--dpi-desync-autottl=2" "--dpi-desync-fooling=md5sig"

	"--new"
	"--filter-tcp=443,${GAMEFILTER}" "--ipset=${WORK_DIR}/ipset-all.txt"
	"--dpi-desync=fake,fakedsplit" "--dpi-desync-autottl=5" "--dpi-desync-repeats=6" "--dpi-desync-fooling=badseq"
	"--dpi-desync-fake-tls=${WORK_DIR}/tls_clienthello_www_google_com.bin"

	"--new"
	"--filter-udp=${GAMEFILTER}" "--ipset=${WORK_DIR}/ipset-all.txt"
	"--dpi-desync=fake" "--dpi-desync-autottl=2" "--dpi-desync-repeats=12" "--dpi-desync-any-protocol=1"
	"--dpi-desync-fake-unknown-udp=${WORK_DIR}/quic_initial_www_google_com.bin"
	"--dpi-desync-cutoff=n3"
)

MGTS_PARAMS=(
	"--filter-udp=443" "--hostlist=$WORK_DIR/list-general.txt" "--dpi-desync=fake" "--dpi-desync-repeats=6" "--dpi-desync-fake-quic=$WORK_DIR/quic_initial_www_google_com.bin"

	"--new"
	"--filter-udp=50000-50100" "--filter-l7=discord,stun" "--dpi-desync=fake" "--dpi-desync-repeats=6"

	"--new"
	"--filter-tcp=80" "--hostlist=$WORK_DIR/list-general.txt" "--dpi-desync=fake,multisplit" "--dpi-desync-autottl=2" "--dpi-desync-fooling=md5sig"

	"--new"
	"--filter-tcp=443" "--hostlist=$WORK_DIR/list-general.txt" "--dpi-desync=fake" "--dpi-desync-autottl=2" "--dpi-desync-repeats=6" "--dpi-desync-fooling=badseq" "--dpi-desync-fake-tls=$WORK_DIR/tls_clienthello_www_google_com.bin"

	"--new"
	"--filter-udp=443" "--ipset=$WORK_DIR/ipset-all.txt" "--dpi-desync=fake" "--dpi-desync-repeats=6" "--dpi-desync-fake-quic=$WORK_DIR/quic_initial_www_google_com.bin"

	"--new"
	"--filter-tcp=80" "--ipset=$WORK_DIR/ipset-all.txt" "--dpi-desync=fake,multisplit" "--dpi-desync-autottl=2" "--dpi-desync-fooling=md5sig"

	"--new"
	"--filter-tcp=443,$GAMEFILTER" "--ipset=$WORK_DIR/ipset-all.txt" "--dpi-desync=fake" "--dpi-desync-autottl=2" "--dpi-desync-repeats=6" "--dpi-desync-fooling=badseq" "--dpi-desync-fake-tls=$WORK_DIR/tls_clienthello_www_google_com.bin"

	"--new"
	"--filter-udp=$GAMEFILTER" "--ipset=$WORK_DIR/ipset-all.txt" "--dpi-desync=fake" "--dpi-desync-autottl=2" "--dpi-desync-repeats=10" "--dpi-desync-any-protocol=1" "--dpi-desync-fake-unknown-udp=$WORK_DIR/quic_initial_www_google_com.bin" "--dpi-desync-cutoff=n2"
)

# To show command before running it
set -x
# Finally
nfqws "${PARAMS[@]}" --qnum="$QUEUE_NUMBER"

#rm -rf "$WORK_DIR"
