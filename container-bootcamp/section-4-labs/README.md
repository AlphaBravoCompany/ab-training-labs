# Container Bootcamp - Section 3 Labs

In this section we learned about:

* Docker-Compose

## Lab 1 - Running Wordpress using CLI commands

In this section, we highlighted the benefit of using docker-compose over CLI commands to manage containers or groups of containers.

First, let's run all the Docker CLI commands we would need to bring a MariaDB and Wordpress container online and allow them to communicate and have persistent storage.


### Creating Networks

`docker network create database_net`

`docker network create external_net`

### Creating the MariaDB MySQL container

`docker run -itd -e MARIADB_ROOT_USER=wordpress -e MARIADB_ROOT_PASSWORD=yourpassword -e MARIADB_DATABASE=wordpress --name mariadb -v mariadb_data:/var/lib/mysql --net database_net docker.io/bitnami/mariadb:10.3`

### Creating the Wordpress container

`docker run -itd -e WORDPRESS_DATABASE_HOST=mariadb -e WORDPRESS_DATABASE_PORT_NUMBER=3306 -e WORDPRESS_DATABASE_USER=wordpress -e WORDPRESS_DATABASE_PASSWORD=yourpassword -e WORDPRESS_DATABASE_NAME=wordpress -e WORDPRESS_BLOG_NAME=AB_Training_Docker_CLI--name wordpress -p 80:8080 -p 443:8443 -v wordpress_data:/var/www/html --net external_net docker.io/bitnami/wordpress:5`

### Attaching the Wordpress container to the database network

`docker network connect database_net wordpress`

Now if we visit http://LABSERVERNAME we should see a generic Wordpress page up and running. We can see more about what these containers did during startup by viewing the logs.

`docker logs mariadb`

`docker logs wordpress`

Let's clean up these containers, volumes and networks.

`docker rm -f wordpress mariadb && docker volume rm mariadb_data wordpress_data && docker network rm database_net external_net`

## Lab 2 - Running Wordpress using docker-compose

Docker compose simplifies things quite a bit while also allowing us to be declarative about our configuration and generate an artifact that could be put into source code control like Git.

Let's take a look at the docker-compose.yml file in this directory.

Notice that it has all of the elements we defined in the Docker CLI, but it is much easier to read and modify.

Now, let's run this docker-compose against this file. By default docker-compse will look for a file named `docker-compose.yml` in the present working directory (PWD) and run it. If your file is named something else, you will need to specify a `-f filename.yml` for docker-compose to find it.

First, make sure you are in the `/ab/container-bootcamp/section-4-labs/` directory, then run:

`docker-compose up -d`

That's it. In a few seconds you can visit http://LABSERVERNAME and see that Wordpress is up and running.

If you would like to see the logs for the currently running docker-compose deployment, from the same directory as the `docker-compose.yml` file, run:

`docker-compose logs`

You can see that logs from both containers in the file are integrated into a single log output with labels for which container produced the log.

Now, to cleanup all containers, volumes, and networks we docker-compose just created, we run:

`docker-compose down -v`

## Congrats! You have completed the Section 4 labs. You may now proceed with the rest of the course.