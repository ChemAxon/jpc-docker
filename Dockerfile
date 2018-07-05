FROM ubuntu:18.04
MAINTAINER JPC Support "jpc-support@chemaxon.com"

# install postgres @ jdk
RUN apt-get update && apt-get install -y gnupg software-properties-common postgresql postgresql-client postgresql-contrib openjdk-8-jdk

# PostgreSQL should be managed by user: postgres
USER postgres
ENV DEBIAN_FRONTEND noninteractive
RUN /etc/init.d/postgresql start && psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" && psql --command "ALTER USER postgres with password 'postgres';" && createdb -O docker docker
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# change back to root user
USER root
COPY jpc.deb jpc.deb
RUN /etc/init.d/postgresql stop

# install JPC
RUN dpkg -i jpc.deb

# copy ChemAxon Licence
COPY license.cxl /etc/chemaxon/license.cxl

# init & start services
RUN /etc/init.d/postgresql start
RUN /etc/init.d/jchem-psql init
RUN /etc/init.d/jchem-psql start

# change to postgres and create extension
USER postgres
RUN  /etc/init.d/postgresql start && psql --command "CREATE EXTENSION chemaxon_type;" && psql --command "CREATE EXTENSION hstore;" && psql --command "CREATE EXTENSION chemaxon_framework;"    

# add startscripts as root
USER root
COPY start.sh start.sh
COPY jpc-init.sh jpc-init.sh

# grant execution permission to scripts
RUN chmod +x start.sh
RUN chmod +x jpc-init.sh

# set start script as entry point
ENTRYPOINT ["/start.sh"]
