# Copyright 2018 ChemAxon Ltd.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/sh

psql --command "CREATE EXTENSION chemaxon_type;"
psql --command "CREATE EXTENSION hstore;"
psql --command "CREATE EXTENSION chemaxon_framework;"
psql --command "CREATE table test(mol Molecule(\"sample\"), id int);"
psql --command "insert into test(id, mol) values (1, 'c'), (2, 'cc'), (3, 'ccc');"
psql --command "select * from test;"
psql --command "select * from test where mol |<| 'cc';"
psql --command "drop table test;"
