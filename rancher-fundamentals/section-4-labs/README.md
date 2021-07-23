# Rancher Fundamentals - Section 4: Labs

### In this section we learned about:

## * Rancher Kubernetes Engine (RKE)

____

## Section 4: Lab 1 - Deploying Rancher Multi Cluster Manager

### Section 4: Lab 1 Links

* [Rancher Kubernetes Engine (RKE)](https://rancher.com/products/rke/)
____

### Section 4: Lab 1 Content

In this section we learned about about the Rancher Kubernetes Engine. For this lab, we will deploy RKE as a single node cluster on our lab server.

We have already install the RKE binary on the lab server, but if you can find download/installinstructions here: https://rancher.com/docs/rke/latest/en/installation/

First, let's make sure we are in the right directory

`cd /ab/labs/rancher-fundamentals/section-4-labs`

Then run the following command:

`rke config`

This process will walk you through a series of questions. Answer them as below for this install (but obviously modify for other installs).

Other than the question below, you can just hit `ENTER` on all other questions.

* Number of Hosts: `1`
* SSH Address of host (1): `localhost`
* SSH User of host (localhost): `abtraining`
* Is host (localhost) a Control Plane host (y/n): `y`
* Is host (localhost) a Worker host (y/n)? : `y`
* Is host (localhost) an etcd host (y/n)? : `y`

Because we are installing RKE on the localhost, we need to trick the install into SSHing into itself. Run the following 2 commands. When actually installing RKE, you would have provided a real SSH key to access the remote hosts and perform the install.

`ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""`

And then add that key to authorized_keys:

`cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`

Now we can install RKE by running the following command:

`rke up`

Once that completes, run the following command and under "STATUS" you should see "Ready":

`kubectl --kubeconfig kube_config_cluster.yml get nodes`

Now you have a local, single-node, full featured RKE Kubernetes cluster up and running. Nice work!

____

## Section 4: Lab 2 - Adding RKE to the Rancher UI

### Section 4: Lab 2 Links

* [Rancher Multi Cluster Manager]()
____

### Section 4: Lab 2 Content

To make sure we are in the RKE cluster context, run:

`export KUBECONFIG=/ab/labs/rancher-fundamentals/section-4-labs/kube_config_cluster.yml`

Now, let's add this cluster to your Rancher instance running on your lab server. 

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://LABSERVERNAME:12443
2. In the upper left next to the Rancher logo, click the down arrow, then click Global, then click "Add Cluster"
3. Select "Other Cluster"
4. Enter a the cluster name "rke-cluster" and click "Create"
5. Copy the bottom command to the clipboard by clicking on the blue button on the right.
6. Paste this into your code-server terminal on your lab server
7. Click "Done" in Rancher and soon your should see the cluster added to the UI
8. Clicking on the name "rke-cluster" will let you navigate this specific cluster

Now you should have 3 clusters showing.

1. local - Don't use this one. This is just a single node cluster running the Rancher UI
2. lab-cluster - The K3d/K3s cluster we added earlier
3. rke-cluster - The RKE cluster we just deployed

Obviously, running multiple clusters on a single machine is not useful. But the fact that you can do this shows how easy, versatile and lightweight Rancher clusters are to deploy, even on a single machine.

In your own deployments, it is recommended to have a Rancher MCM UI running for each connected network of clusters. Meaning if you have 3 clusters running that are all on the IL level or network, you can manage them from a single Rancher UI.

If you are running multiple disconnected clusters, you can run a single, lightweight Rancher UI to manage each.

____

### Congrats! You have completed the Rancher Fundamentals Section 4 labs. You may now proceed with the rest of the course.
