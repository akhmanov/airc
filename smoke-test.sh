#!/bin/sh
set -eu

tmp_dir="$(mktemp -d)"
container="airc-smoke-$$"
trap 'docker rm -f "$container" >/dev/null 2>&1 || true; rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir/cmd/app"

cat > "$tmp_dir/go.mod" <<'EOF'
module smoke

go 1.26.4
EOF

cat > "$tmp_dir/cmd/app/main.go" <<'EOF'
package main

import "fmt"

func main() { fmt.Println("smoke ok") }
EOF

docker run -d --name "$container" \
  -v "$tmp_dir:/app" \
  -e AIRC_BIN=/tmp/app \
  -e AIRC_CMD='go build -modfile ./go.mod -o /tmp/app ./cmd/app/main.go' \
  akhmanov/airc:go1.26.4 \
  -build.exclude_dir '' \
  -build.delay 0 \
  -log.main_only true >/dev/null

i=0
while [ "$i" -lt 20 ]; do
  if docker logs "$container" 2>&1 | grep -q 'smoke ok'; then
    docker logs "$container" 2>&1 | grep 'smoke ok'
    exit 0
  fi

  i=$((i + 1))
  sleep 0.5
done

docker logs "$container" 2>&1
exit 1
