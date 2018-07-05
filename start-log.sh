#!/bin/sh

/etc/init.d/postgresql start
/etc/init.d/jchem-psql start
su postgres -c '/jpc-init.sh'
tail -f /var/log/jchem-psql/info.log