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

`k3d cluster create lab-cluster --volume /ab/k3dvol:/tmp/k3dvol --api-port 16443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer`

Now we can switch to that context using a `kubectl` command:

`kubectl config use-context k3d-lab-cluster`

Get cluster info:

`kubectl cluster-info`

View nodes in the cluster:

`kubectl get nodes -o wide`

Export the lab-server cluster kubeconfig to `/ab/kubeconfig/` for use with a tool like Lens:

`mkdir /ab/kubeconfig && k3d kubeconfig get lab-cluster > /ab/lab-cluster-config.yml && sed -i 's/0.0.0.0/LABSERVERNAME/' /ab/lab-cluster-config.yml`

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

## Section 7: Lab 3 - Creating Namespaces and a Pod

### Section 7: Lab 3 Links

* [Kubernetes Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
* [Kubernetes Pods](https://v1-18.docs.kubernetes.io/docs/concepts/workloads/pods/)
* [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get)
* [kubectl run](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run)
* [kubectl delete](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete)

### Section 7: Lab 3 Content

Let's create a namespace and then we can create some resources in that new namespace:

`kubectl create ns training-lab`

Verify the namespace was created:

`kubectl get ns`

Create a pod in the `training-lab` namespace:

`kubectl run nginx --image=nginx --restart=Never --namespace=training-lab`

Verify the pod was created and note what Node it is running on:

`kubectl get pods -n training-lab -o wide`

Delete the pod:

`kubectl delete pod nginx -n training-lab`

Verify it was deleted:

`kubectl get pods -n training-lab -o wide`

_____

## Section 7: Lab 4 - Creating Namespaces and a Pod

### Section 7: Lab 4 Links

* [Kubernetes ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
* [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

Now let's create a Deployment. As part of the deployment, a ReplicaSet and 3 pods will be created.

Switch to the Section 7 directory where the `nginx-deployment.yml` file is located:

`cd /ab/labs/container-bootcamp/section-7-labs/`

In VS Code, open the `nginx-deployment.yml` file and review the structure.

Now that we've reviewed the file, let's deploy `nginx-deployment.yml`:

`kubectl apply -f nginx-deployment.yml`

Let's view the pods that were created:

`kubectl get pods -n training-lab -o wide`

Notice that it automatically created 3 and distributed them across our worker nodes for fault tolerance.

We can also see that a ReplicaSet was automatically created:

`kubectl get rs -n training-lab`

The ReplicaSet is ensuring that the number of pods we specific in the manifest file is met. 

Let's open a second Terminal in vscode so we can watch the pods. Click the “Split Terminal” button in the upper right of the Terminal window or press `Control+Shift+5`. You should now have 2 windows.

On the right window, run:

`watch kubectl get pods -n training-lab`

Let's manually scale this deployment to 5 pods. In the left Terminal:

`kubectl scale --replicas=5 -f nginx-deployment.yml`

We can see the additional pods get added in the right Terminal.

What happens if we delete a pod manually? 

Choose a pod name from the `kubectl get pods` command and add it below:

`kubectl delete pod <podname> -n training-lab`

You can see that the pod we specific get Terminated, but Kubernetes knows we expect 5 pods running, so the control loop automatically reconciles the expected state of 5 pods and starts a new pod in place of the one we deleted.

What happens if we reapply the nginx-deployment.yml?

Let's try running the apply again:

`kubectl apply -f nginx-deployment.yml`

2 of the pods are immediately Terminated because the manifest file only specifies 3 pods. This illustrates why we should make changes declaratively via our manifest files. If someone were to apply our code again, it will negate our CLI changes.

We could also make changes to the manifest file like the nginx image version and when we apply, Kubernetes will remove the existing pods and replace them with the image version specified.

We can view the image being used in the pod by describing a pod:

`kubectl describe pod <podname> -n training-lab`

Scroll through the output and you can see that the `Image` is : `nginx:1.14.2`

Let's update the nginx-deployments.yml file on line 20 so that the image is `nginx:1.20.1`. 

Now, re-apply the manfest file:

`kubectl apply -f nginx-deployment.yml`

Notice that the existing Pods are terminated and replaced with pods running the new Image we specified.

To verify this, run the following against one of the new pod names:

`kubectl describe pod <podname> -n training-lab`

We can also see that because we changed details about this deployment and redeployed, a new ReplicaSet was deployed with the new spec. 

Note there are 2 ReplicaSets now:

`kubectl get rs -n training-lab`

You could use the rollback features of kubectl to move back to the previous replicaset, but again, we recommend using manifest files to make these changes.

In the right window, hit `Ctrl + C` to stop the watch and run the below command to see all resources that our deployment created in the `training-lab` namespace:

`kubectl get all -n training-lab`

Let's delete this deployment and see all resources get cleaned up:

`kubectl delete -f nginx-deployment.yml`

___

### Congrats! You have completed the Section 7 labs. You may now proceed with the rest of the course.
