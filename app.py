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
    return f"Visitor count: {visits}"

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
