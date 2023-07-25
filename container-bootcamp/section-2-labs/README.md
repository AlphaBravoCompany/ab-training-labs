# Container Bootcamp - Section 2 Labs

### In this section we learned about:

* Basic Docker Commands
* Docker Images
* Docker Containers
* Docker Run Commands

<br />
<br />

---
---

## Lab Environment Setup
1. In this VSCode window, look for the 'burger' menu in the upper left corner of the window. The menu typically appears as three stacked horizontal lines.

2. Navigate through this menu, clicking on `Terminal`, then `New Terminal`. This action will bring up a new terminal window at the bottom of the VSCode environment.

3. All commands mentioned in this guide will be executed within this terminal window. To run these commands, you can do one of the following:

    * Type the commands in manually. This is the recommended method, as it will help build your muscle memory for the commands.

    * Copy and paste the commands from this guide into the terminal window. To copy, highlight the text you wish to copy, then right-click and select Copy. To paste, right-click and select Paste.

    * Click on the `Execute` button next to the command. This will automatically copy and paste the command into the terminal window and execute it.

<br/>
<br/>

---
---

## Lab 1 - Basic Docker Commands

It's time to put theory into practice by running some of the commands we learned about during our training session.

To see what containers are running on your current system:


`docker ps` {{ execute }}

or

`docker container ls` {{ execute }}

<br/>

---

<br/>

To see all containers on the current system, including stopped containers:


`docker ps -a` {{ execute }}

or

`docker container ls -a` {{ execute }}


<br/>

---

<br/>

To see all images (read-only container snapshot) on the system:


`docker image ls` {{ execute }}


<br/>

---

<br/>

To list the volumes:


`docker volume ls` {{ execute }}


<br/>

---

<br/>

To list current networks:


`docker network ls` {{ execute }}


<br/>

---

<br/>

For a complete list of commands:

`docker --help` {{ execute }}


