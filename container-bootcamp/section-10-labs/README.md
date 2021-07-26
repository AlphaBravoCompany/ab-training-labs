# Container Bootcamp - Section 10: Labs

### In this section we learned about:

* Services

____

## Section 10: Lab 1 - Services

### Section 10: Lab 1 Links

* [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)

____

### Section 10: Lab 1 Content

As we discussed in the slides, a Service is an abstract way to expose an application running on a set of Pods as a network service.

With Kubernetes you don't need to modify your application to use an unfamiliar service discovery mechanism. Kubernetes gives Pods their own IP addresses and a single DNS name for a set of Pods, and can load-balance across them.

The 4 types of services are:

* ClusterIP
* NodePort
* Loadbalancer
* ExternalName

Let's explore the first 2 types on our lab server. The LoadBalancer and ExternalName type require resource that would need to be activley provisioned in a cloud or enterprise environment.

### Lab 1a - ClusterIP

First, let's get a Deployment with 2 pods initially running in our cluster. This Deployment will run a special `whoami` pod that displays information about the pod and the pod host. This will allow us to see the service load balancing across those 3 pods. Next we will scale that deployment to 5 pods and see that no additional intervention is needed on our part for the service to auto discover and start sending traffic to those new pods.

Change directory the Section 10 directory:

`cd /ab/labs/container-bootcamp/section-10-labs` {{ execute }}

Run the whoami Deployment in the `training-lab` namespace:

`kubectl apply -f whoami-deployment` {{ execute }}

And now let's deploy the `clusterip-service.yml` service. This will create a cluster internal only resource. Image this may be a database that doesn't need to be exposed to the outside world, but that other pods running in this namespace may need access to.

`kubectl apply -f clusterip-service.yml` {{ execute }}

Check the `training-lab` namespace to make sure all resources are running. There should be 1 netshoot Pod, 2 whoami Pods and a ClusterIP service.

`kubectl get all -n training-lab` {{ execute }}

Since ClusterIP is internal only, we need another pod running that namespace we can communicate with it from.

For this, we will use a container that is great for troubleshooting called "Netshoot". Running the below command will drop you into the shell of the Netshoot pod. To exit you are done, type `exit`.

Open a second terminal in split screen next to the first and run the below command.

`kubectl run netshoot -it --rm --namespace=training-lab --image nicolaka/netshoot -- /bin/bash` {{ execute }}

Now that we are in the pod, lets query the `whoami-clusterip-service` to see how it divides traffic to our pods. The below command simply calls curl 10 times and displays the hostname of the pod it hits each time.

`for ((i=1;i<=10;i++)); do curl -0 -v whoami-clusterip-service 2>&1; done | grep Hostname` {{ execute }}

We should see approx a 50/50 split between our 2 running pods.

Let's scale our deployment to 10 pods and try this again.

In the right side terminal, on the lab server shell, run:

`kubectl scale --replicas=10 -f whoami-deployment.yml` {{ execute }}

Now if you run the curl command again in the left terminal again, you should see that the service automatically starts routing traffic to the new pods without the need for us to make any changes.

You can `exit` out of the Netshoot pod now. We don't need that anymore for now.

### Lab 1b - NodePort

ClusterIP works great for internal access, but what if we want to expose and external port on the nodes for access outside the cluster? That is where NodePort comes in. NodePort will:

* Allow you to define a high port (30000 - 33999) to expose on all nodes
* If a high port is not specifically defined, it will automatically choose one in the (30000 - 33999) to expose the service on

We can also deploy multiple services that reference the same set of pods. Remember, these services are simple selecting the proper pods to target based on `selector` and `label` specification in the manifest files.

Deploy the NodePort service on port 30007 (defined in the file):

`kubectl apply -f nodeport-service.yml` {{ execute }}

Now we can check the Nodeport service externally on your lab server at port 30007.

`for ((i=1;i<=10;i++)); do curl -0 -v http://LABSERVERNAME:30007 2>&1; done | grep Hostname` {{ execute }}

You can also visit the web page, although, due to cookies and cacheing, refreshing the page may show the same pod:

http://LABSERVERNAME:30007

### Cleanup

`kubectl delete -f /ab/labs/container-bootcamp/section-10-labs` {{ execute }}

____

### Congrats! You have completed the Section 10 labs. You may now proceed with the rest of the course.