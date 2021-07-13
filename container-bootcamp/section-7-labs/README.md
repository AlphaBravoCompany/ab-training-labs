# Container Bootcamp - Section 7: Labs

### In this section we learned about:

* Kubectl Basics
* Kubernetes Deployment and Hosting Options

____

## Lab 1 Links

* K3s
* K3d
* Official Kubectl Cheat Sheet
* AlphaBravo Kubernetes Cheat Sheet


## Lab 1 - Bringing up a local cluster

For these labs we will be using K3d, which is Rancher K3s running in Docker on your local lab server. It will appear as if there are multiple servers and it will act that way too, but they will actually be Docker containers running the K3s Kubernetes control plane and worker nodes. Cool huh?

To bring your local cluster online, run the following command.

`k3d cluster create lab-cluster --volume /ab/k3dvol:/tmp/k3dvol --api-port 16443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer`

Create a K3d cluster: k3d cluster create lab-cluster --api-port 16443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer

Switch context to the cluster: kubectl config use-context k3d-lab-cluster

Get cluster info: kubectl cluster-info

export cluster config: k3d kubeconfig get lab-cluster > /ab/lab-cluster-config.yml

Delete K3d cluster: k3d cluster delete lab-cluster