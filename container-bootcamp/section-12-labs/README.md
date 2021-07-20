# Container Bootcamp - Section 12: Labs

### In this section we learned about:

* ConfigMaps
* Secrets

____

## Section 12: Lab 1 - Services

### Section 12: Lab 1 Links

* [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [Kubernetes Secrets](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

____

### Section 12: Lab 1 Content

The cluster we deployed earlier already has Traefik running as part of the default K3d/K3s deployment. Let's create a deployment that leverages that to route traefik to a web server running in our cluster via the CNAME `nginx.LABSERVERNAME`.

Switch to the this lab folder:

`cd /ab/labs/container-bootcamp/section-12-labs/`

First, let's create a ConfigMap. In this case, we will use some basic HTML and mount the configmaps as a volume in NGINX containers.

Create the ConfigMaps called `lab-html`:

`kubectl create configmap lab-html --from-file index-dev.html`


We can deploy a basic NGINX web server deployment, associated ClusterIP Service and an Ingress.

`kubectl apply -f nginx-deployment.yml nginx-service.yml tls-ingress.yml`

Visiting the below link you should see "Hello from the Dev Environment".

https://tls-nginx.LABSERVERNAME

Now imagine we push these manifest over and we are now running them in Prod. Without changing the deployment manifests themselves, we can apply a different ConfigMap with the same name and get an updated result.

`kubectl create configmap lab-html --from-file index-prod.html`

Now if we visit the site, we should be greeted "Hello from the Prod Environment".

https://tls-nginx.LABSERVERNAME

----



### Cleanup

`kubectl delete -f /ab/labs/container-bootcamp/section-12-labs`

----

### Congrats! You have completed the Section 12 labs. You may now proceed with the rest of the course.