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
    visits = visits +1

    cur.execute(
	"Update counter SET visits = ?",
	(visits,)
    )

    conn.commit()

    conn.close()
    return f"""
    <html>

    <head>

    <title>Linux Week 2 Homework</title>

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

    <h1>Linux Week 2 Homework</h1>

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

    <p>
    <a href="https://github.com/HenkkaOAMK/linuxkurssi">
    https://github.com/HenkkaOAMK/linuxkurssi
    </a>
    </p>

    </div>

    <div class="section">

    <h2>Project infomation</h2>
    <p>
    I used MariaDB database, becouse teacher mentioned that in the class. Visitor count is stored in the database table called "Counter".
    Each page load increases the value by one and saves it back to the database.

    I also made requested reboot test. After the virtual machine was rebooted, visitor counter continued from its previous value

    </p>

    </div>

    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
