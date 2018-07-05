# 1. Prerequisets

* docker installed
* Copy the latest JPC (JPC 4.0: https://chemaxon.com/download?dl=%2Fdata%2Fdownload%2Fjpc%2F4.0%2Fjchem-psql_4.0.r20180510.134745_amd64.deb ) next to Dockerfile with the name: __jpc.deb__
* Copy a ChemAxon PSQL license next to Dockerfile with name: __license.cxl__
    
After settings you should have the following files in the directory:
```Dockerfile
jpc.deb
jpc-init.sh
license.cxl
README.md
start.sh
```
    
# 2. Building the image:

* Run: `docker build -t cxn/jpc:latest .`
    
This will build an image that is called cnx/jpc with the tag: latest. This image is based on Ubuntu 18.04 LTS (Bionic Beaver) and uses OpenJDK 8 (1.8.0_171) to run JPC.
You can connect to the database as:
* USER: __postgres__
* PASSWORD: __postgres__
    
# 3. Starting a container

* Run `docker run -ti cxn/jpc:latest`
    
This will start the container and PostgreSQL server in it. Also starts and initialises JPC servcie. For a little test it will:
* create a table (as: `CREATE table test(mol Molecule("sample"), id int);`)
* insert some data (with SQL: `insert into test(id, mol) values (1, 'c'), (2, 'cc'), (3, 'ccc');`)
* selects all data (`select * from test;`)
* do a substructure search on data (`select * from test where mol |<| 'cc';`)
* finally drops table (`drop table test;`)
* after that it will change to `/bin/bash` as root user and wait for input
    
You can connect to the database with the following steps:
* change to postgres user: `su postgres -`
* connect to databse: `psql`
* and you can start running JPC related queries like: `SELECT TRUE AS IS_SUBSTRUCTURE WHERE 'C'::molecule('sample')|<|'CC';`
