# Rancher Fundamentals - Section 4: Labs

### In this section we learned about:

* ### Rancher Kubernetes Engine (RKE)

____

## Section 4: Lab 1 - Deploying Rancher Multi Cluster Manager

### Section 4: Lab 1 Links

* [Rancher Kubernetes Engine (RKE)](https://rancher.com/products/rke/)
____

### Section 4: Lab 1 Content

In this section we learned about about the Rancher Kubernetes Engine. For this lab, we will deploy RKE as a single node cluster on our lab server.

We have already installed the RKE binary on the lab server, but if you can find download/install instructions here: https://rancher.com/docs/rke/latest/en/installation/

First, let's make sure we are in the right directory:

`cd /ab/labs/rancher-fundamentals/section-4-labs` {{ execute }}

Then run the following command:

`rke config` {{ execute }}

This process will walk you through a series of questions. Answer them as below for this install (but obviously modify for other installs).

Please note the options with the arrow, `->`, indicated below.  These will require options other than the default provided. The remaining options can use the defaults.  Simply press `ENTER` on these questions.

``` RKE Options
[+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]:

-> [+] Number of Hosts [1]: 1
-> [+] SSH Address of host (1) [none]: localhost

[+] SSH Port of host (1) [22]:
[+] SSH Private Key Path of host (localhost) [none]: 
[+] SSH Private Key of host (localhost) [none]:

-> [+] SSH User of host (localhost) [ubuntu]: abtraining
-> [+] Is host (localhost) a Control Plane host (y/n)? [y]: y
-> [+] Is host (localhost) a Worker host (y/n)? [n]: y
-> [+] Is host (localhost) an etcd host (y/n)? [n]: y

[+] Override Hostname of host (localhost) [none]: 
[+] Internal IP of host (localhost) [none]: 
[+] Docker socket path on host (localhost) [/var/run/docker.sock]:
[+] Network Plugin Type (flannel, calico, weave, canal, aci) [canal]:
[+] Authentication Strategy [x509]:
[+] Authorization Mode (rbac, none) [rbac]:
[+] Kubernetes Docker image [rancher/hyperkube:v1.20.8-rancher1]:
[+] Cluster domain [cluster.local]:
[+] Service Cluster IP Range [10.43.0.0/16]:
[+] Enable PodSecurityPolicy [n]:
[+] Cluster Network CIDR [10.42.0.0/16]:
[+] Cluster DNS Service IP [10.43.0.10]:
[+] Add addon manifest URLs or YAML files [no]:
```

Because we are installing RKE on the localhost, we need to trick the install into SSHing into itself. Run the following 2 commands. When actually installing RKE, you would have provided a real SSH key to access the remote hosts and perform the install.

`ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""` {{ execute }}

And then add that key to authorized_keys:

`cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys` {{ execute }}

Now we can install RKE by running the following command:

`rke up` {{ execute }}

Once that completes, run the following command and under `STATUS` you should see `Ready`:

`kubectl --kubeconfig kube_config_cluster.yml get nodes` {{ execute }}

Now you have a local, single-node, full featured RKE Kubernetes cluster up and running. Nice work!

____

## Section 4: Lab 2 - Adding RKE to the Rancher UI

### Section 4: Lab 2 Links

* [Rancher Multi Cluster Manager](https://rancher.com/products/rancher/)
____

### Section 4: Lab 2 Content

To make sure we are in the RKE cluster context, run:

`export KUBECONFIG=/ab/labs/rancher-fundamentals/section-4-labs/kube_config_cluster.yml` {{ execute }}

Now, let's add this cluster to your Rancher instance running on your lab server. 

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://rancher-LABSERVERNAME
2. In the upper left click the burger menu, then click `Cluster Management`
3. Click the button that says `Import Existing` and select `Generic`
4. Enter a the cluster name `rke-cluster` and click `Create`
5. Copy the `curl --insecure` middle command to the clipboard by clicking on the line of text
6. Paste this into your code-server terminal on your lab server
7. Wait for this process to complete. You will notice the status updating at the top of the window.
8. Clicking on the burger menu, then on `rke-cluster` will let you navigate this specific cluster

Now you should have 3 clusters showing.

1. local - Don't use this one. This is just a single node cluster running the Rancher UI
2. lab-cluster - The K3d/K3s cluster we added earlier
3. rke-cluster - The RKE cluster we just deployed

Obviously, running multiple clusters on a single machine is not useful. But the fact that you can do this shows how easy, versatile and lightweight Rancher clusters are to deploy, even on a single machine.

In your own deployments, it is recommended to have a Rancher MCM UI running for each connected network of clusters. Meaning if you have 3 clusters running that are all on the IL level or network, you can manage them from a single Rancher UI.

If you are running multiple disconnected clusters, you can run a single Rancher MCM UI to manage each.

____

### Congrats! You have completed the Rancher Fundamentals Section 4 labs. You may now proceed with the rest of the course.
