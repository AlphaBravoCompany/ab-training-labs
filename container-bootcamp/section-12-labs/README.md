# Container Bootcamp - Section 12: Labs

### In this section we learned about:

* ConfigMaps
* Secrets

____

## Section 12: Lab 1 - ConfigMaps

### Section 12: Lab 1 Links

* [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/services-networking/ingress/)

____

### Section 12: Lab 1 Content

The cluster we deployed earlier already has Traefik running as part of the default K3d/K3s deployment. Let's create a deployment that leverages that to route traefik to a web server running in our cluster via the CNAME `nginx.LABSERVERNAME`.

Switch to the this lab folder:

`cd /ab/labs/container-bootcamp/section-12-labs/`

First, let's create a ConfigMap. In this case, we will use some basic HTML and mount the configmaps as a volume in NGINX containers.

Create the ConfigMaps called `lab-html`:

`kubectl create configmap lab-html -n training-lab --from-file index-dev.html`

We can deploy a basic NGINX web server deployment, associated ClusterIP Service and an Ingress.

`kubectl apply -f nginx-deployment.yml -f nginx-service.yml -f tls-ingress.yml`

Visiting the below link you should see "Hello from the Dev Environment".

https://tls-nginx.LABSERVERNAME

Now imagine we push these manifest over and we are now running them in Prod. Without changing the deployment manifests themselves, we can apply a different ConfigMap with the same name and get an updated result.

`kubectl create configmap lab-html -n training-lab --from-file index-prod.html`

Now if we visit the site, we should be greeted "Hello from the Prod Environment".

https://tls-nginx.LABSERVERNAME

____

## Section 12: Lab 2 - Secrets

____

### Section 12: Lab 1 Links

* [Kubernetes Secrets](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

____

### Section 12: Lab 2 Content

Back in Section 11 we created a secret for TLS secrets. There is actually a specific type Kubernetes secret that is just to support TLS.

We can also just create a secret that is a basic opaque password that could be used as a password.

First, lets just create a secret and mount it in a container, and take a look at how it shows within the container context.

`kubectl create secret generic lab-secret --from-file auth -n training-lab`

We can view the contents of the secret via kubectl. Note that it is base64 encoded. Encoded is NOT Encrypted.

`kubectl get secret -n training-lab lab-secret -o jsonpath="{.data.auth}"`

We can actually decode it as an administrator from kubectl by piping to a decode command:

`kubectl get secret -n training-lab lab-secret -o jsonpath="{.data.auth}" | base64 --decode`

Now, lets deploy an NGINX web server pod and exec into the container:

`kubectl apply -f nginx-pod.yml`

`kubectl exec -it -n training-lab nginx -- /bin/bash`

Now let's view how the secret is presented in the pod.

`cat /etc/secrets/auth`

Type `exit` to escape the Pod.

Now that we have a bit more insight into secrets and mounting them, let's use the existing lab-secret and update our ingress from last lab to support basic authentication using our new secret. In this case, it is leveraging a Custom Resource Definition and annotation supported by Traefik Ingress, so we dont need to add a secret mount inside the container.

`kubectl apply -f tls-auth-ingress.yml`

Now when we visit that page, we are prompted to enter a username and password based on the secret we created. When prompted, enter `admin` for the username and `password123` for the password.

https://tls-auth-nginx.LABSERVERNAME


### Cleanup

`kubectl delete -f /ab/labs/container-bootcamp/section-12-labs`

----

### Congrats! You have completed the Section 12 labs. You may now proceed with the rest of the course.