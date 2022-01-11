# Rancher Fundamentals - Section 3: Labs

### In this section we learned about:

* Rancher Multi Cluster Manager

____

## Section 3: Lab 1 - Deploying Rancher Multi Cluster Manager

### Section 3: Lab 1 Links

* [Rancher Multi Cluster Manager]()
* [Rancher Single Node Install](https://rancher.com/docs/rancher/v2.6/en/installation/other-installation-methods/single-node-docker/)
* [Rancher HA Install](https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/)
* [Helm](https://helm.sh/)
____

### Section 3: Lab 1 Content

In this section we learned about about the Rancher Management UI, dubbed Multi Cluster Manager. If you attended the Container Bootcamp, you already know that we have Rancher running on the lab server.

We deployed this using the Single Node Install and Docker-Compose. Of note, we included a local persistent volume using a bind mount and included a path to provided certs so the UI supports HTTPS properly in the browser. Feel free to review the Docker-Compose file here:

`./rancher-docker-compose.yml` {{ open }}

To give you the experience of deploying Rancher using the recommended HA deployment, we will use the recommended Helm install to install Rancher on the K3d/K3s Cluster running locally.

First, lets make sure our K3s cluster is up and running:

`k3d cluster list` {{ execute }}

If our cluster is not online, let's create it.  Otherwise, we can move on to the next step:

`k3d cluster create lab-cluster --volume /ab/k3dvol:/tmp/k3dvol --api-port 16443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer -p "30000-30010:30000-30010@server:0"` {{ execute }}

Next, lets make sure we are using the proper context of the K3d cluster.

`kubectl config use-context k3d-lab-cluster` {{ execute }}

For the rest of the this lab, we will follow the official documentation from Rancher to perform the helm install.

https://rancher.com/docs/rancher/v2.6/en/installation/install-rancher-on-k8s/

1. Add Rancher Helm Repo

`helm repo add rancher-stable https://releases.rancher.com/server-charts/stable` {{ execute }}

2. Create Rancher namespace

`kubectl create namespace cattle-system` {{ execute }}

3. Choose the "Bring your own certificate" install

`helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.LABSERVERNAME  --set ingress.tls.source=secret` {{ execute }}

4. Add TLS secrets

`kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=/ab/certs/live/LABSERVERNAME/fullchain.pem --key=/ab/certs/live/LABSERVERNAME/privkey.pem` {{ execute }}

After 2-3 minutes, you should now be able to reach your new Rancher MCM UI here:

https://rancher.LABSERVERNAME

Let's setup the Rancher MCM UI for the first time.

1. Enter the existing password `supersecretpassword` and click `Continue`
2. Select the checkbox next to `I agree to the terms and conditions...` and click `Continue`

Feel free to navigate around, but note that the Rancher MCM already shows you information about the cluster you installed it on. Let's take a look at what it already knows about your cluster.

1. Click burger menu in the upper left, and under `Explore Cluster`, click `local`. The `local` cluster referenced here is the K3d cluster we just installed the Rancher MCM onto.
2. Note that it knows that the cluster is K3s and what version of Kubernetes it is running. Also, look at the Meters. Rancher has already started to gather info about the cluster. It knows the CPU, Memory and Pod capacity usage of the cluster
3. In the left menu, click `Nodes`. Rancher lists out all of the nodes in your cluster. If you click on each, it will tell you information about that Node. You can also, via the 3 dots at the top right, Edit the nodes to add `Labels and Annotations`. ON cluster other than the `local` cluster, you will also have the options to `Cordon` and `Drain` the nodes as you would want to do before maintenance.
4. You will also note that this view is called the `Cluster Manager`, but there is also a yellow `Cluster Explorer` button at the top. These interfaces have some overlapping functionality because Rancher is in the process of moving over to the `Cluster Explorer` interface and integrating all features into that view.

Since we already have a Rancher MCM UI running on the lab host (preinstalled for the class), let's tear with one down.

`helm uninstall rancher -n cattle-system` {{ execute }}

____

## Section 3: Lab 2 - Adding a Kubernetes cluster to Rancher MCM

### Section 3: Lab 2 Links

* [Rancher Multi Cluster Manager]()
* [Rancher Single Node Install](https://rancher.com/docs/rancher/v2.6/en/installation/other-installation-methods/single-node-docker/)
* [Rancher HA Install](https://rancher.com/docs/rancher/v2.6/en/installation/install-rancher-on-k8s/)
____

### Section 3: Lab 2 Content

We have been working with a local K3d Kubernetes cluster thus far, and it should still be deployed. Let's make sure.

`k3d cluster list` {{ execute }}

You should see a single cluster named `lab-cluster`.

____

**NOTE:** *If you do not see a k3d cluster names `lab-cluster` running, run the below command:*

`k3d cluster create lab-cluster --volume /ab/k3dvol:/tmp/k3dvol --api-port 16443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer -p "30000-30010:30000-30010@server:0"` {{ execute }}
____

To make sure we are in the right context, run:

`kubectl config use-context k3d-lab-cluster` {{ execute }}

Now, let's add this cluster to your Rancher instance running on your lab server.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://LABSERVERNAME:12443
2. In the upper left click the burger menu, then click `Cluster Management`
3. Click the button that says `Import Existing` and select `Generic`
4. Enter a the cluster name `lab-cluster` and click `Create`
5. Copy the `curl --insecure` middle command to the clipboard by clicking on the line of text
6. Paste this into your code-server terminal on your lab server
7. Wait for this process to complete. You will notice the status updating at the top of the window.
8. Clicking on the burger menu, then on `lab-cluster` will let you navigate this specific cluster

That's great. But this is called Multi Cluster Manager. In the next section you will learn about Rancher Kubernetes Engine (RKE) and we will add that cluster to the Rancher UI as well.

____

### Congrats! You have completed the Rancher Fundamentals Section 3 labs. You may now proceed with the rest of the course.
