from flask import Flask
from routes import hci_blueprint
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.config['SECRET_KEY'] = 'somethingsupers3cr3t!23$%^'
app.register_blueprint(hci_blueprint)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)