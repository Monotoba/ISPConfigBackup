### **ISPConfig Backup Script Manual**

This manual describes how to use the latest version of the ISPConfig backup script, which allows you to create a backup of ISPConfig data, including configuration files, email data, SSL certificates, cron jobs, web data, and now, database data. The script supports backing up either Apache2 or Nginx configuration files, depending on the server setup, and includes an option to back up databases (MySQL or MariaDB) if needed.

---

### **Script Overview**

The backup script is designed to create a compressed backup file (`.tar.gz`) containing the necessary ISPConfig configuration files and data. The script supports the following options:

- **`--web-data`**: Includes the `/var/www/` web data in the backup.
- **`--nginx`**: Backs up Nginx configuration files instead of Apache2 configuration files (default is Apache2).
- **`--databases`**: Backs up the databases used by ISPConfig (MySQL or MariaDB) alongside other configuration files and data.

---

### **Usage**

1. **Basic Backup (without Web Data, without Database, and with Apache2 Configurations)**:
   - This is the default behavior where ISPConfig data, Apache2 configuration files, and mail data are backed up, excluding web data and databases.
   ```bash
   ./backup_ispconfig.sh
   ```

2. **Backup with Web Data (Apache2 Configurations)**:
   - To include web data (`/var/www/`), use the `--web-data` flag. This is useful if you want to transfer the client website data along with configuration files.
   ```bash
   ./backup_ispconfig.sh --web-data
   ```

3. **Backup with Nginx Configurations (without Web Data)**:
   - If you're using Nginx instead of Apache2, use the `--nginx` flag. This will back up Nginx configuration files (`/etc/nginx/sites-available/` and `/etc/nginx/sites-enabled/`) instead of Apache2.
   ```bash
   ./backup_ispconfig.sh --nginx
   ```

4. **Backup with Nginx Configurations and Web Data**:
   - Use both the `--nginx` and `--web-data` flags to back up Nginx configuration files and include the website data.
   ```bash
   ./backup_ispconfig.sh --nginx --web-data
   ```

5. **Backup with Databases**:
   - To include databases (MySQL/MariaDB), use the `--databases` flag. This will back up the database data used by ISPConfig, along with configuration files and data.
   ```bash
   ./backup_ispconfig.sh --databases
   ```

6. **Backup with Nginx Configurations, Web Data, and Databases**:
   - Use all three flags to back up Nginx configuration files, web data, and databases.
   ```bash
   ./backup_ispconfig.sh --nginx --web-data --databases
   ```

---

### **Script Details**

#### **What the Backup Includes**

By default, the backup includes the following directories and files:

1. **ISPConfig Files:**
   - `/usr/local/ispconfig` — ISPConfig application files.
   - `/etc/ispconfig` — ISPConfig configuration files.

2. **Mail and DNS Configurations:**
   - `/etc/postfix` — Postfix configuration files.
   - `/etc/dovecot` — Dovecot configuration files.
   - `/etc/bind` — BIND (DNS) configuration files.

3. **SSL Certificates:**
   - `/etc/letsencrypt` — Let's Encrypt SSL certificates.

4. **Cron Jobs:**
   - `/var/spool/cron/crontabs` — User-specific cron jobs.

5. **Web Data (optional with `--web-data`):**
   - `/var/www` — Web data, typically where client websites and files are stored.

6. **Configuration Files (Apache2 or Nginx, based on flag):**
   - **Apache2 (default)**:
     - `/etc/apache2/sites-available`
     - `/etc/apache2/sites-enabled`
   - **Nginx (if `--nginx` flag is used)**:
     - `/etc/nginx/sites-available`
     - `/etc/nginx/sites-enabled`

7. **Databases (optional with `--databases`):**
   - All databases used by ISPConfig (MySQL/MariaDB) will be backed up, typically using `mysqldump`. The databases are included in the `.tar.gz` backup.

#### **Backup Process**

1. **Backup Creation:**
   - The script creates a `.tar.gz` archive of the selected directories, configuration files, and database dumps.
   - The archive file is named `ispconfig_backup_YYYYMMDD_HHMMSS.tar.gz`, where the timestamp corresponds to the date and time of the backup.

2. **Backup Location:**
   - By default, the backup file is saved to `/tmp/`, but you can modify the script to change this location if desired.

3. **SCP Transfer (for migration):**
   - After creating the backup, you can transfer it to the new server using `scp`:
     ```bash
     scp /tmp/ispconfig_backup_YYYYMMDD_HHMMSS.tar.gz user@new_server:/path/to/backup/directory
     ```

---

### **Restoring the Backup**

To restore the backup on the new server, follow these steps:

1. **Transfer the Backup to the New Server (if not already done):**
   - If the backup file is not yet transferred, use `scp` to copy it to the new server.
     ```bash
     scp /path/to/backup/ispconfig_backup_YYYYMMDD_HHMMSS.tar.gz user@new_server:/path/to/backup/directory
     ```

2. **Extract the Backup:**
   - On the new server, extract the backup file using `tar`:
     ```bash
     tar -xzf /path/to/backup/directory/ispconfig_backup_YYYYMMDD_HHMMSS.tar.gz -C /
     ```

3. **Restore Databases (if included):**
   - If you backed up databases, you'll need to restore them using `mysql` or `mariadb`:
     ```bash
     mysql -u root -p < /path/to/backup/databases.sql
     ```

4. **Set Correct Permissions:**
   - Ensure the correct ownership of the restored files. This is especially important for ISPConfig and web data:
     ```bash
     chown -R root:root /usr/local/ispconfig /etc/ispconfig /etc/postfix /etc/dovecot /etc/bind /var/vmail /etc/letsencrypt
     chown -R www-data:www-data /var/www  # For web data
     ```

5. **Restart Services:**
   - Restart the necessary services to apply the restored configurations:
     - For Nginx (if using Nginx):
       ```bash
       systemctl restart nginx
       ```
     - For Apache2 (if using Apache2):
       ```bash
       systemctl restart apache2
       ```
     - Restart other services like Postfix, Dovecot, BIND, and MySQL/MariaDB as needed:
       ```bash
       systemctl restart postfix dovecot bind mysql
       ```

---

### **Script Summary**

The updated script provides flexibility for backing up ISPConfig on a server with either Apache2 or Nginx and optionally includes web data and databases. The following key features have been added:

1. **`--web-data`**: Includes web data (`/var/www/`) in the backup.
2. **`--nginx`**: Backs up Nginx configuration files instead of Apache2.
3. **`--databases`**: Includes MySQL or MariaDB databases used by ISPConfig in the backup.

The script generates a `.tar.gz` backup file, which you can then transfer to a new server using `scp` and restore by extracting it and ensuring the correct permissions and service restarts.

---

### **Conclusion**

This backup solution ensures that you can easily migrate ISPConfig setups, including all essential configuration files, mail data, SSL certificates, web data, and databases, from one server to another. Whether using Apache2 or Nginx, the script adapts to your server configuration and makes the backup process efficient and simple.

---

This version of the manual now includes instructions for the new database backup feature and provides a comprehensive guide on how to use the script with the added database functionality.
