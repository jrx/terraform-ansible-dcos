# DC/OS-IN-A-BOX Presentation Notes

## Before you start

Clone https://github.com/mesosphere/ansible-dcos. Be sure to checkout the
`dcos-in-a-box` branch (with `git checkout dcos-in-a-box`) and to initialize
all submodules. Be sure to read
https://github.com/mesosphere/ansible-dcos/tree/dcos-in-a-box#dcos-in-a-box.

## Get DC/OS running

1. If you don’t have a cluster yet: Organize some suited hardware and follow
   the installation instructions to setup your cluster
   (https://github.com/mesosphere/ansible-dcos/tree/dcos-in-a-box#dcos-in-a-box).

2. Connect your workstation computer to the same network as your cluster.

3. Boot your cluster with `./node-control poweron`. You can check cluster
   connectivity with `./node-control ping`.

4. Install the cluster with `./node-control install` (takes about 5 minutes).
   This needs internet connection when doing the first time (this takes about
   15 minutes then).

   > **NOTE**
   >
   > Even when running the cluster you may need internet connection, for
   > example to use the universe and install packages.

5. Open the DC/OS UI in your web-browser (just type in the address of a master
   node) and check overall cluster state.

   > **TROUBLESHOOTING**
   > It could take a few minutes after installation for all DC/OS core services
   > to become healthy. If they don’t get healthy, try `./node-control install`
   > again. If this doesn’t work, make a new clean install with
   > `./node-control reinstall`.

   > **NOTE**
   >
   > You may have recognized that you don't need to login. OAuth is by default
   > disabled to ease handling of your cluster.

6. If cluster gets healthy, start deploying apps.

## Presentation workflow

1. Install the `chuck-norris` demo: `./node-control demo chuck-norris install`

2. Show the chuck norris page serving jokes.

3. Scale the frontend service (`chuck-jokes/service`) so it’s available on
   multiple nodes

4. Show the chuck norris page again and refresh a few times to see how the IP
   of the node serving the request changes. Plug out a network cable of a node
   serving

   > **IMPORTANT**
   >
   > Do not plug out the node serving the MySQL database containing all jokes,
   > this service is not scalable! So identify first on which node this MySQL
   > instance is running!

5. Show chuck norris page and refresh. What do you see? Chuck-norris page still
   serves jokes, though one node is out-of-service. Requests are handled by the
   other nodes.

6. Plug in the network cable again (do not let pass too much time, otherwise
   the service is rescaled again on a different node). See how requests are
   served by the node with the outage again.

7. (Optional)

   a. Plug again the cable out.
   b. A few minutes later the service should be rescaled by DC/OS. Show that.
   c. Plug in the network cable again.

8. (Only doable when choosing a configuration with at least 3 masters)

   a. Determine DC/OS / Mesos master serving currently.
   b. Plug out cable of current serving master.
   c. See that DC/OS still works (when accessing other master nodes, the node
      that was diconnected can't serve a DC/OS UI obviously).
   d. Show that service operation still continues, for this purpose scale the
      chuck norris frontend service (`chuck-jokes/service`) up again.
