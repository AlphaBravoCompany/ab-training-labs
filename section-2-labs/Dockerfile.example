From centos:7

WORKDIR /var/www/html

RUN yum makecache \
&& yum upgrade -y \
&& yum install -y httpd \
&& yum clean all

COPY index.html .

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]