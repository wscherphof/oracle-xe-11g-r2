# An Oracle XE database server container image
A [Docker](https://www.docker.com/) [image](https://registry.hub.docker.com/u/wscherphof/oracle-xe-11g-r2/) with [Oracle® Database Express Edition 11g Release 2 (11.2)](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html) running in [Oracle Linux 7](http://www.oracle.com/us/technologies/linux/overview/index.html)
- Default XE database on port 1521
- Web management console on port 8080

## Install
1. [Install Docker](https://docs.docker.com/installation/#installation)
1. `$ docker pull wscherphof/oracle-xe-11g-r2`

## Run
Create and run a container named db:
```
$ docker run -d -P --name db wscherphof/oracle-xe-11g-r2
989f1b41b1f00c53576ab85e773b60f2458a75c108c12d4ac3d70be4e801b563
```

## Connect
The deafault password for both the `sys` and the `system` user is `manager`
The XE database port `1521` is bound to the Docker host through `run -P`. To find the host's port:
```
$ docker port db 1521
0.0.0.0:49189
```
So from the host, you can connect with `system/manager@localhost:49189`
Though if using Boot2Docker, you need the ip address instead of `localhost`:
```
$ boot2docker ip

The VM's Host only interface IP address is: 192.168.59.103

```
If you're looking for a databse client, consider [sqlplus](http://www.oracle.com/technetwork/database/features/instant-client/index-100365.html)
```
$ sqlplus system/manager@192.168.59.103:49189

SQL*Plus: Release 11.2.0.4.0 Production on Mon Sep 8 11:26:24 2014

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production

SQL> |
```

## Manage
1. Find the host's port bound to the container's `8080` web console port:
```
$ docker port db 8080
0.0.0.0:49190
```
2. Point a web browser to `http://192.168.59.103:49190/apex` (cannot use localhost there)
Workspace=`INTERNAL`
Username=`ADMIN`
Password=`manager`
![Web management console](apex.png)

## Monitor
The container runs a process that at the start sets the container's unique hostname in the Oracle configuration, starts up the database, and then continues to check each minute if the database is still running, and start it if it's not. To see the output of that process:
```
$ docker logs db
Tue Sep 9 14:54:42 UTC 2014
Starting Oracle Net Listener.
Starting Oracle Database 11g Express Edition instance.


LSNRCTL for Linux: Version 11.2.0.2.0 - Production on 09-SEP-2014 14:55:00

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC_FOR_XE)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.2.0 - Production
Start Date                09-SEP-2014 14:54:45
Uptime                    0 days 0 hr. 0 min. 15 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Default Service           XE
Listener Parameter File   /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
Listener Log File         /u01/app/oracle/diag/tnslsnr/0122e1df9772/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC_FOR_XE)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0122e1df9772)(PORT=1521)))
Services Summary...
Service "PLSExtProc" has 1 instance(s).
  Instance "PLSExtProc", status UNKNOWN, has 1 handler(s) for this service...
Service "XE" has 1 instance(s).
  Instance "XE", status READY, has 1 handler(s) for this service...
The command completed successfully
```

## Enter
There's no ssh deamon or similar configured in the image. If you need a command prompt inside the container, consider [docker-bash](https://github.com/phusion/baseimage-docker#docker_bash)

## License
[GNU Lesser General Public License (LGPL)](http://www.gnu.org/licenses/lgpl-3.0.txt)

## Build
Should you want to modify & build your own image:
1. Download & unzip the Oracle install package from [Oracle Tech Net](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html); this will get you a `Disk1` folder
1. Edit `Disk1/response/xe.rsp` to provide default port numbers & password
1. `docker build -t <[user/]name[:tag]> .`
