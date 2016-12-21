# DC/OS-IN-A-BOX

This ansible playbook installs DC/OS and has to be run on CentOS/RHEL 7. The
installation steps are based on the
[Advanced Installation Guide](https://dcos.io/docs/latest/administration/installing/custom/advanced/)
of DC/OS.

The playbooks are tested and configured for Intel NUC5CPYH computers with
CentOS 7.

## Differences to Normal DC/OS Installation

- The bootstrap node can be the same like a master node.

  For this sake the `docker` restart of the DC/OS install scripts was disabled.

- Overlay storage driver for docker is disabled (as it doesn't work on kernel
  versions < 3.18, CentOS 7 uses 3.10).

- Additional software gets installed used by the `node-control` script.

## Prerequisites

You need to have installed:

- [Ansible](https://www.ansible.com/)
- [DC/OS CLI](https://github.com/dcos/dcos-cli)
- wol (a wake-on-lan utility)

## Hardware Preparation

1. Enter BIOS (only for Intel NUC5CPYH computers)
   - Advanced -> Main -> Set time
   - Advanced -> Cooling -> Set `Fan Control Mode` to `Cool`
   - Advanced -> Boot -> Boot Configuration -> UEFI Boot -> OS Selection ->
     Select `Linux`
   - (Optional) Save profile as `DC/OS`
   - Exit and Save BIOS

2. Install CentOS on each node
   - Language: English (US)
   - Keyboard: English (US)
   - Use network time
   - Partitioning:
     - EFI system partition (200 MiB)
     - boot partition (500 MiB, ext4, no LVM, mount point `/boot`)
     - root partition (rest of space available, ext4, no LVM, mount point `/`)
   - Security policy: General purpose profile
   - Create **no additional users**.
   - Choose a root password (should be the same on all machines).

3. Configure CentOS
   - Configure IP address and internet connection

     An interface with the name `eth0` should be configured:

     It's encouraged to organize static IP addresses like this, but if you know
     what you do you can choose different IP addresses:

     - Bootstrap node: `1.0.0.1` or the same as a master node
     - Master nodes: `1.0.10.1-255`
     - Private agent nodes: `1.0.20.1-255`
     - Public agent nodes: `1.0.30.1-255`

     Subnet mask: `255.255.0.0` (`/16`)

     It's also encouraged to use additionally to the static internal IPs a
     dynamic IP allocated via DHCP, to allow internet access on existing
     networks quickly.

     The network interface has to be controlled by the NetworkManager.

     The easiest is to configure the network interface via the pre-installed
     tool `nmtui` which is a terminal graphics interface.

   - Update CentOS with `yum update -y`.

## Install Steps

1. Fill in the IP addresses of your cluster inside `hosts` file.

2. Within the file `group_vars/all/networking.yaml` you have to define all the
   (internal/private) IPs of your Cluster.

3. There is another file called `group_vars/all/setup.yaml`. This file is for
   configuring DC/OS. You have to fill in the variables that match your
   preferred configuration.

   > Normally you don't have to change something there :)

4. Install SSH keys on all nodes.

   1. Generate a new key.

      ```
      ssh-keygen
      ```

      And save it as `dcos-in-a-box`. It's encouraged to use a passphrase for
      the new SSH key.

   2. Authorize your key on all nodes

      This can be easily done using the `node-control` script. Turn on all nodes
      before executing

      ```
      ./node-control ssh-keys install
      ```

      Enter the root-password for each node.

      > To remove access with your key again, use
      >
      > ```
      > ./node-control ssh-keys wipe
      > ```

5. Setup Wake-on-LAN (optional)

   Though you can power on all nodes by hand, it's way easier with
   `node-control poweron`. To enable this feature, you need to enable
   Wake-on-LAN on your nodes:

   ```
   ./node-control wol enable

   ./node-control poweron
   # or equivalently
   ./node-control wol wake
   ```

   > **NOTE**
   >
   > To disable Wake-on-LAN again, you can use the
   > `./node-control wol disable` command.

6. Run `./node-control install`

## Controlling Your Cluster

The `node-control` offers a centralized way to execute common commands on
your cluster. See `./node-control help` for a list of available commands.

> **USEFUL COMMAND**
>
> `./node-control execute` allows to execute arbitrary shell commands on all
> nodes in parallel. You can use that for manual administration of your cluster.

## Steps for Uninstall

This uninstall playbook runs a cleanup script on the nodes.

```
./node-control uninstall
```
