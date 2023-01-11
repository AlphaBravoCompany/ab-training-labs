# Rancher Advanced: Day 1 - Section 5: Labs

### In this section we learned about:

* K3d

____

## Section 5: Lab 1 - Deploying K3d

### Section 5: Lab 1 Links

* [K3d](https://k3d.io/)

____

### Section 5: Lab 1 Content

For the initial labs we were using K3d, which is Rancher K3s running in Docker on your local lab server. It will appear as if there are multiple servers and it will act that way too, but they will actually be Docker containers running the K3s Kubernetes control plane and worker nodes.

There are numerous configuration switches we can use to create a cluster. To learn more about them visit this link: https://k3d.io/v5.4.6/usage/commands/k3d_cluster_create/

The below command will bring your local clusters online with the following options:

* A name of `lab-cluster1`
* A local volume host volume mount for persistent storage
* The API running on port 16443
* 1 server node
* 3 worker nodes or agents
* Ports mapped from the host to various in cluster ports.

Before bringing the cluster online, let's check to see if we already have cluster's running:

`k3d cluster list` {{ execute }}

If any clusters are in the list, let's remove them before continuing:

`k3d cluster delete --all` {{ execute }}

Now, let's bring up a fresh cluster called `lab-cluster1`:

`k3d cluster create lab-cluster1 --volume /ab/k3dvol:/tmp/k3dvol --api-port 16443 --servers 1 --agents 3 -p 18080:80@loadbalancer -p 18443:443@loadbalancer -p "30000-30010:30000-30010@server:0"` {{ execute }}

Now we can switch to that context using a `kubectl` command:

`kubectl config use-context k3d-lab-cluster1` {{ execute }}

And see what nodes are running.

`kubectl get nodes` {{ execute }}

And there you have it, a full development grade K3s Kubernetes cluster running on your local machine.

____

### Section 5: Lab 2 Content

Since the K3d clusters are all running locally in docker, we can run more than one cluster at a time (assuming your machine has enough resources). This provides an opportunity to test some multicluster operations.

For now, let's get a 2nd K3d cluster running on the lab server.

`k3d cluster create lab-cluster2 --volume /ab/k3dvol:/tmp/k3dvol --api-port 16444 --servers 1 --agents 3 -p 18081:80@loadbalancer -p 18444:443@loadbalancer -p "30011-30020:30011-30020@server:0"` {{ execute }}

Run the following command to see that 2 clusters are now up and running on your lab server.

`k3d cluster list` {{ execute }}

And to allow for these clusters to be accessed as if they were running behind a single DNS name and load balancer, lets deploy HAProxy as a Docker container with the command below:

`docker run -d --name haproxy --restart always -p 80:80 -p 443:443 -p 9090:10090 -v /ab/misc/haproxy:/usr/local/etc/haproxy:ro --sysctl net.ipv4.ip_unprivileged_port_start=0 haproxy:2.4.2` {{ execute }}

This load balancer uses a specifically crafted HAProxy config file that references the local K3d clusters as backend targets. Let's visit the UI to see this in action:

https://haproxy-LABSERVERNAME/stats

And login with the following credentials:
**User:** admin
**Pass:** changemeplease!!

Note that the 2 k3d clusters are already showing as `Status` as `UP` in green at the bottom. We will experiment with bringing clusters down tomorrow and seeing how easy it is to maintain applications across multiple clusters in a highly available way.

Let's imagine these are geographically diverse Kubernetes clusters with a load balancer in front of them. We will explore this more in a later lab when we see how multicluster deployments of apps behind a load balancer can increase uptime.

**NOTE:** We will leave this environment online as it will be a part of our day 2 training.

____

### Congrats! You have completed the Rancher Advanced: Day 1 - Section 5 labs. You may now proceed with the rest of the course.
