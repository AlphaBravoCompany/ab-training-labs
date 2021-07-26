# Rancher Advanced: Day 2 - Section 3: Labs

### In this section we learned about:

* Rancher MCM Apps and Marketplace
  * Backups
  * CIS Benchmarks
  * Istio
  * Monitoring

____

**Backups** are a fairly straight forward affair after providing an S3 target bucket and credentials, so there is no lab for that.

**Istio** is on the other end of the spectrum. There is so much more involved in getting Istio properly implemented that that is another course entirely. We just wanted you to be aware that at least the initial installation piece is easily handled by Rancher MCM.

____

## Section 3: Lab 1 - CIS Benchmarks

### Section 3: Lab 1 Links

* [Apps and Marketplace / Helm Charts](https://rancher.com/docs/rancher/v2.5/en/helm-charts/)
* [CIS Benchmarks](https://rancher.com/docs/rancher/v2.5/en/cis-scans/)

____

### Section 3: Lab 1 Content

Rancher can run a security scan to check whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark.

The rancher-cis-benchmark app leverages kube-bench, an open-source tool from Aqua Security, to check clusters for CIS Kubernetes Benchmark compliance. Also, to generate a cluster-wide report, the application utilizes Sonobuoy for report aggregation.

In order for this to work properly and for you to able see the difference in the scans of permissive vs hardened, let's deploy an RKE2 (RKE for Government) cluster again.

Here is a link to the Rancher CIS Benchmark Self Assessment Guide: https://rancher.com/docs/rancher/v2.x/en/security/rancher-2.4/benchmark-2.4/

To deploy the RKE2 cluster, in you lab server terminal window, run:

`sudo curl -sfL https://get.rke2.io | sudo sh - && sudo systemctl start rke2-server.service && sudo cp /etc/rancher/rke2/rke2.yaml /ab/kubeconfig/rke2.yml && sudo chmod 0644 /ab/kubeconfig/rke2.yml && export KUBECONFIG=/ab/kubeconfig/rke2.yml`  {{ execute }}

Go to the Rancher MCM UI and add this as a new cluster called `rke2-cluster`. https://LABSERVERNAME:12443/g/clusters

Let's deploy the CIS Helm Chart and run a scan.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://LABSERVERNAME:12443
2. In the upper left next to the Rancher logo, click the down arrow, then click `rke2-cluster`
3. Click the yellow `Cluster Explorer` button on the upper right
4. Click the down arrow in the upper left and select `Apps and Marketplace`
5. Under "Charts", click `CIS Benchmarks` in the middle of the screen
6. Click the blue `Install` button at the bottom and wait for the install to complete.
7. Click the down arrow in the upper left and select `CIS Benchmark`
8. Click `Create` and for this test, select `rke2-cis-1.6-profile-permissive`. You would select the appropriate test for the type of cluster you are running against and what security posture (permissive or hardened) you expect to scan against.
9. Click blue `Create` button in the bottom right and let the test run. This will take a while, so let this run and come back later to review the results.
10. Once the first scan is complete, click `Create` again and run `rke2-cis-1.6-profile-hardened` and see how the results differ

You can now review and develop policies and automation around cluster deployments that addresses the security concerns identified in the reports.

____

## Section 3: Lab 2 - Monitoring and Alerting

### Section 3: Lab 2 Links

* [Apps and Marketplace / Helm Charts](https://rancher.com/docs/rancher/v2.5/en/helm-charts/)
* [Monitoring and Alerting](https://rancher.com/docs/rancher/v2.5/en/monitoring-alerting/)

### Section 3: Lab 2 Content

Deploying a full monitoring and alerting stack with Rancher MCM is easy as well. Again, this tool is here to ease the initial implentation of these systems. There is still a large amount of planning and implementation that goes into deciding what elements of the cluster and your applications are important to you, what your thresholds are, and what the monitoring and alerting workflow looks like before you can effectively implement a complete solution.

Let's deploy the monitoring and alerting stack that consists of Prometheus, Alertmanager and Grafana.

1. Open the Rancher UI and login using the credentials provided at the beginning of class at https://LABSERVERNAME:12443
2. In the upper left next to the Rancher logo, click the down arrow, then click `rke2-cluster`
3. Click the yellow `Cluster Explorer` button on the upper right
4. Click the down arrow in the upper left and select `Apps and Marketplace`
5. Under "Charts", click `Minitoring` in the middle of the screen
6. There are a large number of options that can be customized for these deployments, but for now, let's just install it with the defaults. Click the blue 'Install' button on the bottom right and wait for the installation to complete.
7. Once complete, click the down arrow in the upper left and select `Monitoring`
8. You will be presented with 5 options. For now, click on `Grafana`
9. One the Grafana home screen you will begin to see metrics start showing up a couple minutes after install showing your the CPU, memory and disk usage of the cluster.
10. Clicking on the 4 boxes on the left and selecting `Manage` will let you see and select from a huge list of pre-defined dashboards that you can start to gather information from and decide on an alerting plan from.

This is also a very complex topic and will take time to understand all of the components of the system. Visit the Rancher links provided and collaborate with your team and AlphaBravo to help develop an action plan for full implementation.
____

### Cleanup

Let's remove the RKE2 cluster as we no longer need it.

`sudo /usr/local/bin/rke2-uninstall.sh` {{ execute }}

____


#### Congrats! You have completed the Rancher Advanced: Day 2 - Section 3 labs. You may now proceed with the rest of the course.