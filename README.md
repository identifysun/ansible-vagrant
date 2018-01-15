# Ansible ToolBox For daily scripts Testing

## Install Plugins

```bash
$ vagrant plugin install vagrant-env
```

## Inventory/Hosts conifg

Use **vagrant ssh-config** command output ssh config to `~/.ssh/config`, After we can use ssh command login to vagrant virtual machine.
You can reference follow example:

```bash
$ vagrant ssh-config >> ~/.ssh/config
$ ssh master
```

## Start VM

- Cloud-Init
- Hard resize

```
$ VAGRANT_EXPERIMENTAL="cloud_init,disks" vagrant up
```

## Stop VM

```bash
$ vagrant halt
```

## Reference Links

- https://developer.hashicorp.com/vagrant/docs/disks
