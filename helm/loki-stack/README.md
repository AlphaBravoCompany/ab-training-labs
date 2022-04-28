# Helm - Loki Stack Deploy

### In this section we learned about:

* Helm
* Loki Stack

____

## Loki Stack: Lab 1 - Deploying RKE2

### Loki Stack: Lab 1 Links

* [Helm](https://helm.io)
* [Grafana Loki](https://grafana.com/oss/loki/)

____

### Loki Stack: Lab 1 Content

Loki is a horizontally scalable, highly available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.

The Loki project was started at Grafana Labs in 2018, and announced at KubeCon Seattle. Loki is released under the AGPLv3 license.

First, we need to deploy RKE2 on the host. Please make sure no other K8s clusters are running (K3s, RKE, K3d, etc)

`sudo curl -sfL https://get.rke2.io | sudo sh - && sudo systemctl start rke2-server.service && sudo mkdir /ab/kubeconfig && sudo cp /etc/rancher/rke2/rke2.yaml /ab/kubeconfig/rke2.yml && sudo chmod 0644 /ab/kubeconfig/rke2.yml && export KUBECONFIG=/ab/kubeconfig/rke2.yml`  {{ execute }}

You should be able to run the below command and see that the RKE2 server node is in a `READY` state.  This should take approximately `1 minute` to complete.

`kubectl get nodes` {{ execute }}

### Add this RKE2 cluster to the Rancher UI and then deploy Longhorn as shown in the "Rancher Advanced - Day 1 Labs".


## Loki Stack: Lab 2 - Deploy Loki with Helm

Next we will leverage helm to deploy Grafana Loki.

Switch to the proper directory:

`cd /ab/labs/helm/loki-stack` {{ execute }}

Let's preview the `values.yaml` we will use for this deployment. Note, the values files are specific to their respective helm charts.

`./values.yml` {{ open }}

Next, let's deploy the `loki-stack` with Helm.

`helm install loki-stack grafana/loki-stack --values values.yaml -n loki`  {{ execute }}

Once this is complete, we need to apply the ingress so we can reach the Loki UI.

`kubectl apply -f loki-ingress.yaml`  {{ execute }}

Lastly, we need to print the auto generated password for Loki.

`kubectl get secret --namespace loki loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo` {{ execute }}


Now, visit http://grafana-loki.LABSERVERNAME and login with the username `admin` and the password from the command above.

Once there, you can click on `Explore` in the right menu, `Log browser` at the top, and then select the logs you want to see. For example, you can select `Namespaces` and highlight each namespace individually, then click `Show Logs` to see the logs from all namespaces.

____

### Cleanup

`sudo /usr/local/bin/rke2-uninstall.sh` {{ execute }}

____

### Congrats! You have completed the Rancher Fundamentals Loki Stack labs. You may now proceed with the rest of the course.
