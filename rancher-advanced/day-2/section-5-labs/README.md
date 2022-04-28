# Rancher Advanced: Day 2 - Section 5: Labs

### In this section we learned about:

* Rancher MCM MultiCluster Continuous Delivery

## Section 5: Lab 1

### Section 5: Lab 1 Links

* [Fleet](https://rancher.com/docs/rancher/v2.6/en/deploy-across-clusters/fleet/)
____

### Section 5: Lab 1 Content

Rancher Continuous Delivery leverage Fleet to install and update deployments in your cluster.

Fleet is GitOps at scale. Fleet is designed to manage up to a million clusters. It’s also lightweight enough that it works great for a single cluster too, but it really shines when you get to a large scale. By large scale we mean either a lot of clusters, a lot of deployments, or a lot of teams in a single organization.

Fleet is a separate project from Rancher, and can be installed on any Kubernetes cluster with Helm.

In this exercise, we will use use the Rancher MCM Continuous Delivery functionality under the Cluster Explorer to deploy to 2 separate clusters simultaneously.

First, let's add the K3d clusters we created from yesterday to the Rancher MCM UI. We are not going to be verbose, so look at this as a bit of challenge. We will give you a couple of hints. You will need to make sure you are in the proper context when applying the commands Rancher MCM provides. To switch context:

`lab-cluster1`
`kubectl config use-context k3d-lab-cluster1` {{ execute }}

`lab-cluster2`
`kubectl config use-context k3d-lab-cluster2` {{ execute }}

____

Now, let's deploy using the Rancher MCM Continuous Delivery feature to both clusters.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://rancher-LABSERVERNAME
2. In the upper left next to the Rancher logo, click the down arrow, then click `lab1-cluster`
3. Click the yellow `Cluster Explorer` button on the upper right
4. Click the down arrow in the upper left and select `Continuous Delivery`
5. On the `Git Repos` tab, click `Create`
6. You could enter all these details manually, but you can also provide a configuration in YAML format. We will use YAML in this case. Click the `Edit as YAML` button in the bottom right.
7. Open the following file and paste the contents of that file into the YAML window in Rancher MCM, replacing all of the other content, and then click the blue `Create` button in the bottom right

`/ab/labs/rancher-advanced/day-2/section-5-labs/ranchercd.yml` {{ open }}

8. On the `Continuous Delivery` menu on the right, click `Clusters`. You should see both `lab-cluster1` and `lab-cluster2` listed.
9. Click on 3 dots on the right of `lab-cluster1` and select `Edit Config`.
10. Under `Labels`, click `Add Label`. Under `Key` put `env`. Under `Value` put `dev`. Click the blue `Save` button in the bottom right. These tags are identifiers so Fleet knows where it should deploy a specific configuration of an application.
11. Repeat steps 9-10 on `lab-cluster2`
12. Click on the `Git Repos` menu again, and under the repo we added, we should see the `State` as `Active` and the `Clusters Ready` as `2`. This means that the deployment has seen the proper tags on those clusters, and that the application is deployed as expected.
13. We can confirm that we see these apps running.  Click the drop down menu in the top left corner and select `Cluster Explorer`. In the upper right, make sure you have `lab-cluster1` selected. Once the page has loaded, find `Pods` in the menu on the left and select it.  Once this page has loaded, select `fleet-mc-helm-example` from the Namespace drop down menu at the top of the page.  You should see 2 pods: `frontend` and `redis`.
14. In the upper right corner, select the cluster dropdown menu (currently showing `lab-cluster1`).  Select `lab-cluster2` from the list.  This will reload the `Cluster Explorer`.  Select `Pods` on the menu in the far left.  You will see `frontend` and `redis` running on this cluster as well.

____

## Section 5: Lab 2 - Creating Ingress

### Section 5: Lab 2 Links

* [Traefik Ingress](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)

### Section 5: Lab 2 Content

Now we have an application running in 2 clusters, but no one externally can reach it. If you will recall, Rancher K3s ships with Traefik as its Ingress Controller and the Ingress controllers whole job is to expose HTTP and HTTPS traffic externally to the cluster.

Let's create an Ingress rule on each cluster to point to the `frontend` service.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://rancher-LABSERVERNAME
2. In the upper left next to the Rancher logo, click the down arrow, then click `lab1-cluster`
3. Click the yellow `Cluster Explorer` button on the upper right.
4. On the left menu under `Service Discovery` click `Ingresses`.
5. In the upper right, click the blue `Create` button.
6. Fill in the fields.
    * Namespace: `fleet-mc-helm-example`
    * Name: `guestbook`
    * Request Host: `guestbook.LABSERVERNAME`
    * Path: Leave as prefix. Enter the value: `/`
    * Target Service: Select `frontend` from the dropdown
    * Port: Select `80` from the dropdown
7. Click the blue `Create` button in the bottom right.
8. In the upper right, switch to the `lab-cluster2` from the dropdown.
9. Perform the same steps 4-7 on `lab-cluster2` and you did for `lab-cluster1`. Use all of the same values.

Now that we have created the Ingress routes defined, we can visit the cluster at the address we defined.

http://guestbook.LABSERVERNAME

There is a caching feature and a short duration cookie in place. But if you refresh every 10 seconds or so, you should see the `PodIP` and `PodName` change.

We are actually load balancing through the HAProxy instance we set up yesterday to the frontend pods in 2 separate K3s clusters, which is why the `PodIP` and `PodName` change when we refresh the page.

____

## Section 5: Lab 3 - Simulating Cluster Failure

### Section 5: Lab 3 Links

* [Traefik Ingress](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)

### Section 5: Lab 3 Content

Now we have, at least for the sake of this lab environment, a highly available multi Kubernetes cluster configuration. Here is the configuration we have.

* We deployed multiple clusters easily using Rancher K3d/K3s
* The clusters are behind a load balancer (HAProxy)
* Continuous Delivery / Fleet has now deployed an application to both of our clusters automatically
* Ingress has been deployed on both clusters that points to our `frontend` service

It is time to simulate the failure of a cluster. First, run the below command to see the distribution of traffic. You should see roughly a 50/50 split between 2 PodIPs.

`for ((i=1;i<=10;i++)); do curl -0 -v http://guestbook.LABSERVERNAME 2>&1; done | grep PodName | awk -F " " {' print $1 '} | awk -F "=" {' print $2 '} | awk -F "<" {' print $1 '} | sort | uniq -c | column -t` {{ execute }}

Let's open up our load balancer view so we can watch what our cluster health.

http://LABSERVERNAME:9090/stats

And login with the following credentials:
**User:** admin
**Pass:** changemeplease!!

Now, in your terminal on you lab-server, stop your `lab-cluster2`

`k3d cluster stop lab-cluster2` {{ execute }}

Check back on the HAProxy web UI and note that the load balancer has now taken the `lab-cluster2` offline and it is showing as red.

Visit the guestbook page again and refresh a few times:

http://guestbook.LABSERVERNAME

Run the curl test again:
`for ((i=1;i<=10;i++)); do curl -0 -v http://guestbook.LABSERVERNAME 2>&1; done | grep PodName | awk -F " " {' print $1 '} | awk -F "=" {' print $2 '} | awk -F "<" {' print $1 '} | sort | uniq -c | column -t` {{ execute }}

Note that all traffic is now returning from a single PodIP on the cluster that is still online.

With some straight forward cluster configuration, multi-cluster Gitops deployments, and some robust infrastructure engineering, our application was able to survive an entire cluster failure without impacting our customer facing services.

Let's bring `lab-cluster2` back online for the final lab.

`k3d cluster start lab-cluster2` {{ execute }}

Make sure you see it turn green in the HAProxy web interface.
____

## Section 5: Lab 4 - Continuous Delivery Updates and Cluster "Tiers" (Dev/Test/Prod/etc)

### Section 5: Lab 4 Links

* [Traefik Ingress](https://doc.traefik.io/traefik/providers/kubernetes-ingress/)

### Section 5: Lab 4 Content

Updating application can often be a struggle and consume large amounts of time between the developer and infrastrucute teams. With Gitops, the Continuous Delivery system is able to monitor the Git repo for changes and automatically apply them when updates are published a specific branch.

Unfortunately to demonstrate that, you all would have to have your own, editable version of the guestbook git repo to make changes to.

Since we can't do that easily, let's do the next best thing and see how based on the simple but powerful tagging capability of Fleet, we can easily and automatically update our deployment and leverage different configurations per cluster type/label.

First, visit the guestbook site a few times to make sure we are seeing the traffic switching back and forth.

http://guestbook.LABSERVERNAME

Now, imagine that `lab-cluster1` is `dev`, and `lab-cluster2` is `prod`. Let's update `lab-cluster2` to reflect that in `Continuous Delivery`.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://rancher-LABSERVERNAME
2. In the upper left next to the Rancher logo, click the down arrow, then click `lab1-cluster`
3. Click the yellow `Cluster Explorer` button on the upper right
4. Click the down arrow in the upper left and select `Continuous Delivery`
5. On the `Continuous Delivery` menu on the right, click `Clusters`. You should see both `lab-cluster1` and `lab-cluster2` listed
6. Click on 3 dots on the right of `lab-cluster2` and select `Edit Config`
7. Under `Labels`, edit the `Value` next to be `prod`. Click the blue `Save` button in the bottom right.
8. In the upper right, click the dropdown and select `Cluster Explorer`. In the top left, click the dropdown and select `lab-cluster2`
9. Under `Ingresses` on the left side menu, click the 3 dots next to the `guestbook` ingress and select `Edit Config`
10. Change the `Request Host` to be `hello.LABSERVERNAME` and click the blue `Save` button in the bottom right.

We have now separated our clusters from being HA to being more of a `Dev` and `Prod` environment setup, at least with the respect to what Fleet is deploying to each.

Now, if we visit the guestbook link on the Dev cluster, we should see the Guestbook app:

http://guestbook.LABSERVERNAME

After a `2 minutes` you should be able to visit the `hello` link on the Prod cluster, we should see the `Hello from AlphaBravo Training`.

http://hello.LABSERVERNAME


Not only does Continuous Delivery / Fleet allow us to deploy the SAME configuration across multiple clusters from the same source code repo, it can also deploy a DIFFERENT configuration from the same source code repo to DIFFERENT tiers of clusters, all from a single configuration item.

Thanks so much for joining us for this training. Please reach out to us with any questions or clarity on what you have learned here.

Also, please contact AlphaBravo if you would like engineering and implementation services around Kubernetes, Cloud and DevSecOps.

* **Web:** https://alphabravo.io
* **Email:** info@alphabravo.io
* **Phone:** 301-337-8141

____

#### Congrats! You have completed the Rancher Advanced: Day 2 - Section 5 labs. You have completed Rancher Advanced training!