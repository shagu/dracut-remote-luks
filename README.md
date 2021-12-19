# dracut-remote-luks

A stripped down version of [dracut-sshd](https://github.com/gsauthof/dracut-sshd) that allows password authentication.
It does not provide a shell and the only purpose is to unlock the disk. Do not use this in an untrusted network.

## Install (Fedora)

    dnf install dracut dracut-network openssh git vim
    git clone https://github.com/shagu/dracut-remote-luks /usr/lib/dracut/modules.d/46sshd
    dracut --regenerate-all -v -f

    vim /etc/default/grub
      GRUB_CMDLINE_LINUX="... rd.neednet=1 ip=dhcp"

    grub2-mkconfig -o /boot/grub2/grub.cfg
