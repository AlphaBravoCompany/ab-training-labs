# Container Bootcamp - Section 7: Labs

### In this section we learned about:

* [Kubectl Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
* [Kubernetes Deployment and Hosting Options](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

____

## Section 7: Lab 1 - Local Cluster Setup with K3d

### Section 7: Lab 1 Links

* [K3s](https://rancher.com/docs/k3s/latest/en/)
* [K3d](https://k3d.io/)
* [Kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Official Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* [AlphaBravo Kubernetes Cheat Sheet](https://gitlab.com/alphabravocompany/ab-cheat-sheets/-/blob/master/kubernetes-cheat-sheet.md)

____

### Section 7: Lab 1 Content

For these labs we will be using K3d, which is Rancher K3s running in Docker on your local lab server. It will appear as if there are multiple servers and it will act that way too, but they will actually be Docker containers running the K3s Kubernetes control plane and worker nodes. Cool huh?

To bring your local cluster online, run the following command:

`k3d cluster create lab-cluster --volume /ab/k3dvol:/tmp/k3dvol --api-port 16443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer -p "30000-30010:30000-30010@server[0]`

Now we can switch to that context using a `kubectl` command:

`kubectl config use-context k3d-lab-cluster`

Get cluster info:

`kubectl cluster-info`

View nodes in the cluster:

`kubectl get nodes -o wide`

Export the lab-server cluster kubeconfig to `/ab/kubeconfig/` for use with a tool like Lens:

`mkdir /ab/kubeconfig && k3d kubeconfig get lab-cluster > /ab/kubeconfig/lab-cluster-config.yml && sed -i 's/0.0.0.0/LABSERVERNAME/' /ab/kubeconfig/lab-cluster-config.yml`

____

## Section 7: Lab 2 - Exploring kubectl commands

### Section 7: Lab 2 Links

* [Kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Official Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* [AlphaBravo Kubernetes Cheat Sheet](https://gitlab.com/alphabravocompany/ab-cheat-sheets/-/blob/master/kubernetes-cheat-sheet.md)

### Section 7: Lab 2 Content

Now that we have a cluster running, let's explore the cluster with kubectl commands.

Note that sometimes we add the `-o wide` switch to get additional information from the command.

View all namespaces on the cluster:

`kubectl get ns`

View pods running in the `kube-system` namespace:

`kubectl get pods -n kube-system`

View pods running in all namespaces in the cluster:

`kubectl get pods --all-namespaces -o wide`

View all deployments in the cluster:

`kubectl get deploy --all-namespaces -o wide`

View all services in the cluster:

`kubectl get service --all-namespaces -o wide`


Feel free to refer to the links at the top of this Lab for more commands you can run to get information about the cluster.

____


### Congrats! You have completed the Section 7 labs. You may now proceed with the rest of the course.
