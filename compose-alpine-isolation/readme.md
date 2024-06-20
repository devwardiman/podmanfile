# Max compose alpine isolated containers

## 🔥 Setup

Sebelum membuat Base-Image isolated container perlu diperhatikan konfigurasi di
nginx ubah _fastcgi_pass_ di file [default](/etc/nginx/sites-available/default)

```
fastcgi_pass 172.18.0.2:9000
```

Sehingga terlihat seperti contoh dibawah

```
location ~ \.php$ {
  try_files $uri =404;
  fastcgi_split_path_info ^(.+\.php)(/.+)$;
  fastcgi_pass 172.18.0.2:9000;
  fastcgi_index index.php;
  include fastcgi_params;
  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  fastcgi_param PATH_INFO $fastcgi_path_info;
}
```

Langkah kedua untuk isolate container, jika belum build base image sebelumnya maka kita harus build base-image dengan menjalankan perintah berikut di dalam folder ini

```
podman build -t base-perakit -f ../base-image.podmanfile
```

Note: Jika base image sebelumnya telah kita build, silahkan lanjutkan

## 🚀 Jalankan Compose Isolate containers

Sebelum menjalakan kita ubah dulu konten yang ada di file [podman-compose.yml](./podman-compose.yml). contoh:

```composefile
environment:
  MYSQL_ROOT_PASSWORD: hello
  MYSQL_DATABASE: mydatabase
  MYSQL_USER: user
  MYSQL_PASSWORD: password
```

Setelah selesai mengubah file compose, Jalankan perintah compose dibawah dan selesai

```bash
podman compose --file podman-compose.yml up -d
```

<hr>

## 📦 Cara Lain menjalankan isolated container dengan custom images

### 📦 Build Isolated Images

Mari kita build image untuk masing - masing isolate container-nya

-   Build Isolate [Php-fpm](./phpfpm.podmanfile) container

```
podman build -t app-phpfpm -f phpfpm.podmanfile
```

-   Build Isolate [NodeJs](./nodejs.podmanfile) container

```
podman build -t app-nodejs -f nodejs.podmanfile
```

-   Build Isolate [MariaDB](./mariadb.podmanfile) container

```
podman build -t app-mariadb -f mariadb.podmanfile
```

-   Build Isolate [Nginx](./nginx.podmanfile) container

```
podman build -t app-nginx -f nginx.podmanfile
```

### 🫛 Ubah build contaxt ke image app di file [podman-compose.yml](./podman-compose.yml)

sebagai contoh

```
    nginx:
        build:
            context: .
            dockerfile: ./nginx.podmanfile
```

menjadi

```
    nginx:
        image: localhost/app-nginx
```

Atur nama image sesuai dengan aplikasi yang ingin di integrasikan

Setelah selesai mengubah file compose, Jalankan perintah compose dibawah dan selesai

```bash
podman compose --file podman-compose.yml up -d
```
