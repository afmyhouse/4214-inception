Here is how to test **Adminer**, in a Docker environment.

---

### **1️⃣ Check if Adminer is Running**
Run the following command to check if the Adminer container is running:  
```bash
docker ps | grep adminer
```
If it’s not running, start it with:
```bash
docker start <adminer-container-name>
```
Or, if you haven't started it yet:
```bash
docker run --name adminer -d -p 8080:8080 adminer
```
(Default Adminer runs on port **8080**).

---

### **2️⃣ Open Adminer in a Web Browser**
Go to:
```
http://localhost:8080
```
Or, if running remotely:
```
http://<your-server-ip>:8080
```

---

### **3️⃣ Log in to Adminer**
On the Adminer login page:
- **System**: Select **MariaDB** (or **MySQL**)
- **Server**: `mariadb` (if using Docker Compose) or `localhost` (if running directly)
- **Username**: Your MariaDB/MySQL username (e.g., `root`)
- **Password**: Your MariaDB/MySQL password
- **Database**: Leave empty to see all databases or enter a specific one.

Click **Login** to access the database.

---

### **4️⃣ Verify Connection**
- If you can log in and see databases, Adminer is working correctly.
- If you get **connection errors**, check:
  ```bash
  docker logs <adminer-container-name>
  ```
  or verify if MariaDB is running:
  ```bash
  docker ps | grep mariadb
  ```

---

### **5️⃣ Debugging Common Issues**
**🔹 Adminer Can’t Connect to Database?**
- Check if the `mariadb` container is running.
- Ensure MariaDB is listening on the correct host/port (`3306` by default).
- If using **Docker Compose**, confirm Adminer and MariaDB are in the same network.

---
