# Container Bootcamp - Section 2 Labs

## Please Open this in the Markdown preview mode using the Preview button in the upper right. 

### In this section we learned about:

* Basic Docker Commands
* Docker Images
* Docker Containers
* Docker Run Commands

_____

## Lab 1 - Basic Docker Commands

Now let's practice running some of these commands. Click the burger menu in VSCode and go to `Terminal`, `New Terminal`. We will run all of the following commands in this terminal window. To run these commands, you can copy and paste them from the Markdown Preview window into the Terminal in VSCode.

To see what containers are running on your current system:

`docker ps` or `docker container ls`

To see all containers on the current system, including stopped containers:

`docker ps -a` or `docker container ls -a`

To see all images (read-only container snapshot) on the system:

`docker image ls`

To list the volumes: 

`docker volume ls`

To list current networks:

`docker network ls`

For a complete list:
`docker --help` 

Or visit https://docs.docker.com/engine/reference/commandline/docker/.

____

## Lab 2 - Running Your First Container

Using the information you just learned, let's start and stop your first docker container. We will use nginx, a small web server, for this lab.

Pull the nginx container from Docker Hub (we will cover what Docker Hub and Registries are in the next section of the course).

`docker pull nginx:latest`

Now, let's run an nginx container based on that image:

`docker run -it nginx`

This will run an nginx container and serve the default web page. But notice 2 things:

1. You are locked into the process in the terminal window
2. There is no way to access the web server external to your machine right now

Click on the terminal window, then press `Ctrl + C` to escape the docker container.

If you run `docker ps -n 1`, you will see the last created nginx container with a random name like `funky_rooter`. This was auto assigned because we didn't provide a name. Let's delete this container:

`docker rm funky_rooster` (replace funky rooster with your container name)

____

## Lab 3 - Additional Run Options

Now run it again with 3 new features.

1. A specific name of our choosing using using the `--name` switch
2. A specific external port to expose the container on using `-p`
3. Run the container in the background using the `-d` switch

The new command looks like this:

`docker run -itd --name nginx-sample -p 80:80 nginx`

Now you should be able to access this at http://LABSERVERNAME in your browser. It should greet you with "Welcome to nginx!".

Now, let's stop this container.

`docker stop nginx-sample`

Let's try revisiting the URL, http://LABSERVERNAME, in your browser.  It should show an error that the site cannot be reached, indicating the container is stopped and no longer accessable.  Note: You may need to click the refresh button if the "Welcome to nginx!" page is still showing, as it may be cached.

To start the container.

`docker start nginx-sample`

Now, let's stop and delete this container.

`docker rm -f nginx-sample`

The container has been deleted, the web page is no longer available, and running `docker ps -n 1` no longer shows an nginx container.

_____

## Lab 4 - Adding Volumes for Persistence

Up until now we have used ephemeral storage (goes away once the container is deleted). Let's add some persistent storage.

There are 2 types of volumes in Docker. Host Mounts and Docker Volumes.

* Host/Bind Mount - A path on the system where Docker will store file. Indicated by a full path ie: `/srv/storage/nginx:/usr/share/nginx/html`.
* Docker Volume - A path managed completely by Docker. While it is accessible via a path on the host, it is not intended to be accessed that way. Implemented as `nginx1:/usr/share/nginx/html`.

Lets use the Bind Mount volume to show how you can load a custom `index.html` file into Nginx.

First, let's deploy Nginx but just let is deploy the default `index.html` file.

`docker run -itd --name nginx-novol -p 8080:80 nginx:latest`

Visit http://LABSERVERNAME:8080 and you should see "Welcome to nginx!".

Now lets mount a volume using the custom `index.html` in this lab directory.

`docker run -itd --name nginx-vol -v $PWD/container-bootcamp/section-2-labs:/usr/share/nginx/html -p 8081:80 nginx:latest`

Visit http://LABSERVERNAME:8081 and you should see "Welcome to the AlphaBravo Container Bootcamp!".

