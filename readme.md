# 🚀 Perakit Podmanfile Multi-Stage Builds

### 🔥 Setup Multi-Stage Build

Pertama kita build dulu base-image untuk multi-stage container dengan menjalankan perintah berikut

```
podman build -t base-perakit -f base-image.podmanfile
```

Setelah base-image dibuat kita bisa masuk ke folder compose yang ingin di jalankan sebagai contoh kita menggunakan compose-alpine-one

```
cd compose-alpine-one
```

## Minimal compose alpine one

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

#### Note: Compose ini melengkapi beberapa extensi dasar php untuk menjalankan project laravel

### 🔥 Setup

Di dalam folder _compose-alpine-one_ Buka file [podman-compose.yml](/compose-alpine-one/podman-compose.yml) dan ubah konten yang ingin kita tentukan seperti password root, database-awal, user tambahan dan password user tambahan. Contoh:

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

Tunggu pembuatan image dan setelah container jalan silahkan buka localhost di-browser kita 😁

### 🫛 Membuka Container Podman yang berjalan

Ambil nama container di podman dengan perintah

```bash
podman ps
```

Sebagai contoh nama container yang muncul adalah "_compose-alpine-one-server-1_" jadi kita menjalankan perintah dibawah untuk masuk kedalam container

```bash
podman container exec -it compose-alpine-one-server-1 /bin/bash
```

Ganti "_compose-alpine-one-server-1_" sesuai dengan nama container yang muncul di podman ps kita

### ⭐ Struktur Folder

Silahkan masukkan project custom kita di folder dalam www jadi akan berada berdampingan dengan folder html

#### 🚀 Latihan Tambah site baru di sites-available

Sebagai contoh kita menambahkan folder "mysite" di dalam folder _/www_ maka kita perlu menambahkan configurasi nginx di folder sites-available sebagai berikut

-   Buat file [mysite.test](/etc/nginx/sites-available/mysite.test) di Host seperti lokasi dibawah (bukan di dalam container)

```
/etc/nginx/sites-available/mysite.test
```

-   Masukkan kode sebagai berikut

```
server {
    listen 80;
    server_name localhost;

    root /var/www/mysite;

    index index.php index.htm index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
```

-   Ubah _server_name_ ke "localhost2" di file [default](/etc/nginx/sites-available/default) di dalam folder sites-available seperti lokasi dibawah

```
/etc/nginx/sites-available/default
```

Contoh:

```
server {
    listen 80;
    server_name localhost2;

    ...
}
```

Buka container berjalan dengan mengikuti [Membuka Container Podman yang berjalan](#-Membuka-Container-Podman-yang-berjalan) diatas

di dalam container buat akses folder
check config nginx dengan perintah

```
nginx -t
```

Jika status ok maka reload config dengan perintah

```
nginx -s reload
```

Setelah selesai refresh browser kita. Jika halaman tidak berubah tekan kombinasi SHIFT + F5

### 🚀 Untuk realtime edit kode di container

Silahkan gunakan extensi [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

```
https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
```

### ✉️ Mailpit setup on Laravel

Untuk mengatur mailpit di laravel ubah .env sesuai peraturan berikut:

```
MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"
```

Note : Setelah .env di atur seluruh email akan masuk ke mailpit untuk melihat dashboardnya klik link [http://localhost:8025](http://localhost:8025/)

Untuk melakukan Test bisa menggunakan laravel tinker

```
php artisan tinker
```

Kemudian Masukkan

```
Mail::raw('This is a test email', function ($message) {
    $message->to('recipient@example.com')
            ->subject('Test Email');
});
```

Setelah itu cek email di dashboard mailpit [http://localhost:8025](http://localhost:8025/)

### 🔥 Advance SSL Setup

Untuk menggunakan ssl (port 443) kita membutuhkan sertifikat, kita bisa menjalankan perintah openssl self signed certificate untuk membuat sertifikat sendiri

#### Generate a private key

```
openssl genrsa -out localhost.key 2048
```

#### Create a self-signed certificate

```
openssl req -new -x509 -key localhost.key -out localhost.crt -days 365 -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost"
```

#### Domain Generate a private key

```
openssl genrsa -out laravel.test.key 2048
```

#### Domain Create a self-signed certificate

```
openssl req -new -x509 -key laravel.test.key -out laravel.test.crt -days 365 -subj "/CN=laravel.test" -addext "subjectAltName=DNS:laravel.test,DNS:\*.laravel.test"
```

Setelah sertifikat ssl terbuat pindahkan file .crt dan .key ke dalam folder _etc\nginx\ssl_

Buka file konfigurasi [default](/etc/nginx/sites-available/default) nginx di _etc\nginx\sites-available\default_
Ikuti petunjuk yang ada di-dalam file tersebut

Lanjut Buka file [podman-compose.yml](/compose-alpine-one/podman-compose.yml) dan hilangkan tanda pagar dibawah ports: # -433:433 jadi akan seperti dibawah dan pastikan spasi tab sesuai

```composefile
ports:
  - '80:80'
  - '443:443'
  - '3306:3306'
```

setelah [podman-compose.yml](/compose-alpine-one/podman-compose.yml) kita simpan, lakukan build ulang compose agar port bisa terbuka

```bash
podman compose --file podman-compose.yml up -d
```

### 🚀 Supervisord

Saat anda mengubah conf supervisord anda harus reread file conf dan update aplikasi supervisord agar conf tersebut dapat dibaca ulang

- Reread the configuration files:

```
supervisorctl reread
```
This command scans for changes in the configuration files.

- Update the configuration:

```
supervisorctl update
```
This command applies the changes, adding or removing programs as necessary, and restarts any affected programs12.

- Restart all programs (if needed):

```
supervisorctl restart all
```