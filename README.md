HTML-based VNC server with LXDE Desktop
=======================================

This container provides a LXDE desktop environment available via
[noVNC](https://kanaka.github.io/noVNC/), the HTML5 VNC frontend,
through port 6080.

The image is based on [baseimage-docker](https://github.com/phusion/baseimage-docker),
so it uses **runit** to run the vnc services and tries to properly
handle log files and the like.

The base VNC server it uses is *vnc4server* from Ubuntu, which does
support **xrandr**. So, with this image, you can resize your desktop!

Usage
-----

From Docker registry:

```
docker pull rjrivero/vnc-lxde
```

Or build yourself:

```
git clone https://github.com/rjrivero/docker-vnc-lxde.git
docker build --rm -t rjrivero/vnc-lxde docker-vnc-lxde
```

Running the image:

```
docker run --rm -p 6080:6080 -v </path/to/your/Documents/folder>:/home/vnc/Documents rjrivero/vnc-lxde
```

Use in your Dockerfile:

```
FROM rjrivero/vnc-lxde:<tag>
```

VNC password
------------

At startup, the server tries to read an VNC password from the file
**/home/vnc/Documents/vncpasswd**.

  - If the file exists, its contents are used as the VNC password.
  - Otherwise, a random password is generated and dumped to stdout. You can see the generated password in the *docker log*.

VNC passwords must be between *6 and 8 characters long*. Shorter or longer passwords will fail.

User
----

The session is run as an user named **vnc** (UID 1000) in groups **vnc**
(GID 1000) and **sudo**. UID and GID 1000 were chosen because they are the
IDs that the first regular user in an Ubuntu installation gets.

The *vnc* user is able to run passwordless sudo.

Volumes
-------

You can mount a data volume under */home/vnc/Documents*. The init scripts change ownership
of anything in that path to user **vnc**.


Ports
-----

The container exposes **HTTP port 6080**, which belongs to the noVNC portal. It is plain HTTP,
this container does not implement HTTPS. However, it works fine behind a reverse proxy, so you can
use a different container for that purpose.

Resizing the desktop
--------------------

VNC4server was the chosen VNC server because it is readily available in Ubuntu, and it supports
xrandr. You can see the available display sizes running in a terminal inside the desktop the
following command:

```
xrandr
```

You can set your preferred resolution running:

```
xrandr -s <resolution>
```

If none of the preconfigured resolution matches your preferences, you can always add the
resolutions you need using an environment variable named **GEOMETRY**. Just populate
that variable with a colon-separated list of resolutions:

```
docker run --rm -e GEOMETRY=1440x900:1200x600:640x480 -p 6080:6080 rjrivero/lxde-vnc
```
