from flask import Flask

from routes.main_routes import main
from routes.ai_routes import ai

app = Flask(__name__)

# Existing manual test routes
app.register_blueprint(main)

# NEW: Real AI agent routes
app.register_blueprint(ai)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=6000)
