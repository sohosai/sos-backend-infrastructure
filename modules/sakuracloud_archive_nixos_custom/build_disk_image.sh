#!/usr/bin/env bash

set -euo pipefail

# images are stored under $MODULE_PATH/$OUT_DIR
readonly MODULE_PATH=$(dirname "${BASH_SOURCE[0]}")
readonly ROOT_PATH=$(realpath "$MODULE_PATH/../../")
readonly OUT_DIR=.built_image

function build_nixos_image() {
  set -euo pipefail

  local -r nixos_config=$1
  local -r imports_json=$2
  local -r contents_json=$3

  # We can't use kvm even in local (non-CI) environment
  # because this changes output hash
  local out_path
  out_path=$(
    nix-build "$MODULE_PATH/disk_image.nix" \
      --argstr configFileText "$nixos_config" \
      --arg rootPath "$ROOT_PATH" \
      --argstr importsJson "$imports_json" \
      --argstr contentTextsJson "$contents_json" \
      --arg useKvm "false" \
      --show-trace
  )

  echo "$out_path/nixos.img"
}

function embed_secret_contents() {
  set -euo pipefail

  local -r secret_contents_json=$1
  local -r output=$2

  local num_secret_contents
  num_secret_contents=$(jq length <<< "$secret_contents_json")
  if [ "$num_secret_contents" -ne 0 ]; then
    local tmp_img
    tmp_img=$(mktemp)

    local mount_point
    mount_point=$(mktemp -d)

    function unmount_and_remove_on_exit() {
      local -r ret=$?
      local -r tmp_img=$1
      local -r mount_point=$2
      set +e
      if mountpoint -q "$mount_point"; then
        guestunmount "$mount_point"
      fi
      rmdir "$mount_point"
      rm -f "$tmp_img"
      exit "$ret"
    }
    # shellcheck disable=SC2064
    trap "unmount_and_remove_on_exit \"$tmp_img\" \"$mount_point\"" EXIT

    cp "$output" "$tmp_img"
    chmod 600 "$tmp_img"
    guestmount -a "$tmp_img" -m /dev/sda1 "$mount_point"

    for idx in $(seq "$num_secret_contents"); do
      local target content mode
      target=$(jq -r ".[$idx-1].target" <<< "$secret_contents_json")
      content=$(jq -r ".[$idx-1].content" <<< "$secret_contents_json")
      mode=$(jq -r ".[$idx-1].mode" <<< "$secret_contents_json")

      if [[ $target != /* ]]; then
        1>&2 echo "target must start with /"
        exit 1
      fi

      local mounted_target=${mount_point%/}$target
      mkdir -p "$(dirname "$mounted_target")"
      touch "$mounted_target"
      if [ "$mode" != "null" ]; then
        chmod "$mode" "$mounted_target"
      fi
      echo "$content" > "$mounted_target"
    done

    guestunmount "$mount_point"
    rmdir "$mount_point"
    mv "$tmp_img" "$output"
  fi
}

function calculate_id() {
  set -euo pipefail

  local -r nixos_image=$1
  local -r secret_contents_json=$2
  local -r out_path=${nixos_image%/*}

  local secret_contents_hash
  secret_contents_hash=$(jq . <<< "$secret_contents_json" | sha256sum - | cut -d' ' -f1)

  echo "${out_path#/nix/store/}-$secret_contents_hash"
}

function main() {
  set -euo pipefail

  local query_json nixos_config contents_json secret_contents_json
  query_json=$(cat)
  nixos_config=$(jq .nixos_config -er <<< "$query_json")
  imports_json=$(jq .imports -er <<< "$query_json")
  contents_json=$(jq .contents -er <<< "$query_json")
  secret_contents_json=$(jq .secret_contents -er <<< "$query_json")

  local nixos_image id output
  nixos_image=$(build_nixos_image "$nixos_config" "$imports_json" "$contents_json")
  id=$(calculate_id "$nixos_image" "$secret_contents_json")

  local -r output_relative=${OUT_DIR%/}/${id}.img
  local -r output=${MODULE_PATH%/}/$output_relative
  mkdir -p "${MODULE_PATH%/}/$OUT_DIR"

  if [ ! -f "$output" ]; then
    touch "$output"
    chmod 600 "$output"
    cp "$nixos_image" "$output"

    embed_secret_contents "$secret_contents_json" "$output"
    chmod 400 "$output"
  fi

  local md5
  md5=$(md5sum "$output" | cut -d' ' -f1)

  cat << EOS
  {
    "id": "$id",
    "output_relative": "$output_relative",
    "md5": "$md5"
  }
EOS
}

main