This also allows for you to persist data from a container. Deleting the container leaves the `index.html` file intact.

Run this for cleanup:

`docker rm -f nginx-novol nginx-vol`

Lab 4 is now complete.

_____

## Lab 5 Adding Networks

Until now we have used the default network, but let's carve out some networks so that we can control container communications.

First, let's create 2 networks.

`docker network create external`

`docker network create database`

Let's check to verify the networks have been created successfully:

`docker network ls`

You should see the external and database networks in the list provided.

We have now created 2 separate networks which can be assigned to the containers we run. An example of this is if you have 2 external facing containers that you may want to communicate with, but only one of them should be able to talk to the database server.

In this example we will use Docker Volumes for each container.

*Nginx Frontend* - Can talk external and to MySQL

`docker run -itd --name nginx1 -v nginx1:/usr/share/nginx/html -p 8080:80 --network="external" alphabravoio/ubuntu-nginx:latest`

`docker network connect database nginx1`

Running `docker container inspect nginx1 | jq '.[].NetworkSettings.Networks'` will show that this container is now connected to 2 networks.

*Apache Frontened*- Can talk external but not to MySQL

`docker run -itd --name apache1 -v /ab/labs/tmp/apache1:/var/www/html -p 8081:80 --network="external" alphabravoio/ubuntu-apache2:latest`

*MySQL Backend* - Can only talk to Nginx and not Apache

`docker run -itd --name mysql1 -v mysql1:/var/lib/mysql --network="database" -e MYSQL_ROOT_PASSWORD=mysecretpassword alphabravoio/ubuntu-mysql:latest`

Confirm that these are all running by checking `docker ps -n 3`.  You should have the following container names showing: mysql1, apache1, and nginx1

Also confirm that nginx and apache are available externally on your lab server:

* Nginx: http://LABSERVERNAME:8080
* Apache: http://LABSERVERNAME:8081

____

## Lab 5a - Exec into containers to test communications

Now that we have 3 containers running, let's `exec` into the containers and test communications to confirm the network separation is working.

First, let's get a shell in nginx1 and try to ping mysql1.

`docker exec -it nginx1 /bin/bash`

`ping -c 4 mysql1` should succeed because they are both part of the `database` network.

In the terminal, type `exit` to escape out of the container shell.

Now let's test from the Apache container:

`docker exec -it apache1 /bin/bash`

This will drop you into the shell of the apache1 container and you can run the ping command to test communication with mysql1.

Now try running the command `ping -c 4 mysql1`.  This command should fail because apache1 is not on the database network and therefore cannot reach the mysql1 container.

Try running the command `ping -c 4 nginx1`. This should succeed because they share the `external` network.

In the terminal, type `exit` to escape out of the container shell.

These commands will ping the nginx1 and apache1 containers from the mysql1 container to show that the same is true to the DB server.

`docker exec -it mysql1 ping -c 4 nginx1` (succeeds)

`docker exec -it mysql1 ping -c 4 apache1` (fails)

____

## Lab 5b - One more container volume interaction.

In case you missed it, we have the apache1 container a Bind Mount instead of a Docker Volume. As in Lab 4, this allows us to easily manipulate files in that mount point. In this case, we can live modify our custom `index.html`.

`echo "I MODIFIED APACHE INDEX FILE VIA DOCKER BIND MOUNT." | sudo tee /ab/labs/tmp/apache1/index.html`

Now, if you reload http://LABSERVERNAME:8081, you will see your page updated without reloading your container.

Let's clean up these containers, volumes and networks before we move on.

`docker rm -f nginx1 mysql1 apache1`

Because we added persistence, you will notice that even though the containers are gone, the volumes are still there when you run `docker volume ls`. Let's remove those volumes.

`docker volume rm nginx1 mysql1`

And the Bind Mount volume for Apache.

`rm -rf /ab/labs/tmp/apache1`

And lastly, let's clean up those networks.

`docker network rm external database`

_____

### Congrats! You have completed the Section 2 labs. You may now proceed with the rest of the course.