FROM debian:bullseye

RUN apt update && apt install -y mariadb-server mariadb-client

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY conf/my.cnf /etc/mysql/my.cnf

COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 3306

CMD ["bash", "/init.sh"]

