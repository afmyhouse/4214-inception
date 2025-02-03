Here’s how to test **Redis** in **Markdown** format:  

```md
# How to Test Redis in Docker

## 1️⃣ Check if Redis Container is Running
Run the following command to verify that Redis is running:  
```bash
docker ps | grep redis
```
If it's not running, start it with:  
```bash
docker start <redis-container-name>
```
Or, if not created yet:
```bash
docker run --name redis -d -p 6379:6379 redis
```
(Default Redis runs on port **6379**).

---

## 2️⃣ Connect to Redis CLI Inside the Container
Run the following command:
```bash
docker exec -it <redis-container-name> redis-cli
```
If successful, you should see a **Redis prompt** like this:
```shell
127.0.0.1:6379>
```

---

## 3️⃣ Run Basic Redis Commands
Once inside the Redis CLI, test with:
```bash
PING
```
Expected response:
```
PONG
```
To set and retrieve a key:
```bash
SET mykey "Hello Redis"
GET mykey
```
Expected output:
```
"Hello Redis"
```

---

## 4️⃣ Test Connection from the Host
If Redis is running on the host and exposed on **port 6379**, you can test it using:
```bash
redis-cli -h <your-redis-host-ip> -p 6379
```
Then, run:
```bash
PING
```
If you get **PONG**, Redis is working.

---

## 5️⃣ Debugging Common Issues
**🔹 Redis Connection Refused?**
- Check if the Redis container is running:
  ```bash
  docker ps | grep redis
  ```
- Verify if Redis is listening on **port 6379**:
  ```bash
  docker logs <redis-container-name>
  ```
- If using **Docker Compose**, ensure the Redis service is accessible from other containers.

---
