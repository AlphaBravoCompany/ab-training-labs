# Rancher Advanced: Day 1 - Section 3: Labs

### In this section we learned about:

* K3s

____

## Section 3: Lab 1 - Deploying RKE2

### Section 3: Lab 1 Links

* [K3s](https://k3s.io/)

____

### Section 3: Lab 1 Content

K3s is mainly different from RKE2 in that in certain places, K3s has diverged from upstream Kubernetes in order to optimize for edge deployments. RKE2 can stay more closely aligned with upstream Kubernetes.

This installation is very much like RKE2. They share the similar install methods and have similar commands. Note that K3s has additional environmental variables and can autostart on install.

Make sure you have uninstalled RKE2 in the Cleanup section of the last lab, then run the command below to install K3s. 

`curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_KUBECONFIG_OUTPUT="/ab/kubeconfig/k3s.yml" INSTALL_K3S_VERSION=v1.17.3+k3s1 sh - && export KUBECONFIG=/ab/kubeconfig/k3s.yml`  {{ execute }}

Let's take a look at the notes.  Please note it will take approximately `30 seconds` for the nodes to be in a `READY` state.

`kubectl get nodes`  {{ execute }}

The steps to expand this this out to a full HA deployment are more involved, but still straight forward. 

* HA with External DB: https://rancher.com/docs/k3s/latest/en/architecture/#high-availability-k3s-server-with-an-external-db
* HA with Embdedded DB: https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/

Additionally, leveraging automation like Terraform and Ansible will allow you easily and repeatable deploy, expand and upgrade clusters to any environment you need.

____

## Section 3: Lab 2 - Upgrading K3s from the Rancher UI

### Section 3: Lab 2 Links

* [Rancher Multi Cluster Manager](https://rancher.com/products/rancher/)
____

K3s currently supports upgrading from the Rancher UI. Unfortunately, it requires availability of 1 server node to actually perform the upgrade. Since this is a single node lab cluster, the upgrade will fail if we try. We can at least see this feature availability in the Rancher UI.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://rancher-LABSERVERNAME
2. In the upper left next to the Rancher logo, click the burger menu, then click  `Cluster Management`
3. Click the button that says `Import Existing` and select `Generic`
4. Enter a the cluster name `k3s-cluster` and click `Create`
5. Copy the `curl --insecure` middle command to the clipboard by clicking on the line of text
6. Paste this into your code-server terminal on your lab server
7. In the upper left next to the Rancher logo, click the burger menu, then click  `Cluster Management` and soon your should see the cluster added to the UI.
8. Once the `k3s-cluster` shows as `Active` in the Rancher UI, click the 3 dots on the right next to the cluster and select `Edit config`.
9. At the bottom, expand `K3S Options`
10. Under `Kubernetes Version`, click the dropdown. Note that we installed `v1.17.3+k3s1` of K3s, but the Rancher UI knows there are newer version available. If we wanted to and had multiple `server nodes` available, we could select a newer version like `v1.21.5+k3s1`, then click the blue `Save` button at the bottom of the screen, and the K3s cluster would be automatically upgraded to the latest version.

____

### Cleanup

`sudo /usr/local/bin/k3s-uninstall.sh` {{ execute }}

____

### Congrats! You have completed the Rancher Advanced: Day 1 - Section 3 labs. You may now proceed with the rest of the course.
