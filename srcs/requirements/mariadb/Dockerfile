FROM debian:bullseye

RUN apt update && apt install -y mariadb-server mariadb-client

# Remove the data pre-populated by apt that the init.sh starts clean
RUN rm -rf /var/lib/mysql/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306
CMD ["bash", "/init.sh"]