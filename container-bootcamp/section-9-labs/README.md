# Container Bootcamp - Section 9: Labs

### In this section we learned about:

* StatefulSets
* DaemonSets

____

## Section 9: Lab 1 - StatefulSets

### Section 9: Lab 1 Links

* Kubernetes StatefulSets
* [Kubernetes Headless Services](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)

____

### Section 9: Lab 1 Content

StatefulSet is the workload API object used to manage stateful applications.

Manages the deployment and scaling of a set of Pods, and provides guarantees about the ordering and uniqueness of these Pods.

Like a Deployment, a StatefulSet manages Pods that are based on an identical container spec. Unlike a Deployment, a StatefulSet maintains a sticky identity for each of their Pods. These pods are created from the same spec, but are not interchangeable: each has a persistent identifier that it maintains across any rescheduling.

Let's deploy a statefulset and then see how they are named.

Switch to the Section 9 directory where the `nginx-statefulset.yml` file is located:

`cd /ab/labs/container-bootcamp/section-9-labs/`

Now lets deploy `nginx-statefulset.yml`:

`kubectl apply -f nginx-statefulset.yml -n training-lab`

View the pods that were created:

`kubectl get pods -n training-lab -o wide`

Notice that it automatically created 3 and distributed them across our worker nodes for fault tolerance.

In our deployment, our pods were given random names. Here, they are deployed in an ordinal fashion (web-0, web-1, web-2). This is ideal for things like database clusters that rely on specific names for each node.

Let's update the image that will redeploy the pods and see what happens.

Modify the following `nginx-statefulset.yml` file and replace `nginx:1.20` with `nginx:1.21`, then apply the manifest again.

Modify:

`/ab/labs/container-bootcamp/section-9-labs/nginx-statefulset`

Apply:

`kubectl apply -f nginx-statefulset.yml -n training-lab`

View Pods:

`kubectl get pods -n training-lab -o wide`

Note that the pods have been or are being Terminated and replaced, but the names stay the same.

Let's take a look at the persistent volume claims:

`kubectl get pvc -n training-lab`

Notice that persistent volumes (more on those in a later section) have ordinal names as well.

Lastly, if you look at the `nginx-statefulset.yml` file, we also had to create a service. That is because StatefulSets currently require a Headless Service to be responsible for the network identity of the Pods. (More on Services in a later lab as well).

Let's take a look at the deployed service:

`kubectl get svc -n training-lab -o wide`


Cleanup the StatefulSet:

`kubectl delete -f nginx-statefulset.yml -n training-lab`

Verify the training-lab namespace has no resources deployed:

`kubectl get all -n training-lab`

____

## Section 9: Lab 2 - DaemonSets

### Section 9: Lab 2 Links

* Kubernetes DaemonSets

### Section 9: Lab 2 Content

A DaemonSet ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected. Deleting a DaemonSet will clean up the Pods it created.

Some typical uses of a DaemonSet are:

* running a cluster storage daemon on every node
* running a logs collection daemon on every node
* running a node monitoring daemon on every node

In this case, we will deploy the fluentd pods as a DaemonSet.

Lets deploy `fluentd-daemonset.yml`:

`kubectl apply -f fluentd-daemonset.yml -n training-lab`

Let's view the pods that were created:

`kubectl get pods -n training-lab -o wide`

Notice that it automatically created 3 and distributed them across our worker nodes for fault tolerance.

Note there are 4 running because there is 1 server and 3 worker nodes, so 1 fluentd pod for each.. When we ran a Deployment or StatefulSet, we had to manually scale or update the manifest to change the number of pods. Let's deploy a new K3d worker node and see what happens.


Add another K3d worker node:

`k3d node create lab-cluster-agent-3 --cluster lab-cluster`

It will take a moment to add the agent and create the associated pod.  Let's `watch` the pod being created:

`watch kubectl get pods -n training-lab -o wide`

Note that there are now 5 pods. Kubernetes automatically scaled the DaemonSet and deployed a fluentd pod on the new worker node.

Press `Ctrl + C` to exit the `watch` command.
____

### Congrats! You have completed the Section 9 labs. You may now proceed with the rest of the course.