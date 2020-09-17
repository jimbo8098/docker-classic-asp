A lot of people still run Classic ASP sites but experience difficulties while using them in a modern environment. This container will serve up a host with a ServerCore with IIS configured for use with Classic ASP. This version is configured to host a single site and mounts the SITENAME directory. It will set up an application pool using a SVCUSER user with password SVCPASS. There are assumed defaults, which will bring up a server for test.com which will have bindings for www.test.com.

# Quick Start
```
docker run 