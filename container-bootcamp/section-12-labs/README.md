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

### Section 12: Lab 2 Content

Ingress also MUST support TLS. We recommend never exposing services without TLS in place. The above example is only HTTP, so how can we make it HTTPS? Traefik support LetsEncrypt to automatically generate certificates on demand for your sites, but in this case, lets say that your environment is air-gapped and you need to use a certificate you already have.

First, lets take a look at the annotation we added at the bottom of the `tls-ingress.yml` file. We added `tls` and then a Kubernetes secret (we will talk more about secrets later in the course) that will store the certs.

`./tls-ingress.yml` {{ open }}

Now lets create the secret in the `training-lab` namespace. We have generated a wild card certificate just for your lab server, so we can use that.

`kubectl -n training-lab create secret tls traefik-ui-tls-cert --key=/ab/certs/live/LABSERVERNAME/privkey.pem --cert=/ab/certs/live/LABSERVERNAME/fullchain.pem`

Then, we can apply our new ingress file with TLS support:

`kubectl apply -f tls-ingress.yml`

Once that is done, you should be able to reach a TLS secured version of your NGINX web server. Note that we did not have to modify our application. By properly configuring the ingress, we can add encryption for external traffic coming into our applications without making changes to the application code itself.

`https://tls-nginx.LABSERVERNAME`

**NOTE:** Adding TLS to the Ingress does not secure traffic *inside* the cluster. This requires network policies and service mesh, which are not covered in this course.

----

### Cleanup

`kubectl delete -f /ab/labs/container-bootcamp/section-12-labs`

----

### Congrats! You have completed the Section 12 labs. You may now proceed with the rest of the course.