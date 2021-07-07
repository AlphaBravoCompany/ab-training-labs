# Container Bootcamp - Section 3 Labs

In this section we learned about:

* Dockerfiles
* Docker/Container Registries
* Docker-Compose


## Lab 1 - Building and Running A Container From Dockerfile

Let's write a Dockerfile and build our own docker image locally, then we can run it.

In you the `section-3-labs` directory on your lab server, you will see a file called `Dockerfile.example`. For more information on Dockerfiles visit:

* [Dockerfile Best Practices](https://docs.docker.com/engine/reference/builder/)
* [Dockerfile Full Documentation](https://docs.docker.com/engine/reference/builder/)

Copy `Dockerfile.example` to `Dockerfile` in the same folder.

Next, lets make some changes.

Since centos8 is out, lets change the first line to `FROM centos:8`

And lets make a changes to the default `index.html` file. Open /section-2-labs/index.html and change the text.

Now, we can build and then run this container.

`docker build -t mycontainerimage:latest .`

Once the build is complete, we can run this container image.

`docker run -itd --name mycontainer -p 80:80 mycontainerimage:latest`

Run `docker exec -it mycontainer cat /etc/os-release` to confirm it is centos:8.

Visit http://your-lab-server-name to see your custom index file message.

Let's cleanup.

`docker rm -f mycontainer`.