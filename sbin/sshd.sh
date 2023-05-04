#!/usr/bin/env bash

ssh_port=${SSH_PORT:-"2222"}

if [[ "${SSH_DISABLED:-}" != "true" ]] && ! lsof -Pi :$ssh_port -sTCP:LISTEN -t >/dev/null; then
  ssh_layer=$(realpath $(dirname ${BASH_SOURCE[0]})/..)
  ssh_dir=$(realpath /workspace/.ssh)

  # ssh requires read-only for group
  chmod go-w /workspace

  mkdir -p $ssh_dir
  cat $ssh_layer/id_rsa.pub >> $ssh_dir/authorized_keys

  cat << EOF >> $ssh_dir/sshd_config
HostKey $ssh_layer/id_rsa
AuthorizedKeysFile $ssh_dir/authorized_keys
EOF

  chmod 600 $ssh_dir/*

  sshd_path="/usr/sbin/sshd"
  if [[ -n "${SSHD_PATH}" ]]; then
    sshd_path=$SSHD_PATH
  fi

  echo "at=sshd state=starting user=$(whoami) port=${ssh_port}"
  $sshd_path -f $ssh_dir/sshd_config -o "Port ${ssh_port}"
fi
