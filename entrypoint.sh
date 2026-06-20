#!/bin/sh

: "${AIRC_ROOT:=.}"
: "${AIRC_TMP_DIR:=/tmp}"
: "${AIRC_SRC:=$AIRC_ROOT/cmd/app/main.go}"
: "${AIRC_BIN:=$AIRC_TMP_DIR/app}"
: "${AIRC_CMD:=go build -modfile $AIRC_ROOT/go.mod -o $AIRC_BIN $AIRC_SRC}"
: "${AIRC_DELAY:=1000}"

exec air \
  -root                 "$AIRC_ROOT" \
  -tmp_dir              "$AIRC_TMP_DIR" \
  -build.bin            "$AIRC_BIN" \
  -build.entrypoint     "$AIRC_BIN" \
  -build.cmd            "$AIRC_CMD" \
  -build.delay          "$AIRC_DELAY" \
  -build.send_interrupt "true" \
  -log.silent           "true" \
  "$@"
