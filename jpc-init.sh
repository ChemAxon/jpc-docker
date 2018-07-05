#!/bin/sh

psql --command "CREATE EXTENSION chemaxon_type;"
psql --command "CREATE EXTENSION hstore;"
psql --command "CREATE EXTENSION chemaxon_framework;"
psql --command "CREATE table test(mol Molecule(\"sample\"), id int);"
psql --command "insert into test(id, mol) values (1, 'c'), (2, 'cc'), (3, 'ccc');"
psql --command "select * from test;"
psql --command "select * from test where mol |<| 'cc';"
psql --command "drop table test;"
