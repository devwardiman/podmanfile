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

### ⛵ Docker context

Saat extensi VSCode bermasalah kemungkinan docker menggunakan context yang salah maka anda dapat membenarkan pengaturan dengan cara

Melihat context

```
docker context ls
```

Mengubah context

```
docker context use default 
```

Note: Jika anda menggunakan Podman pastikan DOCKER ENDPOINT yang dituju sama dengan yang tampil saat machine start 
[Read More](https://docs.docker.com/engine/context/working-with-contexts/)

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

### SSH & Git Connect

Untuk membuat ssh key [Read More](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```
ssh-keygen -t ed25519 -C "your_email@example.com"
touch ~/.ssh/config
chmod 400 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
```

Contoh file _config_

```
Host github.com
    HostName github.com
    User username
    IdentityFile ~/.ssh/username
```

Test Connection

```
ssh -T git@github.com
```

### 🫛 Php Xdebug
Untuk mengaktifkan Xdebug php silahkan masukkan perintah

```
php --ini
```

Kemudian cari configurasi file xdebug contoh: 

```
/etc/php83/conf.d/50_xdebug.ini,
```

Edit konten file tersebut dengan kode dibawah 

```
zend_extension=xdebug.so

[xdebug]
xdebug.mode=develop,coverage,debug,profile
xdebug.idekey=MyVSCode
xdebug.start_with_request=yes
xdebug.log=/dev/stdout
xdebug.log_level=0
xdebug.client_port=9003
xdebug.client_host=127.0.0.1
```

Setelah selesai di visual code silahkan download extensi [Xdebug](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)

```
https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug
```

Di VSCode pada sidebar Klik ikon _Run and Debug_ atau tekan (CTRL + SHIFT + D) setelah di menu nya klik _create a launch.json file_ kemudian pilih _php_ file launch.json akan terbuat automatis setelah itu langsung saja klik Klik tombol Play Hijau atau tekan F5 untuk menjalankan debug. 

Note: Jangan lupa memberikan breakpoint untuk baris koding yang ingin di inspeksi.
