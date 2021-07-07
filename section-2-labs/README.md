#Section 2 Labs

In this section we learned about:

* Basic Docker Commands
* Docker Images
* Docker Containers
* Docker Run Commands

## Lab 1 - Basic Docker Commands

Now let's practice running some of these commands. Click the burger menu in VSCode and go to `Terminal`, `New Terminal`. We will run all of the following commands in this terminal window.

To see what containers are running on your current system:

`docker ps` or `docker container ls`

To see all containers on the current system, including stopped containers:

`docker ps -a` or `docker container ls -a`

To see all images (read-only container snapshot) on the system:

`docker image ls`

These commands work for `volumes`, `networks` and other components. For a complete list, visit https://docs.docker.com/engine/reference/commandline/docker/.

## Lab 2 - Running Your First Container

Using the information you just learned, lets start and stop your first docker container. We will use nginx, a small web server, for this lab.

Pull the nginx container from Docker Hub (we will cover what Docker Hub and Registries are in the next section of the course).

`docker pull nginx:latest`

Now, lets run an nginx container based on that image:

`docker run -it nginx`

This will run an nginx container and serve the default web page. But notice 2 things:

1. You are locked into the process in the terminal window
2. There is no way to access the web server external to your machine right now

In the same terminal window, click `Ctrl + C` to escape the docker container.

If you run `docker ps -a`, you will see a stopped nginx container with a random name like `funky-rooter`. This was auto assigned because we didn't provide a name. Let's delete this container:

`docker rm funky-rooster` (replace funky rooster with your container name)

Now run it again with 3 new features.

1. A specific name of our choosing using using the `--name` switch
2. A specific external port to expose the container on using `-p`
3. Run the container in the background using the `-d` switch

The new command looks like this:

`docker run -itd --name nginx-sample -p 80:80 nginx`

Now you should be able to access this at http://YOUR-LAB-SERVER-NAME in your browser. It should greet you with "Welcome to nginx!".

Now, let's stop this container.

`docker rm -f nginx-sample`

The web page is no longer available and running `docker ps -a` shows no running nginx containers.

## Lab 3 - Writing and building from a Dockerfile

Let's write a Dockerfile and build our own docker image locally, then we can run it.

In you the `section-2-labs` directory on your lab server, you will see a file called `Dockerfile.example`. For more information on Dockerfiles visit:

* [Dockerfile Best Practices](https://docs.docker.com/engine/reference/builder/)
* [Dockerfile Full Documentation](https://docs.docker.com/engine/reference/builder/)



