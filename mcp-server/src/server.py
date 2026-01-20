from flask import Flask, request, jsonify
import os

app = Flask(__name__)

ALLOWED_ACTIONS = [
    "fetch_env_files",
    "fetch_backup",
    "setup_infrastructure"
]


def run_executor(action, params):

    param_str = " ".join(params)

    cmd = (
        "docker run --rm "
        "-v /var/run/docker.sock:/var/run/docker.sock "
        "-v /home/richie/executor.env:/executor/runtime.env "
        "executor-runtime "
        f"{action} {param_str}"
    )

    rc = os.system(cmd)
    return rc


@app.route("/mcp/execute", methods=["POST"])
def execute():

    data = request.json

    action = data.get("action")
    params = data.get("params", [])

    if not action:
        return jsonify({"error": "action is required"}), 400

    if action not in ALLOWED_ACTIONS:
        return jsonify({"error": f"unsupported action: {action}"}), 400

    rc = run_executor(action, params)

    return jsonify({
        "action": action,
        "return_code": rc
    })


@app.route("/mcp/actions", methods=["GET"])
def list_actions():
    return jsonify({
        "available_actions": ALLOWED_ACTIONS
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
