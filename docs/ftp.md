Here’s how to **test FTP in a Docker container**

# How to Test FTP in a Docker Container

## 1️⃣ Verify FTP Server is Running
Check if the FTP container is running:
```bash
docker ps | grep <ftp_container_name>
```
If it’s not running, start it:
```bash
docker start <ftp_container_name>
```

---

## 2️⃣ Connect to FTP from the Host Machine
Use `ftp` or `lftp` from the host:
```bash
ftp <ftp_container_ip>
```
Or using `lftp`:
```bash
lftp -u <username>,<password> <ftp_container_ip>
```
For Docker Compose, find the container’s IP:
```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <ftp_container_name>
```

---

## 3️⃣ Test FTP from Inside the Container
Run an interactive shell in the container:
```bash
docker exec -it <ftp_container_name> sh
```
Check if the FTP service is running:
```bash
ps aux | grep ftp
```
Try connecting from within the container:
```bash
ftp localhost
```

---

## 4️⃣ Test FTP File Upload & Download
Upload a test file:
```bash
echo "FTP Test File" > test.txt
ftp <ftp_container_ip>
```
Inside the FTP session:
```ftp
put test.txt
ls
```
Download the file back:
```ftp
get test.txt
```

---

## 5️⃣ Debugging Common Issues

**🔹 `Connection refused`**
- Ensure the FTP service is running in the container.
- Check if the FTP port (usually **21**) is exposed.

**🔹 `Login incorrect`**
- Verify the username and password.
- Check FTP user permissions inside the container.

**🔹 `Passive mode failed`**
- Ensure passive mode ports are open in the container:
  ```bash
  docker run -p 21:21 -p 21000-21010:21000-21010 <ftp_image>
  ```
- Add passive mode settings in `vsftpd.conf`:
  ```
  pasv_enable=YES
  pasv_min_port=21000
  pasv_max_port=21010
  ```

✅ **Test successful if you can upload & download files!** 🚀  
```