# mkinitcpio-tailscale

This hook connects the early userspace environment to a Tailscale network to allow for remote unlocking of disks and similar functionality. This hook requires that networking be set up using another mkinitcpio module, like `net` from [`mkinitcpio-nfs-utils`](https://gitlab.archlinux.org/archlinux/packaging/packages/mkinitcpio-nfs-utils). An SSH server also must come from another mkinitcpio module, like `dropbear` from [`mkinitcpio-dropbear`](https://github.com/ahesford/mkinitcpio-dropbear).

Configuration can be done in `/etc/tailscale/tailscaled.conf`, which is
sourced as a busybox ash shell script.

    tailscale_port:    argument to -port (default: 41641)
    tailscaled_args:   other args to pass to tailscaled
    tailscale_args:    other args to pass to tailscale up
    tailscale_authkey: Tailscale auth key to use (default: 'file:/etc/tailscale/auth_key')

This hook should be given a tailscale auth key for an ephemeral node with an ACL that isolates it from the reaching the rest of the tailnet except for incoming connections.

For more information on this, see:
- https://tailscale.com/kb/1111/ephemeral-nodes/
- https://tailscale.com/kb/1068/acl-tags/#generate-an-auth-key-with-an-acl-tag
- https://tailscale.com/kb/1018/acls/

> Note: This project is not affiliated with TailScale in any way
