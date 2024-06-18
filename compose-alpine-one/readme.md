# Minimal compose alpine one

### ⭐️ Fitur

-   Bash, It is useful for automating tasks, writing scripts to execute multiple commands, managing files and directories, and interacting with the system.
-   Curl, It is useful for transferring data with URLs, which makes it a versatile tool for web browsing, file transfer, and more.
-   Supervisor, It is useful for managing multiple programs and ensuring that they stay running even if one of them fails.
-   Nginx: Nginx is a web server that is known for its high performance and scalability. It is commonly used to serve static files, handle dynamic content, and provide reverse proxy functionality.
-   Nodejs: Node.js is a JavaScript runtime that allows you to run JavaScript code on the server. It is popular for building web applications and APIs using JavaScript.
-   Npm: Npm is the package manager for Node.js. It allows you to easily install, manage, and share JavaScript packages and modules.
-   MariaDB: MariaDB is a popular open-source relational database management system. It is known for its speed, reliability, and compatibility with MySQL.
-   Php83: Php83 is a server-side scripting language that is used to build web applications. It is known for its simplicity, security, and wide range of features.
-   Yarn: Yarn is a package manager for JavaScript that is designed to be faster and more reliable than npm. It allows you to easily install, manage, and share JavaScript packages and modules.
-   Composer: Composer is a dependency management tool for PHP that allows you to easily install and manage dependencies for your PHP projects. It simplifies the process of installing, updating, and managing third-party libraries and frameworks in your PHP code.

#### Note: Saya juga melengkapi beberapa extensi dasar php untuk menjalankan project laravel

### 🔥 Setup

Langkah Pertama anda harus build base-image dulu untuk multi-stage dengan menjalankan perintah berikut diluar folder ini

```
podman build -t base-perakit -f base-image.podmanfile
```

Kemudian buka file _podman-compose.yml_ dan ubah konten yang ingin anda tentukan seperti password root, database-awal, user tambahan dan password user tambahan. Contoh:

```composefile
environment:
  MYSQL_ROOT_PASSWORD: hello
  MYSQL_DATABASE: mydatabase
  MYSQL_USER: user
  MYSQL_PASSWORD: password
```

### 📦 Cara Menjalankan

<hr>
Setelah selesai mengubah file compose, Jalankan perintah compose dibawah dan selesai

```bash
podman compose --file podman-compose.yml up -d
```

setelah container jalan silahkan buka localhost di-browser anda 😁

### 🫛 Membuka Container Podman yang berjalan

Ambil nama container di podman dengan perintah

```bash
podman ps
```

Sebagai contoh nama container saya adalah "_compose-alpine-one-server-1_" jadi saya menjalankan perintah dibawah untuk masuk kedalam container

```bash
podman container exec -it compose-alpine-one-server-1 /bin/bash
```

Ganti "_compose-alpine-one-server-1_" sesuai dengan nama container yang muncul di podman ps anda

### ⭐ Struktur Folder

Silahkan masukkan project custom anda di folder dalam www jadi akan berada berdampingan dengan folder html

### 🔥 Advance SSL Setup

Untuk menggunakan ssl (port 443) anda membutuhkan sertifikat, anda bisa menjalankan perintah openssl self signed certificate untuk membuat sertifikat anda sendiri

```
openssl req -newkey rsa:4096 \
    -x509 \
    -sha256 \
    -days 3650 \
    -nodes \
    -out localhost.crt \
    -keyout localhost.key
```

isi sesuai kebutuhan anda

Setelah sertifikat ssl terbuat pindahkan file .crt dan .key ke dalam folder _etc\nginx\ssl_

Buka file konfigurasi default nginx di _etc\nginx\sites-available\default_
Ikuti petunjuk yang ada di-dalam file tersebut

Lanjut Buka file _podman-compose.yml_ dan hilangkan tanda pagar dibawah ports: # -433:433 jadi akan seperti dibawah dan pastikan spasi tab sesuai

```composefile
ports:
  - '80:80'
  - '443:443'
  - '3306:3306'
```

setelah _podman-compose.yml_ anda simpan, lakukan build ulang compose agar port bisa terbuka

```bash
podman compose --file podman-compose.yml up -d
```
