An `init.sql` file isn’t strictly necessary if your `init.sh` script already handles database and user creation effectively. However, in some cases, using an `init.sql` file can make your setup more modular or easier to manage, especially if you have a complex schema or need to pre-load specific data.

### When to Use `init.sql`
- **Complex Database Initialization**: If you have a large amount of SQL data or multiple tables and relationships to initialize.
- **Easier Debugging and Reuse**: If you prefer to have SQL commands separate from the shell script, making it easier to test and reuse.

### How to Implement `init.sql` (Optional)

1. **Create the `init.sql` File**
   Place your SQL commands in `init.sql`, which would look something like this:

   ```sql
   CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
   CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
   CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';
   GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
   GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_ADMIN_USER}'@'%';
   FLUSH PRIVILEGES;
   ```

2. **Update `init.sh` to Source `init.sql`**
   Modify `init.sh` to source the SQL file:

   ```bash
   # Start MariaDB in the background
   mysqld_safe --datadir='/var/lib/mysql' &

   # Wait until MariaDB is up
   until mysqladmin ping >/dev/null 2>&1; do
       echo "Waiting for MariaDB to start..."
       sleep 2
   done

   # Run the SQL file
   mysql -u root < /path/to/init.sql

   # Stop MariaDB gracefully
   mysqladmin shutdown
   ```

3. **Copy `init.sql` to the Container**
   Add a line in the `Dockerfile` to copy `init.sql` to the appropriate location, matching the path in `init.sh`.

   ```dockerfile
   COPY conf/init.sql /path/to/init.sql
   ```

### Best Practice
If your project is simple, relying solely on `init.sh` should be enough. If you prefer separation for maintainability, `init.sql` is a good choice.