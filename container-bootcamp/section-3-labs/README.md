# Container Bootcamp - Section 3: Labs

### In this section we learned about:

* Dockerfiles
* Docker/Container Registries

___

## Section 3: Lab 1 - Building and Running A Container From Dockerfile

### Section 3: Lab 1 Links

* [Dockerfile Best Practices](https://docs.docker.com/engine/reference/builder/)
* [Dockerfile Full Documentation](https://docs.docker.com/engine/reference/builder/)


### Section-3: Lab 1 Content

Let's write a Dockerfile and build our own docker image locally, then we can run it.

In you the `section-3-labs` directory on your lab server, you will see a file called `Dockerfile.example`.

First, lets make sure you are in the right directory.

`cd /ab/labs/container-bootcamp/section-3-labs` {{ execute }}


Copy `Dockerfile.example` to `Dockerfile` in the same folder:


`cp Dockerfile.example Dockerfile` {{ execute }}


<br />

-----

Next, lets make some changes.

Since centos8 is the latest version, lets change the first line in the Dockerfile to `FROM centos:8`.

`/ab/labs/container-bootcamp/section-3-labs/Dockerfile` {{ open }}

Additionally, lets make a changes to the text **"Welcome to the AlphaBravo Container Bootcamp"** in the default `index.html` file. 

`/ab/labs/container-bootcamp/section-3-labs/index.html` {{ open }}

Be sure to save your changes in both files before continuing.


<br />

-----

Now, we can build and then run this container:


`docker build -t mycontainerimage:latest .` {{ execute }}


<br />

-----

Note in the output that the container is built according to the layers indicated in the Dockerfile.

Once the build is complete, we can run this container image:


`docker run -itd --name mycontainer -p 80:80 mycontainerimage:latest` {{ execute }}

<br />

-----

Now let's confirm the release is centos:8.


`docker exec -it mycontainer cat /etc/os-release` {{ execute }}


Visit http://LABSERVERNAME to see your custom index file message.

<br />

-----

Let's cleanup:


`docker rm -f mycontainer` {{ execute }}


<br />
<br />

-----
-----

## Section 3: Lab 2 - Working with Container Registries

### Section 3: Lab 2 Links

* [Docker Hub Quickstart](https://docs.docker.com/docker-hub/)
* [Docker Tag Documentation](https://docs.docker.com/engine/reference/commandline/tag/)
* [Docker Push Documentation](https://docs.docker.com/engine/reference/commandline/push/)

### Section 3: Lab 2 Content

Docker Hub is the the most popular of the online image registries. I would encourage you to create an account at https://hub.docker.com later and try pushing images there.

**BE CAREFUL** Do not push images with private or important information to Docker Hub.

For this course, we have a registry running on the local server at http://localhost:5000. There is no pretty web interface, but it works for our purposes.

### Tagging an image for our registry

Let's retag the image we created in Lab 1 with 2 different tags. Remember, this is the same image and will not be replicated, just tagged differently. The image hash for both will be the same.

<br />


First, let's tag an image with `localhost:5000/mycontainerimage:1.0`:

`docker tag mycontainerimage:latest localhost:5000/mycontainerimage:1.0` {{ execute }}

<br />

-----

Then, let's tag the same image with `localhost:5000/mycontainerimage:latest`:


`docker tag mycontainerimage:latest localhost:5000/mycontainerimage:latest` {{ execute }}


<br />

-----

Let's check to see that even though the tags are different, the image IDs are the same: 


`docker image ls | grep mycontainerimage` {{ execute }}

![Image IDs are the same](./images/container-images.png)

**NOTE:** Your IDs will be different from the ones shown in the example above. However, they should all match one another as shown in the screenshot.

<br />

-----

Now, we can push these images to our local registry:


`docker push localhost:5000/mycontainerimage:1.0` {{ execute }}



`docker push localhost:5000/mycontainerimage:latest` {{ execute }}

**Note:** The first upload takes a long time, but the second is very quick. This is because the registry recognized these were the same image and just needed to add an additional tag to reference one another.


<br />

-----

We can't visit a pretty UI to see these image in our registry, but we can query the http endpoint:


`curl -s -X GET http://localhost:5000/v2/_catalog | jq` {{ execute }}

We can see that `mycontainerimage` is listed.

<br />

-----

Let's query to see what tags there are associated the image:


`curl -s -X GET http://localhost:5000/v2/mycontainerimage/tags/list | jq` {{ execute }}


<br />

-----

Now, delete the local version of these images and run a container with the new tag. You will see the image automatically get downloaded and run.

Delete the current local image:


`docker image rm localhost:5000/mycontainerimage:1.0 localhost:5000/mycontainerimage:latest` {{ execute }}


Create a container from the remote image in the repository:


`docker run -itd --name mycontainer -p 80:80 localhost:5000/mycontainerimage:latest` {{ execute }}

Because we deleted the images locally, they weren't available locally to run the container and they were automatically downloaded from the registry. Note the messages: 

* *Unable to find image 'localhost:5000/mycontainerimage:latest' locally*
* *latest: Pulling from mycontainerimage*


<br />

-----

Let's clean up:


`docker rm -f mycontainer && docker image prune -a -f` {{ execute }}



<br />

-----
-----

### Congrats! You have completed the Section 3 labs. You may now proceed with the rest of the course.

