# ❤️ Podman useful commands

### 🫛 Active Podman rootful machine

```
podman machine set --rootful=true
```

### 🫛 Install Fedora Plugins Core

```
sudo dnf -y install dnf-plugins-core
```

### 🫛 Add Fedora Docker Repo

```
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
```

### 🚀 Fast Running Container

-   Running new container

```
podman pull alpine:latest
podman run -it -e HI=jitcontainer alpine:latest
```

-   Running existing or paused container

```
podman container exec -it container_name /bin/bash
```

### 🚀 Force re-create compose

```
podman compose up -d --build --force-recreate
```

### 🫛 Open Unprivileged Port on Fedora

Buka _sysctl.conf_

```
sudo nano /etc/sysctl.conf
```

kemudian masukkan

```
net.ipv4.ip_unprivileged_port_start=80
```

restart sysctl

```
sudo sysctl -p
```

Check changed

```
sudo sysctl --system
```

Check netstat

```
netstat -tuln | grep 80
```
