# Container Bootcamp - Section 8: Labs

### In this section we learned about:

* [Kubectl Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
* [Kubernetes Deployment and Hosting Options](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

____

## Section 8: Lab 1 - Creating Namespaces and a Pod

### Section 8: Lab 1 Links

* [Kubernetes Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
* [Kubernetes Pods](https://v1-18.docs.kubernetes.io/docs/concepts/workloads/pods/)
* [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get)
* [kubectl run](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#run)
* [kubectl delete](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#delete)

_____

### Section 8: Lab 1 Content

Let's create a namespace and then we can create some resources in that new namespace:

`kubectl create ns training-lab` {{ execute }}

Verify the namespace was created:

`kubectl get ns` {{ execute }}

Create a pod in the `training-lab` namespace:

`kubectl run nginx --image=nginx --restart=Never --namespace=training-lab` {{ execute }}

Verify the pod was created and note what Node it is running on:

`kubectl get pods -n training-lab -o wide` {{ execute }}

Delete the pod:

`kubectl delete pod nginx -n training-lab` {{ execute }}

Verify it was deleted:

`kubectl get pods -n training-lab -o wide` {{ execute }}

_____

## Section 8: Lab 2 - Creating ReplicaSets and Deployments

### Section 8: Lab 2 Links

* [Kubernetes ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
* [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

____

### Section 8: Lab 2 Content

Now let's create a Deployment. As part of the deployment, a ReplicaSet and 3 pods will be created.

Switch to the Section 8 directory where the `nginx-deployment.yml` file is located:

`cd /ab/labs/container-bootcamp/section-7-labs/` {{ execute }}

In VS Code, open the `nginx-deployment.yml` file and review the structure.

Now that we've reviewed the file, let's deploy `nginx-deployment.yml`:

`kubectl apply -f nginx-deployment.yml` {{ execute }}

Let's view the pods that were created:

`kubectl get pods -n training-lab -o wide` {{ execute }}

Notice that it automatically created 3 and distributed them across our worker nodes for fault tolerance.

We can also see that a ReplicaSet was automatically created:

`kubectl get rs -n training-lab` {{ execute }}

The ReplicaSet is ensuring that the number of pods we specific in the manifest file is met.

Let's open a second Terminal in vscode so we can watch the pods. Click the “Split Terminal” button in the upper right of the Terminal window or press `Control+Shift+5`. You should now have 2 windows.

On the right window, run:

`watch kubectl get pods -n training-lab` {{ execute }}

Let's manually scale this deployment to 5 pods. In the left Terminal:

`kubectl scale --replicas=5 -f nginx-deployment.yml` {{ execute }}

We can see the additional pods get added in the right Terminal.

What happens if we delete a pod manually?

Choose a pod name from the `kubectl get pods -n training-lab` command and add it below:

`kubectl delete pod <podname> -n training-lab` {{ execute }}

You can see that the pod we specific get Terminated, but Kubernetes knows we expect 5 pods running, so the control loop automatically reconciles the expected state of 5 pods and starts a new pod in place of the one we deleted.

What happens if we reapply the nginx-deployment.yml?

Let's try running the apply again:

`kubectl apply -f nginx-deployment.yml` {{ execute }}

2 of the pods are immediately Terminated because the manifest file only specifies 3 pods. This illustrates why we should make changes declaratively via our manifest files. If someone were to apply our code again, it will negate our CLI changes.

We could also make changes to the manifest file like the nginx image version and when we apply, Kubernetes will remove the existing pods and replace them with the image version specified.

We can view the image being used in the pod by describing a pod:

`kubectl describe pod <podname> -n training-lab` {{ execute }}

Scroll through the output and you can see that the `Image` is : `nginx:1.14.2`

Let's update the nginx-deployments.yml file on line 20 so that the image is `nginx:1.20.1`.

Now, re-apply the manfest file:

`kubectl apply -f nginx-deployment.yml` {{ execute }}

Notice that the existing Pods are terminated and replaced with pods running the new Image we specified.

To verify this, run the following against one of the new pod names:

`kubectl describe pod <podname> -n training-lab` {{ execute }}

We can also see that because we changed details about this deployment and redeployed, a new ReplicaSet was deployed with the new spec.

Note there are 2 ReplicaSets now:

`kubectl get rs -n training-lab` {{ execute }}

You could use the rollback features of kubectl to move back to the previous replicaset, but again, we recommend using manifest files to make these changes.

In the right window, hit `Ctrl + C` to stop the watch and run the below command to see all resources that our deployment created in the `training-lab` namespace:

`kubectl get all -n training-lab` {{ execute }}

Let's delete this deployment and see all resources get cleaned up:

`kubectl delete -f nginx-deployment.yml` {{ execute }}

Finally, let's close the extra terminal window.  Chose a panel and run the `exit` command.  The extra panel should close and you're back to a single terminal window.

____

#### Congrats! You have completed the Section 8 labs. You may now proceed with the rest of the course.