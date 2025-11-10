# Docker base for Oracle Linux 9

## Build the image

```bash
docker build --tag oracle-linux-9 --progress=plain .
```

> Or use the script [build-images.bat](build-images.bat).
>
> Connect to the container: `docker run --rm -it --entrypoint bash oracle-linux-9`

## Run a container

```
SET CONTAINER_NAME="oracle-linux-9"
docker run --security-opt seccomp=unconfined ^
           --detach ^
           --net=bridge ^
           --interactive ^
           --tty ^
           --rm ^
           --publish 2222:22/tcp ^
           oracle-linux-9
```

> One-liner: `docker run --security-opt seccomp=unconfined --detach --net=bridge --interactive --tty --rm --publish 2222:22/tcp oracle-linux-9`

## Connecting to a container

The OS is configured with two UNIX users:

| **User** | **Password**   |
|----------|----------------|
| `root`   | `root`         |
| `dev`    | `dev` (sudoer) |

**Connexion using the password**

    set USER=dev
    ssh -o StrictHostKeyChecking=no ^
        -o UserKnownHostsFile=NUL ^
        -o GlobalKnownHostsFile=NUL ^
        -p 2222 %USER%@localhost

> You can use the script [connect-as-dev.bat](connect-as-dev.bat).

**Connexion using the SSH key**

    set USER=dev
    ssh -o StrictHostKeyChecking=no ^
        -o UserKnownHostsFile=NUL ^
        -o GlobalKnownHostsFile=NUL ^
        -o IdentitiesOnly=yes ^
        -o IdentityFile=private.key ^
        -p 2222 %USER%@localhost

## SCP

From the host, download a file (stored on the container):

```bash
scp -o UserKnownHostsFile=NUL -o StrictHostKeychecking=no -o IdentitiesOnly=yes -P 2222 dev@localhost:/tmp/file-to-download /tmp/
```

From the host, upload a file (stored on the host):

```bash
scp -o UserKnownHostsFile=NUL -o StrictHostKeychecking=no -o IdentitiesOnly=yes -P 2222 /tmp/file-to-upload dev@localhost:/tmp/
```

