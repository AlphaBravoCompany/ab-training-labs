# Container Bootcamp - Section 2 Labs

## Please Open this in the Markdown preview mode using the Preview button in the upper right. 

### In this section we learned about:

* Basic Docker Commands
* Docker Images
* Docker Containers
* Docker Run Commands
<br />
<br />

-----
_____

## Lab 1 - Basic Docker Commands

Now let's practice running some of these commands. Click the burger menu in VSCode and go to `Terminal`, `New Terminal`. We will run all of the following commands in this terminal window. To run these commands, you can copy and paste them from the Markdown Preview window into the Terminal in VSCode.

<br />

-----

To see what containers are running on your current system:


`docker ps` {{ execute }}


or 

`docker container ls` {{ execute }}


<br />

-----

To see all containers on the current system, including stopped containers:


`docker ps -a` {{ execute }}

or 

`docker container ls -a` {{ execute }}


<br />

-----

To see all images (read-only container snapshot) on the system:


`docker image ls` {{ execute }}


<br />

-----

To list the volumes: 


`docker volume ls` {{ execute }}


<br />

-----

To list current networks:


`docker network ls` {{ execute }}


<br />

-----

For a complete list:

`docker --help` {{ execute }}


Or visit https://docs.docker.com/engine/reference/commandline/docker/.

<br />
<br />


-----
____

## Lab 2 - Running Your First Container

Using the information you just learned, let's start and stop your first docker container. We will use nginx, a small web server, for this lab.

<br />

-----

Pull the nginx container from Docker Hub (we will cover what Docker Hub and Registries are in the next section of the course):


`docker pull nginx:latest` {{ execute }}


<br />

-----

Now, let's run an nginx container based on that image:


`docker run -it nginx` {{ execute }}


This will run an nginx container and serve the default web page. But notice 2 things:

1. You are locked into the process in the terminal window
2. There is no way to access the web server external to your machine right now

Click on the terminal window, then press `Ctrl + C` to escape the docker container.

<br />

-----

Now, let's find the last created Docker container:

`docker ps -n 1` {{ execute }}

*Note*: Using `-n 1` will list the last executed Docker container.  You can also use `--last 1` to achieve the same result.

After running the command, you will see the last created nginx container with a random name like `funky_rooter`. This dynamically generated name was auto assigned to the container because we didn't specify a name to use. 

<br />

-----

Let's delete this container:


`docker rm funky_rooster` {{ copy }}

*Note*: Replace `funky_rooster` with your container name.

<br />
<br />

-----
____

## Lab 3 - Additional Run Options

Now run it again with 3 new features.

1. A specific name of our choosing using using the `--name` switch
2. A specific external port to expose the container on using `-p`
3. Run the container in the background using the `-d` switch

<br />

-----

Let's create a container with the name `nginx-sample`, assign port `80:80`, and run it in the background using the `-d` switch:


`docker run -itd --name nginx-sample -p 80:80 nginx` {{ execute }}


Now you should be able to access this at http://LABSERVERNAME in your browser. It should greet you with 

**"Welcome to nginx!"**

<br />

-----

Now, let's stop the container using the name `nginx-sample`:


`docker stop nginx-sample` {{ execute }}


Let's try revisiting the URL, http://LABSERVERNAME, in your browser.  It should show an error that the site cannot be reached, indicating the container is stopped and no longer accessable.  

*Note:* You may need to click the refresh button if the **"Welcome to nginx!"** page is still showing, as it may be cached.

<br />

-----

Since the container has been stopped, let's start it again using the name `nginx-sample`:


`docker start nginx-sample` {{ execute }}


<br />

-----

Now, let's stop and delete this container:


`docker rm -f nginx-sample` {{ execute }}


<br />

-----

The container has been deleted, the web page is no longer available.  We can confirm the container has been removed by running:


`docker ps` {{ execute }}


<br />
<br />

-----
_____

## Lab 4 - Adding Volumes for Persistence

Up until now we have used ephemeral storage (goes away once the container is deleted). Let's add some persistent storage.

There are 2 types of volumes in Docker. Host Mounts and Docker Volumes.

* Host/Bind Mount - A path on the system where Docker will store file. Indicated by a full path ie: `/srv/storage/nginx:/usr/share/nginx/html`.
* Docker Volume - A path managed completely by Docker. While it is accessible via a path on the host, it is not intended to be accessed that way. Implemented as `nginx1:/usr/share/nginx/html`.

Lets use the Bind Mount volume to show how you can load a custom `index.html` file into Nginx.

<br />

-----

First, let's deploy Nginx deploying the default `index.html` file:


`docker run -itd --name nginx-novol -p 8080:80 nginx:latest` {{ execute }}


Visit http://LABSERVERNAME:8080 and you should see 

**"Welcome to nginx!"**

<br />

-----

Now lets mount a volume using the custom `index.html` in this lab directory:


`docker run -itd --name nginx-vol -v /ab/labs/container-bootcamp/section-2-labs:/usr/share/nginx/html -p 8081:80 nginx:latest` {{ execute }}


Visit http://LABSERVERNAME:8081 and you should see 

