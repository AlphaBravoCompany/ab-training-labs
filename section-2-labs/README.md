# Section 2 Labs

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

## Lab 3 - Additional Run Options

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

## Lab 4 - Adding Volumes for Persistence

Up until now we have used ephemeral storage (goes away once the container is deleted). Let's add some persistent storage.

There are 2 types of volumes in Docker. Host Mounts and Docker Volumes.

* Host Mount - A path on the system where Docker will store file. Indicated by a full path ie: `/srv/storage/nginx:/usr/share/nginx/html`.
* Docker Volume - A path managed completely by Docker. While it is accessible via a path on the host, it is not intended to be accessed that way. Implemented as `nginx1:/usr/share/nginx/html`.

## Lab 5 Adding Networks

Until now we have used the default network, but let's carve out some networks so that we can control container communications.

First, let's create 2 networks.

`docker network create external`

`docker network create database`

These are 2 separate networks that we can assign to the containers we run. An example for this is if you have 2 external facing containers that you may want to communicate, but only one of them should be able to talk to the database server.

In this example we will use Docker Volumes for each container.

*Nginx Frontend* - Can talk external and to MySQL

`docker run -itd --name nginx1 -v nginx1:/usr/share/nginx/html -p 8080:80 --network="external" alphabravoio/ubuntu-nginx:latest`

`docker network connect database nginx1`

Running `docker container inspect nginx1` will show that this container is now connected to 2 networks.

*Apache Frontened*- Can talk external but not to MySQL

`docker run -itd --name apache1 -v /ab/labs/apache1:/var/www/html -p 8081:80 --network="external" alphabravoio/ubuntu-apache2:latest`

*MySQL Backend* - Can only talk to Nginx and not Apache

`docker run -itd --name mysql1 -v mysql1:/var/lib/mysql --network="database" -e MYSQL_ROOT_PASSWORD=mysecretpassword alphabravoio/ubuntu-mysql:latest`

Confirm that these are all running by checking `docker ps`.

Also confirm that nginx and apache are available externally on your lab server:

* Nginx: http://your-lab-server-name:8080
* Apache: http://your-lab-server-name:8081

## Lab 5 - Exec into containers to test communications

Now that we have 3 containers running, lets `exec` into the containers and test communications to confirm the network separationm is working.

First, lets get a shell in nginx1 and try to ping mysql1.

`docker exec -it nginx1 /bin/bash`

`ping -c 4 mysql1` should succeed because they are both part of the `database` network.

`exit` to escape out of the container shell

This will drop you into the shell of the apache1 container and you can run the ping command to test communication with mysql1.

`docker exec -it apache1 /bin/bash`

`ping -c 4 mysql1` should fail because apache1 is not on the database network and therefore cannot reach the mysql1 container.

`ping -c 4 nginx1` should succeed because they share the `external` network.

`exit` to escape out of the container shell

These commands will ping the nginx1 and apache1 containers from the mysql1 container to show that the same is true to the DB server.

`docker exec -it mysql /bin/bash ping -c 4 nginx1` (succeeds)

`docker exec -it mysql /bin/bash ping -c 4 apache1` (fails)

## Lab 5a - One more container volume interaction.

In case you missed it, we have the apache1 container a Host Path mount instead of a Docker Volume. This allows us to easily manipulate files in that mount point. In this case, we can add our own custom `index.html`.

`echo "I MODIFIED APACHE INDEX FILE VIA DOCKER HOST PATH. YAY" | sudo tee /ab/labs/apache1/index.html`

Now, if you reload http://your-lab-server-name:8081, you will see your page updated without reloading your container.

Let's clean up these containers, volumes and networks before we move on.

`docker rm -f nginx1 mysql1`

Because we added persistence, you will notice that even though the containers are gone, the volumes are still there when you run `docker volume ls`. Let's remove those volumes.

`docker volume rm nginx1 mysql1`

And the Host Path volume for Apache.

`rm -rf /ab/labs/apache1`

And lastly, lets clean up those networks.

`docker network rm external database`

## Lab 6 - Building and Running A Container From Dockerfile

Let's write a Dockerfile and build our own docker image locally, then we can run it.

In you the `section-2-labs` directory on your lab server, you will see a file called `Dockerfile.example`. For more information on Dockerfiles visit:

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

Congrats! You have completed the Section 2 labs. You may now proceed with the rest of the course.