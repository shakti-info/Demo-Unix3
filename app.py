import os
from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)

# Configure MySQL from environment variables
app.config['MYSQL_HOST'] = '127.0.0.1'   # use IP, not localhost
app.config['MYSQL_PORT'] = 33061          # explicitly set port
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Zx123@123@123'
app.config['MYSQL_DB'] = 'mydb'


# Initialize MySQL
mysql = MySQL(app)

@app.route('/')
def hello():
    try:
        cur = mysql.connection.cursor()
        # Fixed: Select all message columns properly
        cur.execute('SELECT new_message, second_message FROM messages')
        messages = cur.fetchall()
        cur.close()
        return render_template('index.html', messages=messages)
    except Exception as e:
        return f"Database error: {str(e)}", 500

@app.route('/submit', methods=['POST'])
def submit():
    try:
        new_message = request.form.get('new_message')
        second_message = request.form.get('second_message')
        
        cur = mysql.connection.cursor()
        
        # Fixed: Insert both messages in a single query if both provided
        if new_message and second_message:
            cur.execute('INSERT INTO messages (new_message, second_message) VALUES (%s, %s)', 
                       (new_message, second_message))
        elif new_message:
            cur.execute('INSERT INTO messages (new_message) VALUES (%s)', [new_message])
        elif second_message:
            cur.execute('INSERT INTO messages (second_message) VALUES (%s)', [second_message])
        else:
            cur.close()
            return redirect(url_for('hello'))  # No data to insert
            
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('hello'))
    except Exception as e:
        return f"Database error: {str(e)}", 500

# Fixed: Correct syntax for main check
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