**"Welcome to the AlphaBravo Container Bootcamp!"**

*Note:* This also allows for you to persist data from a container. Deleting the container leaves the `index.html` file intact.

<br />

-----

Run the following command to cleanup:


`docker rm -f nginx-novol nginx-vol` {{ execute }}


<br />
<br />

-----
_____

## Lab 5 Adding Networks

Until now we have used the default network, but let's carve out some networks so that we can control container communications.

<br />

-----

First, let's create 2 networks:


`docker network create external` {{ execute }}


`docker network create database` {{ execute }}


<br />

-----

Let's check to verify the networks have been created successfully:


`docker network ls` {{ execute }}


You should see the `external` and `database` networks in the list provided.

We have created 2 separate networks which can be assigned to the containers we run. An example of this is if you have 2 external facing containers that you may want to communicate with, but only one of them should be able to talk to the database server.

In the following example we will use Docker Volumes for each container.

<br />

-----

*Nginx Frontend*

Create an container called `nginx1` which can use the `external` network:

`docker run -itd --name nginx1 -v nginx1:/usr/share/nginx/html -p 8080:80 --network="external" alphabravoio/ubuntu-nginx:latest` {{ execute }}

Connect to the `nginx1` container to the `database` network:

`docker network connect database nginx1` {{ execute }}


Verify if the container is connected to the `external` and `database` networks:


`docker container inspect nginx1 | jq '.[].NetworkSettings.Networks'` {{ execute }}


<br />

-----

*Apache Frontened*

Create a container called `apache1` which can use the `external` network:


`docker run -itd --name apache1 -v /ab/labs/tmp/apache1:/var/www/html -p 8081:80 --network="external" alphabravoio/ubuntu-apache2:latest` {{ execute }}


<br />

-----

*MySQL Backend*

Create a container called `mysql1` which can use the `database` network:


`docker run -itd --name mysql1 -v mysql1:/var/lib/mysql --network="database" -e MYSQL_ROOT_PASSWORD=mysecretpassword alphabravoio/ubuntu-mysql:latest` {{ execute }}


<br />

-----

Confirm that the three containers are running:

`docker ps -n 3` {{ execute }}


You should have the following container names showing: `mysql1`, `apache1`, and `nginx1`.

Also confirm that nginx and apache are available externally on your lab server:

* Nginx: http://LABSERVERNAME:8080
* Apache: http://LABSERVERNAME:8081

<br />
<br />

-----
____

## Lab 5a - Exec into containers to test communications

Now that we have 3 containers running: `mysql1`, `apache1`, and `nginx1`.  Let's connect to the containers and test communications to confirm the network separation is working.

<br />

-----

First, let's get a shell in `nginx1`:


`docker exec -it nginx1 /bin/bash` {{ execute }}


From the command line inside the container, let's try ping `mysql1`:

`ping -c 4 mysql1` {{ execute }}

The ping test should succeed because both `nginx1` and `mysql1` containers are part of the `database` network.

Let's escape from the `nginx1` container shell:

`exit` {{ execute }}


<br />

-----

Now, let's get a shell in `apache1`:


`docker exec -it apache1 /bin/bash` {{ execute }}


From the command line inside the container, let's try ping `mysql1`:

`ping -c 4 mysql1` {{ execute }}

This command will fail because `apache1` is not on the `database` network and therefore cannot reach the `mysql1` container.

Now lets try pinging the `nginx1` container:

`ping -c 4 nginx1` {{ execute }}

This will succeed because the `apache1` and `nginx1` containers share the `external` network.

Let's escape from the `apache1` container shell:

`exit` {{ execute }}


<br />

-----

These commands will ping the `nginx1` and `apache1` containers from the `mysql1` container to show that the same is true.

This command will succeed:

`docker exec -it mysql1 ping -c 4 nginx1` {{ execute }}

This command will fail:

`docker exec -it mysql1 ping -c 4 apache1` {{ execute }}


<br />
<br />

-----
____

## Lab 5b - One more container volume interaction.

In case you missed it, we have the apache1 container a Bind Mount instead of a Docker Volume. As in Lab 4, this allows us to easily manipulate files in that mount point. In this case, we can live modify our custom `index.html`.

<br />

-----
Run the following from the command line in the terminal:

`echo "<center><h2>I MODIFIED THE APACHE INDEX FILE VIA DOCKER BIND MOUNT.</h2></center>" | sudo tee /ab/labs/tmp/apache1/index.html` {{ execute }}


If you reload http://LABSERVERNAME:8081, you will see your page updated with your new message without reloading your container.

<br />

-----

Let's clean up these containers, volumes and networks before we move on:


`docker rm -f nginx1 mysql1 apache1` {{ execute }}


<br />

-----

Because we added persistence, you will notice that even though the containers are gone, the volumes are still there when you run the command: 

`docker volume ls` {{ execute }}


<br />

-----

Let's remove those volumes:


`docker volume rm nginx1 mysql1` {{ execute }}


<br />

-----

And finally, let's clean up those networks:


`docker network rm external database` {{ execute }}

<br />
<br />

-----
_____

### Congrats! You have completed the Section 2 labs. You may now proceed with the rest of the course.