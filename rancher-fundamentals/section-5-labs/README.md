# Rancher Fundamentals - Section 5: Labs

### In this section we learned about:

* ### Rancher Longhorn Persisent Storage

____

## Section 5: Lab 1 - Deploying Longhorn on RKE

### Section 5: Lab 1 Links

* [Rancher Longhorn](https://rancher.com/products/longhorn/)
____

### Section 5: Lab 1 Content

In this section we learned about how powerful an integrated storage solution is to building a robust Kubernetes cluster.

Let's see how easy it is to deploy Longhorn. With the proper host configuration, this should be the same on any Kubernetes cluster you are running.

*NOTE: This will not work on our K3d/K3s development cluster due to it's dev focused nature and some underlying technical hurdles.*

Let's deploy Longhorn from the Rancher UI onto our RKE cluster.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://LABSERVERNAME:12443
2. In the upper left next to the Rancher logo, click the down arrow, then click `rke-cluster`
3. Click the yellow `Cluster Explorer` button on the upper right
4. Click the down arrow in the upper left and select `Apps and Marketplace`
5. Under `Charts`, click `Longhorn` in the middle of the screen
6. You could configure this cluster with additional options in the bottom section with the options under `README`, but for this lab, simply click the blue `Install` button on the bottom right
7. A terminal window will show up on the bottom showing the progress of the installation. When you see `Longhorn is now installed on the cluster!`, the install is complete and ready for use. 
8. To access the Longhorn UI, click the down arrow in the upper left and select `Longhorn`.
9. Click the `Longhorn - Manage storage system via UI` and a new tab will open.

You can now explore the Longhorn UI. This is where you can configure the additional options for the Longhorn system and see the storage and volumes currently running.

____

## Section 5: Lab 2 - Creating a Pod with a PV on Longhorn

### Section 5: Lab 2 Links

* [Rancher Longhorn](https://rancher.com/products/longhorn/)
____

### Section 5: Lab 2 Content

Let's deploy a basic NGINX pod that will use the Longhorn Persistent storage.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://LABSERVERNAME:12443
2. In the upper left next to the Rancher logo, click the down arrow, then click `rke-cluster`, and `Default`. You should now be on the `Workloads` tab. 
3. Click the blue `Deploy` button in the upper right
4. Provide the following details:
  * Name: `nginx`
  * Docker Image: `nginx:latest`
  * Under Volumes, click "Add Volume", "Add new persistent volume (claim)" 
  * In the "Add Volume Claim" pop up:
    * Name: `nginx-volume`
    * Storage Class: `longhorn`
    * Requested Storage: `1`
    * Click "Define"
  * Mount Point: `/data`
5. Click `Launch`
6. Wait for the nginx deployment to have a `State` of `Active`
7. Navigate back to the Longhorn UI and click on "Volume" at the top
8. You should see a 1Gi volume Bound to the nginx pod. 

You will also note that it is `Degraded` and clicking on the volume name will show you that while it has a single replica, it is expecting to be able to create 3 replicas. This is the default setting for Longhorn and recommended to provide resilience in the event of a worker node failure.

In our case, we have a single node lab cluster, so this cannot be rectified. In a full cluster deployment, you should see 3 replicas created on separate nodes for high availability.

Well done. You have now completed the Longhorn Storage labs.

___

### Cleanup

We no longer need RKE and it will conflict with future labs, so lets remove the RKE cluster.

`cd /ab/labs/rancher-fundamentals/section-4-labs && rke remove` {{ execute }}

and enter: `y`

Back on the Rancher UI at https://LABSERVERNAME:12443/g/clusters, you will see that the cluster `rke-cluster` is now failing health checks. If this cluster shouldn't be failing or unreachable by the Rancher UI, this would be an indicator to investigate why the Rancher UI and target cluster aren't able to communicate. Since we intentionally uninstalled the RKE cluster, we can go ahead and remove it from the UI.

Let's remove the failing cluster.  Click the ellipses on the right next to the `rke-cluster` and select `Delete` from the menu. 

____

#### Congrats! You have completed the Rancher Fundamentals Section 5 labs. You may now proceed with the rest of the course.
