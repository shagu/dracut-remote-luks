#!/bin/bash

check() {
  require_binaries sshd || return 1
  return 0
}

depends() {
  return 0
}

install() {
  for key_type in dsa ecdsa ed25519 rsa; do
    ssh_host_key=/etc/ssh/ssh_host_"$key_type"_key
    if [ -f "$ssh_host_key" ]; then
      inst_simple "$ssh_host_key".pub /etc/ssh/ssh_host_"$key_type"_key.pub
      /usr/bin/install -m 600 "$ssh_host_key" "$initdir/etc/ssh/ssh_host_${key_type}_key"
    fi
  done

  inst_binary /usr/sbin/sshd
  inst_multiple -o /etc/sysconfig/sshd /etc/sysconfig/ssh

  inst_simple "${moddir}/sshd.service" "$systemdsystemunitdir/sshd.service"
  inst_simple "${moddir}/sshd_config" /etc/ssh/sshd_config

  sed -i '/^root/d' "$initdir/etc/passwd"
  echo "root::0:0:root:/root:/bin/systemd-tty-ask-password-agent" >> "$initdir/etc/passwd"

  { grep '^sshd:' $dracutsysrootdir/etc/passwd || echo 'sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin'; } >> "$initdir/etc/passwd"
  { grep '^sshd:' $dracutsysrootdir/etc/group  || echo 'sshd:x:74:'; } >> "$initdir/etc/group"

  mkdir -p -m 0755 "$initdir/usr/share/empty.sshd"
  #mkdir -p -m 0755 "$initdir/var/empty/sshd"
  systemctl -q --root "$initdir" enable sshd

  mkdir -p -m 0755 "$initdir/var/log"
  touch "$initdir/var/log/lastlog"

  return 0
}
