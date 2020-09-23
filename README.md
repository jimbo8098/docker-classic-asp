A lot of people still run Classic ASP sites but experience difficulties while using them in a modern environment. This container will serve up a host with a ServerCore with IIS configured for use with Classic ASP. This version is configured to host a single site and mounts the SITENAME directory. It will set up an application pool using a SVCUSER user with password SVCPASS. There are assumed defaults, which will bring up a server for test.com which will have bindings for www.test.com.

# Arguments
| Argument | Default  | Description                                                                                    |
|----------|----------|------------------------------------------------------------------------------------------------|
| SVCUSER  | testuser | The user created to manage the site files. Useful in gMSA-style environments                   |
| SVCPASS  | P@ssW0rd | The password assigned to the created SVCUSER. Useful in gMSA-style environments                |
| SITENAME | test.com | The canonical name you wish to create the site with. The site will be named as such within IIS |
| SITEHOST | test.com | The host binding you wish to have the site respond on                                          |

# Quick Start
```
docker build . -t iis -f Dockerfile -e SVCUSER=username -e SVCPASS=pass -e SITENAME=test.com SITEHOST=test.com
```

# Minimal
The minimal dockerfile simply adds the prerequisites for an ASP classic site and is more or less designed as a pre-built layer for a multi-layer install. It does not expose ports, creates sites, directories etc.