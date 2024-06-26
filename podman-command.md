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

-   Buat perintah (terminal) untuk container yang sendang aktif

```
podman container exec -it container_name /bin/bash
```

### 🚀 Force re-create compose

```
podman compose up -d --build --force-recreate
```

### 🫛 Buka container dengan user root

```
podman container exec -it --user root nama_contaier sh
```

### 🫛 Copy files into a volume container

-   Pull base image alpine

```
podman pull alpine:latest
```

-   Kita jalankan test container dan mount volume kedalam container tersebut

```
podman run -v sites-volumes:/tmpfolder --name testcontainer -d -t alpine
```

-   Copy file kedalam test container yang telah kita buat yang juga akan masuk ke penyimpanan volume

```
podman cp www/. testcontainer:/tmpfolder
```

-   Setelah file dicopy kita bisa hancurkan test container yang telah di-buat

```
podman rm testcontainer
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

### 🔥 Close Environment WSL Podman Machine

Untuk file /etc/wsl.conf di Podman Machine Default

```
[user]
default=user

[network]
generateResolvConf = false

[interop]
enabled = false
appendWindowsPath = false

[automount]
enabled = false
```

Masukkan sesuai kebutuhan privasi anda

# ✌️ Extra ETC Command

### 😎 Nginx Command

Buat symbolink nginx

```
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
```

### 🤩 Git Command

Lihat daftar remote branch

```
git remote show origin
```

Bersihkan sisa remote branch yang telah di merge

```
git remote prune origin
```

Batalkan push

```
git push -f origin last_known_good_commit:branch_name
example: git push -f origin cc4b6beb5k4:alpha-4.2.69
```

Batalkan commit terbaru di local

```
git reset HEAD~1
```

### SSH
```
ssh-keygen -t ed25519 -C "your_email@example.com"
touch ~/.ssh/config
chmod 400 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
```
