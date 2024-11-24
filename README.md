# ISPConfigBackup

---

An ISPConfig 3 backup script to aid in migrating an ISPConfig installation from one server to another.

The script is designed to run on the origin (source) server. It will by default, generate a compressed file containing all config files needed for migration to a new server, except for the web data. Client websites can be very large, so I elected to transfer the web data separately. However, a flag (--web-data) can be passed to include the web data. Also by default, the script assumes an apache2 web-server however, a flag (--nginx) can be passed on the command-line to allow for an nginx web-server. 

Once the backup has been made, it can be transferred to the new (destination) server and restored. See the [manual](manual.md)


