from flask import Blueprint, request, jsonify
from ai_agent import setup_infrastructure, fetch_env, fetch_backup

main = Blueprint("main", __name__)


@main.route("/test/setup")
def test_setup():
    return jsonify(setup_infrastructure())


@main.route("/test/env")
def test_env():
    app = request.args.get("app")
    device = request.args.get("device")
    return jsonify(fetch_env(app, device))


@main.route("/test/backup")
def test_backup():
    file = request.args.get("file")
    device = request.args.get("device")
    return jsonify(fetch_backup(file, device))
