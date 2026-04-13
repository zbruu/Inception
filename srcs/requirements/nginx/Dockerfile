# Base image: define the image, here a stable debian (so my container is a mini-Debian)
FROM debian:bullseye

# Packet installation: to update packets and install nginx and openssl without asking any questions
RUN apt update && apt install -y nginx openssl

# Delete the default config: to avoid configuration conflicts
RUN rm -rf /etc/nginx/sites-enabled/default

# Copy my nginx config from my project into the image
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Create a runtime directory necessary for the functionning of nginx
RUN mkdir -p /run/nginx

# Generate my SSL certificate: create an auto-signed HTTPS certificate
RUN openssl req -x509 -nodes -days 365 \
-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=login.42.fr" \
-out /etc/ssl/certs/nginx.crt \
-keyout /etc/ssl/private/nginx.key
#req: creation of a request for a certificate
#-x509: auto-signed certificate
#-nodes: without any password
#-days 365: valid for a year
#-subj: contains the informations for the certificate: country, cit, organization, domain
#out: certificate
#keyout: private key

# (Test when setting up the nginx container without any other container created yet) Web folder(temporary): directory where nginx is going to put the files (will be replaces by our wordpress)
RUN mkdir -p /var/www/html 
#	&& \ echo "<h1>NGINX OK</h1>" > /var/www/html/index.html

#Exposed port: indicates that the container uses the HTTPS port
EXPOSE 443

# Launching command executed at the launch of the container (forces nginx to stay in foerground)
CMD ["nginx", "-g", "daemon off;"]

#Dockerfile  list of instructions executed in the following order:
#FROM = base
#RUN = install/configurate
#COPY = add files
#EXPOSE = open port
#CMD = start the program

#Recap en FR:
#1. prend Debian
#2. installe nginx + openssl
#3. enlève la config par défaut
#4. ajoute ma config
#5. prépare nginx
#6. crée certificat HTTPS
#7. prépare dossier web
#8. expose port 443
#9. lance nginx
#=> Quand je build, j'obtiens une image avec debian + nginx + SSL + ma config:
# Nginx HTTPS actif sur port 443
