# mkinitcpio-tailscale

This hook connects the early userspace environment to a Tailscale network to allow for remote unlocking of disks and similar functionality. This hook requires that networking be set up using another mkinitcpio module, like `net` from [`mkinitcpio-nfs-utils`](https://gitlab.archlinux.org/archlinux/packaging/packages/mkinitcpio-nfs-utils). An SSH server also must come from another mkinitcpio module, like `dropbear` from [`mkinitcpio-dropbear`](https://github.com/ahesford/mkinitcpio-dropbear).

Configuration can be done in `/etc/tailscale/tailscaled.conf`, which is
sourced as a busybox ash shell script.

    tailscale_port:    argument to -port (default: 41641)
    tailscaled_args:   other args to pass to tailscaled
    tailscale_args:    other args to pass to tailscale up

> Note: This project is not affiliated with Tailscale in any way

## Security Considerations

Because the Tailscale key is stored in the initramfs, it may become available to attackers if not stored in an encrypted system.
Ideally, the risk could be minimised by using an ephemeral authkey, but because those expire after 90 days (and generating a new one every 90 days would be limited by the 90 day expiration of API keys), this is not feasible.

Instead, to ensure that if the Tailscale credentials are stolen, no Tailnet access can be obtained, a separate machine should be added with a restrictive ACL.

The following example ACL configuration allows `local` machines to connect to anything, and `server` machine to connect to any other `server`. By tagging every other machine on the Tailnet with `local` or `server`, tagging mkinitcpio-tailscale machines as `mkinitcpio`, and omitting any ACL for `tag:mkinitcpio`, any machine with the `mkinitcpio` tag will not be able to initiate a connection to any other machine.

```hjson
// Example ACLs for mkinitcpio-tailscale
{
	"tagOwners": {
		"tag:mkinitcpio": ["autogroup:admin"],
		"tag:server":     ["autogroup:admin"],
		"tag:local":      ["autogroup:admin"],
	},

	"acls": [
		{"action": "accept", "src": ["tag:local"], "dst": ["*:*"]},
		{"action": "accept", "src": ["tag:server"], "dst": ["tag:server:*"]},
	],
}
```

With this setup, while it is possible for an attacker to obtain the node key and other Tailscale state information from the initramfs, they would not be able to connect to any other machine in the Tailnet.

## Setup

1. [Set up ACLs](https://tailscale.com/kb/1018/acls/).
2. Generate an [auth key](https://login.tailscale.com/admin/settings/keys) and save it to a file like `/tmp/mk-ts-authkey`. Recommended settings: NOT reusable, NOT ephemeral, and tagged with the `mkinitcpio` tag or similar.
3. Run the included `mkinitcpio-tailscale-setup` script. This will generate the necessary `tailscaled.state` file in `/etc/tailscale`.
4. Add `tailscale` to `HOOKS` in `/etc/mkinitcpio.conf`, after any network setup hooks.
5. Regenerate the initramfs.
