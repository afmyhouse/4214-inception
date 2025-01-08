# Inception Project Setup Documentation

This documentation provides a detailed overview of the Inception project setup, which includes Dockerized services for MariaDB, WordPress, and Nginx, using encrypted secrets for secure configuration.

---

## Project Overview

The Inception project sets up a multi-container environment with the following services:

- **MariaDB**: A relational database management system.
- **WordPress**: A content management system (CMS).
- **Nginx**: A web server to serve the WordPress site.

All services are configured to work together using Docker Compose, with a secure mechanism to manage secrets.

---

## Dockerfiles

### MariaDB Dockerfile

1. **Base Image**: `debian:bullseye`
2. **Dependencies**:
   - `wget`, `curl`, `gnupg`, `libaio1`
   - MariaDB server and client (version 10.5).
3. **Entrypoint**: Custom script for initializing the database and decrypting secrets.
4. **Exposed Port**: `3306`
5. **Volumes**: `/var/lib/mysql` for persistent data storage.

### Nginx Dockerfile

1. **Base Image**: `debian:bullseye`
2. **Dependencies**:
   - `nginx`
   - `openssl` for SSL certificate generation.
3. **Configuration**: Custom Nginx configuration file (`antoda-s42fr.conf`) copied to `/etc/nginx/sites-available`.
4. **Entrypoint**: Custom script to generate SSL certificates and start the server.
5. **Exposed Port**: `443` (HTTPS).

### WordPress Dockerfile

1. **Base Image**: `debian:bullseye`
2. **Dependencies**:
   - `php-mysqli`, `php-fpm`
   - MySQL client tools.
3. **Entrypoint**: Custom script for decrypting secrets, configuring WordPress, and running `php-fpm`.
4. **Volumes**: `/var/www/html/wordpress` for persistent WordPress data.

---

## Entrypoint Scripts

### MariaDB Entrypoint Script

1. Decrypts secrets using `openssl`.
2. Extracts database credentials from the decrypted secrets.
3. Initializes the database if it hasn’t been set up already.
4. Starts the MariaDB server with network access enabled.

### Nginx Entrypoint Script

1. Creates SSL certificates using `openssl`.
2. Starts the Nginx server with the specified configuration.

### WordPress Entrypoint Script

1. Decrypts secrets and extracts WordPress and database credentials.
2. Configures WordPress:
   - Downloads WordPress using `wp-cli`.
   - Configures the `wp-config.php` file.
   - Installs WordPress and creates admin and author users.
3. Runs `php-fpm` to serve the WordPress site.

---

## Docker Compose Configuration

### Services

#### MariaDB
- **Build Context**: `./requirements/mariadb`
- **Container Name**: `mariadb`
- **Exposed Port**: `3306`
- **Secrets**: `secret_key` and encrypted secrets.
- **Volumes**: `dbvol` for persistent database storage.

#### WordPress
- **Build Context**: `./requirements/wordpress`
- **Container Name**: `wordpress`
- **Exposed Port**: `9000`
- **Dependencies**: Requires MariaDB.
- **Secrets**: `secret_key` and encrypted secrets.
- **Volumes**: `wpvol` for persistent WordPress data.

#### Nginx
- **Build Context**: `./requirements/nginx`
- **Container Name**: `nginx`
- **Exposed Port**: `443`
- **Dependencies**: Requires WordPress.
- **Volumes**: `wpvol` for serving WordPress files.

### Secrets Management

1. **Encrypted Secrets**: Stored in `secrets.enc` and decrypted at runtime using `openssl`.
   to encrypt
    ```bash
    openssl enc -aes-256-cbc -salt -pbkdf2 -in ./secrets_vault/secrets.txt -out secrets.enc -pass pass:$(cat ./secrets_vault/decryptkey.txt)
    ```
    to decrypt
    ```bash
    openssl enc -aes-256-cbc -d -pbkdf2 -in /run/secrets/secrets.enc -out /run/secrets/secrets.txt -pass pass:$(cat /run/secrets/secret_key)
    ```
2. **Secret Key**: A file (`decryptkey.txt`) is used to securely decrypt the secrets.

### Volumes

1. **Database Volume (dbvol)**:
   - Path: `/home/antoda-s/data/db`
   - Purpose: Stores MariaDB data persistently.

2. **WordPress Volume (wpvol)**:
   - Path: `/home/antoda-s/data/wp`
   - Purpose: Stores WordPress files persistently.

### Network

- **Bridge Network**: Named `inception` to enable communication between the services.

---

## Deployment Steps

1. **Build the Images**:
   ```bash
   docker-compose build
   ```

2. **Run the Containers**:
   ```bash
   docker-compose up -d
   ```

3. **Verify the Setup**:
   - MariaDB: Ensure the database is initialized and accessible.
   - WordPress: Check that the site is running and configured.
   - Nginx: Verify HTTPS access to the WordPress site.

---

## Security Features

- **Encrypted Secrets**: Ensures sensitive data is not exposed in plain text.
- **SSL Certificates**: Provides secure communication using HTTPS.

---

## Conclusion

This setup ensures a secure, scalable, and easily manageable environment for running a WordPress site with MariaDB as the database and Nginx as the web server. The use of Docker and encrypted secrets enhances both portability and security.

