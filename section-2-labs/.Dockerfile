# This is the base image that this container image is being built from.
From centos:8

# This is the "working directory" that files will be copied to and command be ran from unless the full path is specified.
WORKDIR /var/www/html

# These are commands that are run during the image build, for example, updating the image for security patches and installing the httpd web server.
RUN yum makecache \
&& yum upgrade -y \
&& yum install -y httpd \
&& yum clean all

#This command copies files from the local directory into the container.
COPY index.html .

# This command does not actually expose port 80, but rather is a documentation point for what port is exposed.
EXPOSE 80

# This is the command that is run specifically to create the http process in the container once it runs.
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]