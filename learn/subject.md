### General guidelines
• This project needs to be done on a Virtual Machine.
• All the files required for the configuration of my project must be placed in a srcs
folder.
• A Makefile is also required and must be located at the root of my directory. It
must set up my entire application (i.e., it has to build the Docker images using
docker-compose.yml).
• This subject requires putting into practice concepts that, depending on my
background, I may not have learned yet. Therefore, I'm advised not to hesitate to
read a lot of documentation related to Docker usage, as well as anything else I
will find helpful in order to complete this assignment.

### Subject

This project consists in set up a small infrastructure composed of different
services under specific rules.
The whole project has to be done in a virtual machine.
I have to use docker compose.
Each Docker image must have the same name as its corresponding service.
Each service has to run in a dedicated container.
For performance matters, the containers must be built either from the
penultimate stable version of Alpine or Debian. I have to choose between these two?
I also have to write my own Dockerfiles, one per service.
The Dockerfiles must be called in my docker-compose.yml by my Makefile.
It means I have to build myself the Docker images of my project.
It is then forbidden to pull ready-made Docker images, as well as using services
such as DockerHub (Alpine/Debian being excluded from this rule).

## SETUP
# Containers
• A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
• A Docker container that contains WordPress + php-fpm (it must be installed and configured) only without nginx.
• A Docker container that contains MariaDB only without nginx.
# Volumes
• A volume that contains my WordPress database.
• A second volume that contains my WordPress website files.
• A docker-network that establishes the connection between my containers.

## RESTART
My containers have to restart in case of a crash.
• In my WordPress database, there must be two users, one of them being the administrator.
The administrator’s username can’t contain admin/Admin or administrator/Administrator (e.g., admin, administrator, Administrator, admin-123, and so forth).


## Restrictions 1:
A Docker container is not a virtual machine. Thus, it is not recommended to use
any hacky patch based on ’tail -f’ and so forth when trying to run it.
Note to self 1:
Learn about how daemons work and whether it’s a good idea to use them or not.

## Restrictions 2:
Of course, using network: host or --link or links: is forbidden.
The 'network:' line must be present in my docker-compose.yml file.

## Restrictions 3
My containers musn’t be started with a command running an infinite loop. Thus,
this also applies to any command used as entrypoint, or used in entrypoint
scripts. 

## Restrictions 4
The following are a few prohibited hacky patches:
tail -f, bash, sleep infinity, while true.
Notes to self 1:
Learn about PID 1 and the best practices for writing Dockerfiles.

## Restrictions 5:
My volumes will be available in the /home/login/data folder of the host machine
using Docker. Of course, I have to replace the login with my nicknaname:
'antoda-s'.

Restrictions 4:
To make things simpler, I have to configure my domain name so it points to my
local IP address. This domain name must be nickname.42.fr. Again, I have to use
my own nicjname 'antoda-s'.
For example, if my login is antoda-s, antoda-s.42.fr will redirect to the IP
address pointing to antoda-s’s website.

Restrictions 5:
The latest tag is prohibited.
No password must be present in my Dockerfiles.
It is mandatory to use environment variables.
Also, it is strongly recommended to use a .env file to store environment
variables and strongly recommended that I use the Docker secrets to store any
confidential information.
My NGINX container must be the only entrypoint into my infrastructure via the
port 443 only, using the TLSv1.2 or TLSv1.3 protocol.

Restrictions 6:
For obvious security reasons, any credentials, API keys, passwords, etc... must
be saved locally in various ways / files and ignored by git.
Publicly stored credentials will lead me directly to a failure of the project.
I can store my variables (as a domain name) in an environment variable file
like .env

Below is an example of the expected directory structure:

$> ls -alR
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxrwt 17 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Makefile
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 secrets
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 srcs
./secrets:
total XX
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 6 wil wil 4096 avril 42 20:42 ..
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 credentials.txt
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 db_password.txt
-rw-r--r-- 1 wil wil XXXX avril 42 20:42 db_root_password.txt
./srcs:
total XX
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 docker-compose.yml
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .env
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 requirements
./srcs/requirements:
total XX
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 3 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 bonus
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 mariadb
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 nginx
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 tools
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 wordpress
./srcs/requirements/mariadb:
total XX
drwxrwxr-x 4 wil wil 4096 avril 42 20:45 .
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
[...]
./srcs/requirements/nginx:
total XX
drwxrwxr-x 4 wil wil 4096 avril 42 20:42 .
drwxrwxr-x 5 wil wil 4096 avril 42 20:42 ..
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 conf
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 Dockerfile
-rw-rw-r-- 1 wil wil XXXX avril 42 20:42 .dockerignore
drwxrwxr-x 2 wil wil 4096 avril 42 20:42 tools
[...]
$> cat srcs/.env
DOMAIN_NAME=antoda-s.42.fr
# MYSQL SETUP
MYSQL_USER=XXXXXXXXXXXX
[...]