> **NOTE:**<br/>A complete list of commands can be found at [the Docker command line documentation page](https://docs.docker.com/engine/reference/commandline/).


<br/><br/>

---
---

## Lab 2 - Running Your First Container

Using the information you just learned, let's start and stop your first docker container. We will use nginx, a small web server, for this lab.

<br/>

---

<br/>

Pull the nginx container from Docker Hub (we will cover what Docker Hub and Registries are in the next section of the course):


`docker pull nginx:latest` {{ execute }}


<br/>

---

<br/>

Now, let's run an nginx container based on that image:


`docker run -it nginx` {{ execute }}


This will run an nginx container and serve the default web page. But notice 2 things:

1. You are locked into the process in the terminal window
2. There is no way to access the web server external to your machine right now

Click on the terminal window, then press `Ctrl+C` to escape the docker container.

<br/>

---

<br/>

Now, let's find the last created Docker container:

`docker ps -n 1` {{ execute }}

> **NOTE:**<br/>Using `-n 1` will list the last executed Docker container.  You can also use `--last 1` to achieve the same result.

After running the command, you will see the last created nginx container with a random name like `funky_rooster`. This dynamically generated name was auto assigned to the container because we didn't specify a name to use.

<br/>

---

<br/>

Let's delete this container:


`docker rm funky_rooster`

> **NOTE:**<br/>Replace `funky_rooster` with your container name.

<br />
<br />

---
---

## Lab 3 - Additional Run Options

Now run it again with 3 new features.

1. A specific name of our choosing using using the `--name` switch
2. A specific external port to expose the container on using `-p`
3. Run the container in the background using the `-d` switch

<br/>

---

<br/>

Let's create a container with the name `nginx-sample`, assign port `80:80`, and run it in the background using the `-d` switch:


`docker run -itd --name nginx-sample -p 80:80 nginx` {{ execute }}


Now you should be able to access this at http://LABSERVERNAME in your browser. It should greet you with

**"Welcome to nginx!"**

<br/>

---

<br/>

Now, let's stop the container using the name `nginx-sample`:


`docker stop nginx-sample` {{ execute }}


Let's try revisiting the URL, http://LABSERVERNAME, in your browser.  It should show an error that the site cannot be reached, indicating the container is stopped and no longer accessible.

> **NOTE:**<br/>You may need to click the web browser refresh button if the **"Welcome to nginx!"** page is still showing, as it may be cached.

<br/>

---

<br/>

Since the container has been stopped, let's start it again using the name `nginx-sample`:


`docker start nginx-sample` {{ execute }}


<br/>

---

<br/>

Now, let's stop and delete this container:


`docker rm -f nginx-sample` {{ execute }}


<br/>

---

<br/>

The container has been deleted, the web page is no longer available.  We can confirm the container has been removed by running:


`docker ps` {{ execute }}


<br/>
<br/>

---
---

## Lab 4 - Adding Volumes for Persistence

Up until now we have used ephemeral storage (goes away once the container is deleted). Let's add some persistent storage.

There are 2 types of volumes in Docker. Host Mounts and Docker Volumes.

* **Host/Bind Mount**<br/>
A path on the system where Docker will store file. Indicated by a full path ie: `/srv/storage/nginx:/usr/share/nginx/html`.

* **Docker Volume**<br/>
A path managed completely by Docker. While it is accessible via a path on the host, it is not intended to be accessed that way. Implemented as `nginx1:/usr/share/nginx/html`.

Lets use the Bind Mount volume to show how you can load a custom `index.html` file into Nginx.

<br/>

---

<br/>

First, let's deploy Nginx deploying the default `index.html` file:


`docker run -itd --name nginx-novol -p 8080:80 nginx:latest` {{ execute }}


Visit http://8080-LABSERVERNAME and you should see:

**"Welcome to nginx!"**

<br/>

---

<br/>

Now lets mount a volume using the custom `index.html` in this lab directory:


`docker run -itd --name nginx-vol -v /ab/labs/container-bootcamp/section-2-labs:/usr/share/nginx/html -p 8081:80 nginx:latest` {{ execute }}


Visit http://8081-LABSERVERNAME and you should see:

**"Welcome to the AlphaBravo Container Bootcamp!"**

> **NOTE:**<br/>This also allows for you to persist data from a container. Deleting the container leaves the `index.html` file intact.

<br/>

---

<br/>

Run the following command to cleanup:


`docker rm -f nginx-novol nginx-vol` {{ execute }}


<br/>
<br/>

---
---

## Lab 5 - Adding Networks

Until now we have used the default network, but let's carve out some networks so that we can control container communications.

<br/>

---

<br/>

First, let's create 2 networks:


`docker network create external` {{ execute }}


`docker network create database` {{ execute }}


<br/>

---

<br/>

Let's check to verify the networks have been created successfully:


`docker network ls` {{ execute }}


You should see the `external` and `database` networks in the list provided.

> **NOTE:**<br/>We have engineered two distinct networks that can be assigned to the containers we operate. Imagine a scenario where you possess two external-facing containers that you wish to interface with. However, for security or operational reasons, you may want only one of these containers to establish communication with the database server. In such a situation, our dual-network system can be particularly useful.

In the following example we will use Docker Volumes for each container.

<br/>

---

<br/>

### NGINX Frontend

Create an container called `nginx1` which can use the `external` network:

`docker run -itd --name nginx1 -v nginx1:/usr/share/nginx/html -p 8080:80 --network="external" alphabravoio/ubuntu-nginx:latest` {{ execute }}

<br/>

---

<br/>

Connect to the `nginx1` container to the `database` network:

`docker network connect database nginx1` {{ execute }}

<br/>

---

<br/>

Verify if the container is connected to the `external` and `database` networks:


`docker container inspect nginx1 | jq '.[].NetworkSettings.Networks'` {{ execute }}


<br/>

---

<br/>

### Apache Frontend

Create a container called `apache1` which can use the `external` network:


`docker run -itd --name apache1 -v /ab/labs/tmp/apache1:/var/www/html -p 8081:80 --network="external" alphabravoio/ubuntu-apache2:latest` {{ execute }}


<br/>

---

<br/>

### MySQL Backend

Create a container called `mysql1` which can use the `database` network:


`docker run -itd --name mysql1 -v mysql1:/var/lib/mysql --network="database" -e MYSQL_ROOT_PASSWORD=mysecretpassword alphabravoio/ubuntu-mysql:latest` {{ execute }}


<br/>

---

<br/>

Confirm that the three containers are running:

`docker ps -n 3` {{ execute }}


You should have the following container names showing: `mysql1`, `apache1`, and `nginx1`.

Also confirm that nginx and apache are available externally on your lab server:

* Nginx: http://8080-LABSERVERNAME
* Apache: http://8081-LABSERVERNAME

<br/>
<br/>

---
---

## Lab 5a - Exec into containers to test communications

Now that we have 3 containers running: `mysql1`, `apache1`, and `nginx1`.  Let's connect to the containers and test communications to confirm the network separation is working.

<br/>

---

<br/>

### NGINX1 Container Test

First, let's get a shell in `nginx1`:


`docker exec -it nginx1 /bin/bash` {{ execute }}

<br/>

---

<br/>

From the command line inside the container, let's try ping `mysql1`:

`ping -c 4 mysql1` {{ execute }}

The ping test should succeed because both `nginx1` and `mysql1` containers are part of the `database` network.

<br/>

---

<br/>

Let's escape from the `nginx1` container shell:

`exit` {{ execute }}


<br/>

---

<br/>

### APACHE1 Container Test

Now, let's get a shell in `apache1`:


`docker exec -it apache1 /bin/bash` {{ execute }}

<br/>

---

<br/>

From the command line inside the container, let's try ping `mysql1`:

`ping -c 4 mysql1` {{ execute }}

This command will fail because `apache1` is not on the `database` network and therefore cannot reach the `mysql1` container.

<br/>

---

<br/>

Now lets try pinging the `nginx1` container:

`ping -c 4 nginx1` {{ execute }}

This will succeed because the `apache1` and `nginx1` containers share the `external` network.

<br/>

---

<br/>

Let's escape from the `apache1` container shell:

`exit` {{ execute }}


<br/>

---

<br/>

### MYSQL1 Container Test

These commands will ping the `nginx1` and `apache1` containers from the `mysql1` container to show the results from the NGINX1 and APAHCE1 containers are also true for the MYSQL1 container.

<br/>

---

<br/>

This command will succeed:

`docker exec -it mysql1 ping -c 4 nginx1` {{ execute }}

<br/>

---

<br/>

This command will fail:

`docker exec -it mysql1 ping -c 4 apache1` {{ execute }}


<br/>
<br/>

---
---

## Lab 5b - One more container volume interaction

In case you missed it, we have the apache1 container a Bind Mount instead of a Docker Volume. As in Lab 4, this allows us to easily manipulate files in that mount point. In this case, we can live modify our custom `index.html`.

<br/>

---

<br/>

Run the following from the command line in the terminal:

`echo "<center><h2>I MODIFIED THE APACHE INDEX FILE VIA DOCKER BIND MOUNT.</h2></center>" | sudo tee /ab/labs/tmp/apache1/index.html` {{ execute }}


If you reload http://8081-LABSERVERNAME, you will see your page updated with your new message without reloading your container.

<br/>

---

<br/>

Let's clean up these containers, volumes and networks before we move on:


`docker rm -f nginx1 mysql1 apache1` {{ execute }}


<br/>

---

<br/>

Because we added persistence, you will notice that even though the containers are gone, the volumes are still there when you run the command:

`docker volume ls` {{ execute }}


<br/>

---

<br/>

Let's remove those volumes:


`docker volume rm nginx1 mysql1` {{ execute }}


<br/>

---

<br/>

And finally, let's clean up those networks:


`docker network rm external database` {{ execute }}

<br/>
<br/>

---
---

### Congrats! You have completed the Section 2 labs. You may now proceed with the rest of the course.