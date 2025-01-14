#!/usr/bin/env bash

set -euo pipefail

SSH_OPTS=(
  -o "StrictHostKeyChecking=no"
  -o "UserKnownHostsFile=/dev/null"
  -o "GlobalKnownHostsFile=/dev/null"
  -o "BatchMode=yes"
)
readonly SSH_OPTS
SYSTEM_PROFILE=/nix/var/nix/profiles/system
readonly SYSTEM_PROFILE
PROJECT=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../")
readonly PROJECT

function main() {
  set -euo pipefail

  local -r remote_host=root@$1
  local -r private_key_file=$2
  shift 2
  local -ar configurations=( "$@" )

  local -ar ssh_opts=( "${SSH_OPTS[@]}" -i "$private_key_file" )

  local workdir
  workdir=$(mktemp -d)

  scp "${ssh_opts[@]}" "$remote_host:/etc/nixos/sakuracloud-server-config.nix" "$workdir/sakuracloud-server-config.nix"
  scp "${ssh_opts[@]}" "$remote_host:/etc/nixos/sos23-staging-server.nix" "$workdir/sos23-staging-server.nix"
  scp "${ssh_opts[@]}" "$remote_host:/etc/nixos/base-config.nix" "$workdir/base-config.nix"

  local out_path
  out_path=$(
    nix-build "$PROJECT/nix/system.nix" \
      --arg imports "\
        [ $workdir/sakuracloud-server-config.nix  \
          $workdir/sos23-staging-server.nix       \
          $workdir/base-config.nix                \
          ${configurations[*]}                    \
        ]"
  )

  NIX_SSHOPTS="${ssh_opts[*]}" nix-copy-closure --to "$remote_host" "$out_path" --gzip --use-substitutes

  ssh "${ssh_opts[@]}" "$remote_host" nix-env --profile "$SYSTEM_PROFILE" --set "$out_path"
  ssh "${ssh_opts[@]}" "$remote_host" "$out_path/bin/switch-to-configuration" switch
}

main "$@"
