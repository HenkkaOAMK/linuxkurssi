from flask import Flask
import mariadb

app = Flask(__name__)

@app.route("/")
def week2():
    conn = mariadb.connect(
	user="henkka",
	password="neokoda85",
	host="localhost",
	database="week2"
    )

    cur = conn.cursor()
    cur.execute("SELECT visits FROM counter")

    visits = cur.fetchone()[0]

    conn.close()
    return f"""
    <html>

    <head>

    <title>Linux Week 4 Replica Server</title>

    <style>

    body {{
    	background-color: #000000;
	color: #FF0000;
	font-family: courier new;
	max-width: 800px;
	margin: 40px auto;
	padding: 0 20px;
	font-size: 20px;
	line-height: 1.6;
    }}

    h1, h2 {{
	color: #00FF66;
    }}

    .counter-box {{
	border: 3px solid #FF0000;
	padding: 20px;
	margin: 20px auto;
	text align: center;
	background:#111111;
	width: 300px;
    }}

    .counter-value {{
	font-size: 40px;
	color: #00FF66;
	font-weight: bold;
    }}

    .section {{
	margin-top: 30px;
    }}

    a {{
	color: #80cfff;
    }}

    </style>
    </head>

    <body>

    <h1>Linux Week 4 Read-only Replica Server</h1>

    <h2>Visitor counter</h2>
    <div class="counter-box">

    <p>Current visitor count</p>
    <div class="counter-value">
    {visits}
    </div>
    </div>
    </div>

    <div class="section">

    <h2>GitHub repository</h2>

    <p>This repository contains information from week4 project. <div>
    <a href="https://github.com/HenkkaOAMK/linuxkurssi/tree/main/viikko4">
    https://github.com/HenkkaOAMK/linuxkurssi/viikko4 <div>
    </a>
    Passwords and other sensitive information are excluded.
    </p>

    </div>

    <div class="section">

    <h2>Project infomation</h2>
    <p>
    The idea of this project was to make a second server by cloning the original A server. New server needs its own
    IP address. Then cron was used to back up A's /var/www/html directory to B once
    per hour.
    <div>
    Also I needed to make continuous MariaDB replication from A to B. When server A's web site is
    refreshed, visitor count rises, but when refreshing server B's website, visitor count won't rise. 
    Only if A's count changes then also B's count changes. Server B uses replicated read-only database.

    </p>

    <h2>Links to both web pages</h2>
    <p> Server A:
    <a href="http://195.148.21.231/viikko2/">
    http://195.148.21.231/viikko2/
    </a>
    <div>
    <p> Server B:
    <a href="http://193.167.189.66/viikko4/">
    http://193.167.189.66/viikko4/
    </a>
    </p>

    <h2>How server B was created</h2>
    <p>
    Server in cPouta B was created taking a snapshot of Server A. Snapshot named henkkalinux2 was created and
    it was used to launc new virtual machine named henkkalinuxb. New server got it's own floating IP address
    and used same SSH key pair.
    </p>

    <h2>Storage layout and backup locations</h2>
    <p>
    Website files are stored in /var/www/html. Timestamped backups are stored on Server B in /var/backups/www. 
    <div>
    Backups are done using rsync over SSH and stored outside publicly accessible web directories.
    <div>
    Backup script location: /usr/local/bin/www-backup.sh. <div>
    Backup files storage: /var/backups/www.
    </p>

    <h2>Users, ownership and permissions</h2>
    <p>
    Linux admin user is ubuntu. Website backups use dedicated SSH key: /root/.ssh/sync_ed25519.
    <div>
    MariaDB replication uses a dedicated database user called replicator. Backup files are stored in directories
    owned by root.
    <div<
    Backup directories are owned by root and are not stored inside publicly accessible web directories.
    </p>

    <h2>Dapabase replication and backup schedule</h2>
    <p>
    MariaDB replication was configured from Server A to Server B. Server A is the primary database server and writes
    changes to logs. Server B is read-only replica and gets changes from server A. Week 4 webpage  reads data from
    Server B's local replicated database.
    <div>
    Continuous replication does not replace backups becouse accidental changes are also replicated. Backups allow
    recovery of earlier versions.
    <div>
    Backup schedule: Once per hour using Cron setting: 0 * * * *.
    </p>

    <h2>Test results</h2>
    <ul>
    <li>Both websites are publicly accesible -> OK<div>
    <li>Loading page A updates counter displayd on page B -> OK <div>
    <li>Loading page B does not increment the counter -> OK <div>
    <li>Database replication reports normal operation ->OK <div>
    <li>Multiple scheduled file backups succeed -> OK <div>
    <li>Restored test file matches the original -> OK <div>
    <li>B's website, replication and backup schedule continue working after B was rebooted -> OK <div>
    </li>
    </ul>
    <p>Backup verification:<div>
    /var/backup/www<div>
    20261118-070001 -> OK<div>
    20261118-080001 -> OK<div>
    20261118-090001 -> OK<div>
    <div>
    <h2>Problem solved</h2>
    <p>
    Week 4 application failed first becouse it was using same port 5000 that week 2 used. I changed the port to
    5001 and problem was solved.
    </p>
    </div>

    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5001)
