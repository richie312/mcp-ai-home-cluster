from flask import Blueprint, request, jsonify
from real_agent import handle_user_message

ai = Blueprint("ai", __name__)

@ai.route("/chat", methods=["POST"])
def chat():
    data = request.json
    msg = data.get("message")

    reply = handle_user_message(msg)

    return jsonify({"reply": reply})
