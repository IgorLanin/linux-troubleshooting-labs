import os
import time
from flask import Flask

app = Flask(__name__)

SLOW_MODE = os.getenv("SLOW_MODE", "0") == "1"

@app.route("/")
def home():
    if SLOW_MODE:
        time.sleep(10)
    return "Backend is up\n"

app.run(host="127.0.0.1", port=5000)
