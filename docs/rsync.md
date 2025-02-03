Here’s how to test **`rsync` in a Docker container**, in **Markdown** format:  

```md
# How to Test `rsync` in a Docker Container

## 1️⃣ Verify `rsync` is Installed in the Container
Run the following command inside your container:
```bash
docker exec -it <container_name> rsync --version
```
Expected output (example):
```
rsync  version 3.2.3  protocol version 31
```
If `rsync` is not installed, install it in a **Debian-based** container:
```bash
docker exec -it <container_name> sh -c "apt-get update && apt-get install -y rsync"
```
For **Alpine-based** containers:
```bash
docker exec -it <container_name> sh -c "apk add rsync"
```

---

## 2️⃣ Test `rsync` Inside the Container
Create test directories and files:
```bash
docker exec -it <container_name> sh -c "mkdir -p /tmp/source /tmp/destination && echo 'Hello, rsync!' > /tmp/source/file.txt"
```
Sync files inside the container:
```bash
docker exec -it <container_name> sh -c "rsync -av /tmp/source/ /tmp/destination/"
```
Verify the file is copied:
```bash
docker exec -it <container_name> sh -c "ls /tmp/destination/ && cat /tmp/destination/file.txt"
```

---

## 3️⃣ Test `rsync` Between a Host and a Container
To sync a directory from the **host to the container**:
```bash
rsync -av ./local_folder/ <container_name>:/container_folder/
```
To sync from the **container to the host**:
```bash
rsync -av <container_name>:/container_folder/ ./local_folder/
```
🔹 *Note:* You may need to use `docker cp` if `rsync` is not available in the container.

---

## 4️⃣ Test `rsync` Between Two Containers
Start two containers:
```bash
docker run -d --name container1 debian:bullseye sleep infinity
docker run -d --name container2 debian:bullseye sleep infinity
```
Install `rsync` in both containers:
```bash
docker exec -it container1 apt-get update && apt-get install -y rsync
docker exec -it container2 apt-get update && apt-get install -y rsync
```
Sync a file from `container1` to `container2`:
```bash
docker exec -it container1 sh -c "echo 'Sync test' > /tmp/test.txt"
docker exec -it container1 rsync -av /tmp/test.txt container2:/tmp/
```
Verify the file exists in `container2`:
```bash
docker exec -it container2 cat /tmp/test.txt
```

---

## 5️⃣ Debugging Common Issues

**🔹 `rsync: command not found`**
- Ensure `rsync` is installed inside the container.

**🔹 `Permission denied`**
- Check if the user inside the container has permission to access the files.

**🔹 `Connection refused` (for cross-container sync)**
- Use `docker network` to ensure containers can communicate.

---

✅ **Test successful if files are correctly transferred!** 🚀  
```