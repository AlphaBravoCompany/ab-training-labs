# Rancher Advanced: Day 1 - Section 2: Labs

### In this section we learned about:

* RKE2 - Rancher Government

____

## Section 2: Lab 1 - Deploying RKE2

### Section 2: Lab 1 Links

* [RKE2](https://docs.rke2.io/)

____

### Section 2: Lab 1 Content

RKE2, also known as RKE Government, is Rancher's next-generation Kubernetes distribution.

It is a fully conformant Kubernetes distribution that focuses on security and compliance within the U.S. Federal Government sector.

To meet these goals, RKE2 does the following:

* Provides defaults and configuration options that allow clusters to pass the CIS Kubernetes Benchmark v1.5 or v1.6with minimal operator intervention
* Enables FIPS 140-2 compliance
* Regularly scans components for CVEs using trivy in our build pipeline

The below commands a few things that make it easy to setup a single node RKE2 deployment and provide us `kubectl` access:

* Runs the RKE2 installer script
* Starts the RKE2 server service
* export the RKE2 kubeconfig file and marks it as readable by a non-root user
* Sets the `KUBECONFIG` environmental variable to use the exported kubeconfig file

Ok, let's run this command:

`sudo curl -sfL https://get.rke2.io | sudo sh - && sudo systemctl start rke2-server.service && sudo cp /etc/rancher/rke2/rke2.yaml /ab/kubeconfig/rke2.yml && sudo chmod 0644 /ab/kubeconfig/rke2.yml && export KUBECONFIG=/ab/kubeconfig/rke2.yml`  {{ execute }}

You should be able to run the below command and see that the RKE2 server node is in a `READY` state.  This should take approximately `1 minute` to complete.

`kubectl get nodes` {{ execute }}

You could, as in previous labs, add this RKE2 cluster to the Rancher UI and even deploy Longhorn if you like.

The steps to expand this this out to a full HA deployment are more involved, but still straight forward. https://docs.rke2.io/install/ha/

Additionally, leveraging automation like Terraform and Ansible will allow you easily and repeatable deploy, expand and upgrade clusters to any environment you need.

____

### Cleanup

`sudo /usr/local/bin/rke2-uninstall.sh` {{ execute }}

____

### Congrats! You have completed the Rancher Fundamentals Section 2 labs. You may now proceed with the rest of the course.
