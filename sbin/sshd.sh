#!/usr/bin/env bash

if [[ "${SSH_DISABLED:-}" != "true" ]]; then
  ssh_layer=$(realpath $(dirname ${BASH_SOURCE[0]})/..)
  ssh_dir=$(realpath $HOME/.ssh)

  mkdir -p $ssh_dir
  cat $ssh_layer/id_rsa.pub >> $ssh_dir/authorized_keys

  cat << EOF >> $ssh_dir/sshd_config
HostKey $ssh_layer/id_rsa
AuthorizedKeysFile $ssh_dir/authorized_keys
EOF

  chmod 600 /workspace/.ssh/*

  ssh_port=${SSH_PORT:-"2222"}
  echo "at=sshd state=starting user=$(whoami) port=${ssh_port}"
  /usr/sbin/sshd -f $ssh_dir/sshd_config -o "Port ${ssh_port}"
fi
