# Container Bootcamp - Section 11: Labs

### In this section we learned about:

* Ingress

____

## Section 11: Lab 1 - Services

### Section 11: Lab 1 Links

* [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

____

### Section 11: Lab 1 Content

The cluster we deployed earlier already has Traefik running as part of the default K3d/K3s deployment. Let's create a deployment that leverages that to route traefik to a web server running in our cluster via the CNAME `nginx.LABSERVERNAME`.

Switch to the this lab folder:

`cd /ab/labs/container-bootcamp/section-11-labs/` {{ execute }}

First, we can deploy a basic NGINX web server deployment and an associated ClusterIP Service.

`kubectl apply -f nginx-deployment.yml` {{ execute }}

`kubectl apply -f nginx-service.yml` {{ execute }}

Where it gets interesting is with a new type of manifest file that specifies the `Ingress` type, and the Ingress controller to be used. Take a look at the following file, then we can apply it.

`./ingress.yml` {{ open }}

Now let's apply the ingress:

`kubectl apply -f ingress.yml` {{ execute }}

Because the ingress controller understand domain names and service routing, it can translate an incoming request to a valid domain and pass it to the proper service, which in turn send the traffic to the proper set of pods. Now that we have these pieces in place, you should be able to reach your NGINX deployment from the web browser:

http://nginx.LABSERVERNAME

----

### Section 11: Lab 2 Content

Ingress also MUST support TLS. We recommend never exposing services without TLS in place. The above example is only HTTP, so how can we make it HTTPS? Traefik support LetsEncrypt to automatically generate certificates on demand for your sites, but in this case, lets say that your environment is air-gapped and you need to use a certificate you already have.

First, lets take a look at the annotation we added at the bottom of the `tls-ingress.yml` file. We added `tls` and then a Kubernetes secret (we will talk more about secrets later in the course) that will store the certs.

`./tls-ingress.yml` {{ open }}

Now lets create the secret in the `training-lab` namespace. We have generated a wild card certificate just for your lab server, so we can use that.

`kubectl -n training-lab create secret tls traefik-ui-tls-cert --key=/ab/certs/live/LABSERVERNAME/privkey.pem --cert=/ab/certs/live/LABSERVERNAME/fullchain.pem` {{ execute }}

Then, we can apply our new ingress file with TLS support:

`kubectl apply -f tls-ingress.yml` {{ execute }}

Once that is done, you should be able to reach a TLS secured version of your NGINX web server. Note that we did not have to modify our application. By properly configuring the ingress, we can add encryption for external traffic coming into our applications without making changes to the application code itself.

https://tls-nginx.LABSERVERNAME

**NOTE:** Adding TLS to the Ingress does not secure traffic *inside* the cluster. This requires network policies and service mesh (like Istio), which are not covered in this course.

----

### Cleanup

`kubectl delete -f nginx-deployment.yml nginx-service.yml` {{ execute }}

____

### Congrats! You have completed the Section 11 labs. You may now proceed with the rest of the course.