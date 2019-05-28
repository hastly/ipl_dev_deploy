# Auto deployed development environment for ipl-api

## Prerequisites

  - git with access to gitlab repo
  - docker


## How to use

Upon cloning run dock.sh script without arguments to spin up machinery


## What do we have here

### POI

- start/stop/manage containers: ./dock.sh script
- see available command to use or add own command: ./art/ans/playbooks/

### Project structure

  - / = start scripts and documentation
  - /box = docker and docker compose configurations
  - /art = files to be added into docks: configurations, play-books, fixtures etc.
  - /vol = persistent storage for docks


```
.
├── art <-- files to be available in docks
│   └── ans <-- files to be available in "ans" dock
│       ├── ansible.cfg <-- ansible environment config
│       ├── files <-- artifacts to use inside dock
│       │   └── init_script
│       ├── hosts <-- static list of hosts to ansible to work on pointed to in ansible.cfg
│       └── playbooks <-- methods to run on docks
│           └── up.yml <-- default up method
├── box <-- files to configure docks provisioning
│   ├── ans <-- config for "ans" dock
│   │   └── Dockerfile
│   └── docker-compose.yml <-- configuration of all docks
├── dock.sh <-- universal bash manager script
├── README.md <-- this doc
└── steps.todo <-- complete and to be done tasks
```


## Parts

### Api complex

It comprises all artifacts required to run "ipl api" development environment. All artifacts are docker containers configured with data from this repository. They are divided into utility, services and application containers. All docks run in one host environment: real or virtualized (for example using vagrant/virtual-box) developer OS.

 
### Docks (utilities and services)

  - "ans" = Ansible 2.8.0 to rule them all
  - "pg" = PostgreSQL 9.5.9 RDBMS main storage p:15432:5432 with volume


### Docks (applications)

  - "app_test" = Python 3.7 p:18080:8000



## Details of "ans"


### Provisioning

It's custom image built on top of official "ubuntu xenial 64" as base image, cause it has everything to work with postgres 9.5 in its repo. Aside of python 3, ansible and docker api utility it is staffed with:
		- _bison_ and _flex_ via apt to make postgres extensions
		- postgres development and client packages via apt and postgres adapter package via pip to communicate with postgres in general
		- _socat_ apt package to proxy local port into docker socket
		- _ipmt_ pip package to run migrations
All data files required to configure other docks supplied via docker volume from this repo. It receives host docker sock as volume as well.


### Python

Installs default python 3 from main repo by requiring pip-3. Then updating pip-3 up to the latest version, after that pip-3 is accessible with "pip" command. Python is required to use Ansible as a main configuration tool and to work with "pg".


### Ansible

Ansible installed via pip together with OpenSSL package. Upon that it accessible via docker to run ready-made play-books on application and service containers.


### Docker

"ans" joins the host network in order to be capable to control docks from "api_complex" - create, destroy, start and stop them. Provide them with data and configuration. Put them in desired state. Pip "docker" package is used to work with docker API. In order to access host docker api:
		- docker socket is mapped inside "ans" container
		- "socat", installed via apt and running from "ans" start script, background process forwards local port to docker mapped socket
		- environment variable assigned in "ans" Dockerfile points docker library towards this local port


### Initialization script

It's a bash script started by Dockerfile via ENTRYPOINT provides the following:
		- runs socat in background
		- if string provided by extra arguments (from compose file or from CLI) corresponds to ansible play-book stored in designated location, then runs it using ansible
		- if first argument is not a play-book name than runs it as bash command as usual for docker
Extra arguments can be provided via command in compose file or via tail part of docker compose run CLI command. If no extra arguments provided it runs a default play-book that targeted to configure, provisioning and orchestrate all the other docks in order to make them completely ready for doing their job.


### Main storage

Upon "pg" is started and ready (provisioned) "ans" starts providing it with:
		- postgres extensions
		- data structure
		- data fixtures
as described in "pg" details section



## Details of "pg"


### Provisioning

Created from compose file with default user from official image. Data location and default user requisites provided via environment variables. Data stored on volumes mounted at host file system.


### Configuration

__Extensions__ compiled at "ans" instance, copied into "pg" and installed there.

__Migraton__ applied by "ans" dock. "ans" gets necessary packages installed to run "ipmt" tool. It clones migration repositories and run "ipmt" from there for each db, designated by environment variable.

__Fixtures__ stored here in custom pg dump archive for each db where applicable. Loaded by "ans" via restore utility.


### Extensions

"ans" prepares and deploys "js-query" extension for "pg" going through the following steps:
		- clones js-query from its github
		- makes/installs it locally (thats why postgres server, its development libraries and bison-flex were needed)
		- copies built target files into corresponding "pg" paths
		- runs SQL to register extension at "pg" side (thats why python postgres adapter package was needed)


js-query repo: 
	```
	$ git clone https://github.com/postgrespro/jsquery.git && cd jsquery
	```

make commands:
	```
	$ make USE_PGXS=1
	$ sudo make USE_PGXS=1 install
	```

extension files location map (ubuntu postgres => official docker image postgres)
	```
	/usr/lib/postgresql/9.5/lib/jsquery.so => /usr/local/lib/postgresql/
	/usr/include/postgresql/9.5/server/jsquery.h => /usr/local/include/postgresql/server/
	/usr/share/postgresql/9.5/extension/jsquery* => /usr/local/share/postgresql/extension/
	```

SQL to register extension:
	```
	CREATE EXTENSION jsquery;
	```


### Migrations

To build up data structure for every desired database the following steps are commited:
		- clone migration rep[o of this database
		- set environment string pointing ipmt towards desirable database
		- run ipmt tool inside cloned repo with command "up" and no migration index (thats where we need installed postgres client)

example of ipmt variable:
	```
	$ export IPMT_DSN='postgres:qweasdzxc@localhost:5432/api'
	```


### Fixtures

They are stored in this repo, shared with "ans" dock with data volume and loaded into "pg" dock via pg_restore command using ansible module.

example of fixture load:
	```
	pg_restore -h localhost -U postgres -d api /vagrant/files/fixtures_api.dump 
	```
