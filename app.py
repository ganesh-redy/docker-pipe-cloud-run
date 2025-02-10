from flask import Flask, render_template, request
import os

app = Flask(__name__)

# Ensure /app/temp directory exists
if not os.path.exists("/app/temp"):
    os.makedirs("/app/temp")

# Home route - show the form
@app.route('/')
def form():
    return render_template('form.html')

# Handle form submission
@app.route('/submit', methods=['POST'])
def submit():
    name = request.form['name']
    age = request.form['age']
    email = request.form['email']

    # Define the file path
    file_path = "/app/temp/user_data.txt"

    # Store details in a file inside /app/temp
    with open(file_path, "a") as file:
        file.write(f"Name: {name}, Age: {age}, Email: {email}\n")

    return f"<h2>Thank you, {name}! Your details have been saved.</h2>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
