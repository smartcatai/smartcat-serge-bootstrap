Put SSH keys into this directory for `git` and other tools
to work (refer to OpenSSH or Git documentation on how to
set up SSH-based authentication). This is needed for
Docker-based Serge installations only.

You don't have to set up permissions for the files here:
the `/usr/local/bin/boot/bootstrap.sh` script that is a part
of the Docker image will take care of this at startup time.