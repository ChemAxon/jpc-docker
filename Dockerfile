FROM ubuntu:latest
MAINTAINER JPC Support "jpc-support@chemaxon.com"
RUN apt-get update && apt-get install -y gnupg software-properties-common postgresql postgresql-client postgresql-contrib
USER postgres
ENV DEBIAN_FRONTEND noninteractive
RUN /etc/init.d/postgresql start && psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" && psql --command "ALTER USER postgres with password 'postgres';" && createdb -O docker docker
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
MAINTAINER JPC Support "jpc-support@chemaxon.com"
USER root
RUN apt-get update && apt-get install -y openjdk-8-jdk
COPY jpc.deb jpc.deb
RUN /etc/init.d/postgresql stop
RUN dpkg -i jpc.deb
RUN /etc/init.d/postgresql start
COPY license.cxl /etc/chemaxon/license.cxl
RUN /etc/init.d/jchem-psql init
RUN /etc/init.d/jchem-psql start
USER postgres
RUN  /etc/init.d/postgresql start && psql --command "CREATE EXTENSION chemaxon_type;" && psql --command "CREATE EXTENSION hstore;" && psql --command "CREATE EXTENSION chemaxon_framework;"    
USER root
COPY start.sh start.sh
COPY jpc-init.sh jpc-init.sh
RUN chmod +x start.sh
RUN chmod +x jpc-init.sh
ENTRYPOINT ["/start.sh"]
