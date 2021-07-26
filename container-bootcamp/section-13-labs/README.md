# Container Bootcamp - Section 13: Labs

### In this section we learned about:

* Persistent Storage

____

## Section 13: Lab 1 - Persistent Storage

### Section 13: Lab 1 Links

* [Persisten Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)
* [Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/)

____

### Section 13: Lab 1 Content

Persistent storage is complex. We discuss this topic more in depth in the **Kuberenetes Complete** and **Rancher Fundamentals** course. There are a number of storage providers and ways to config the Storage Classes, etc. For this lab, we will keep it simple and use the `local-path` provisioner built into our local K3d/K3s cluster.

Switch to the this lab folder:

`cd /ab/labs/container-bootcamp/section-13-labs/` {{ execute }}

Take a look at the storage-lab.yml file. You can see we have defined a Persistent Volume (PV), a Persistent Volume Claim (PVC), and a Deployment that mounts that persistent volume.

`./storage-lab.yml` {{ open }}

Let's deploy this:

`kubectl apply -f storage-lab.yml` {{ execute }}

You can view the Pods, PV, and PVC with kubectl:

`kubectl get pv,pvc,pod -n training-lab` {{ execute }}

Let's exec into the pod and create a file on the storage.

`kubectl exec -it -n training-lab $(kubectl get pods -n training-lab -o name | head -n1) -- sh -c "echo 'Hello from the AlphaBravo Lab PV' > /data/hostname.txt"` {{ execute }}

Verify the file was created:

`kubectl exec -it -n training-lab $(kubectl get pods -n training-lab -o name | head -n1) cat /data/hostname.txt` {{ execute }}

Now, let's delete the pod. If we had not mounted persistent storage, the `/data/hostname.txt` file would be gone.

`kubectl delete $(kubectl get pods -n training-lab -o name | head -n1) -n training-lab` {{ execute }}

Query the new pod to see if the `/data/hostname.txt` file still exists:

`kubectl exec -it -n training-lab $(kubectl get pods -n training-lab -o name | head -n1) cat /data/hostname.txt` {{ execute }}

You should see the text "Hello from the AlphaBravo Lab PV" output on the screen.

That is the basics of Persistent Storage. We allow data to persistent longer than the lifecycle of a single pod.


### Cleanup

`kubectl delete -f /ab/labs/container-bootcamp/section-13-labs` {{ execute }}

----

### Congrats! You have completed the Section 13 labs. You may now proceed with the rest of the course.