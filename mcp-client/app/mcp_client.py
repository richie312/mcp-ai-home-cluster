import requests
import json
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()
MCP_SERVER = os.getenv("MCP_SERVER")
with open("devices.json") as f:
    DEVICES = json.load(f)["devices"]


def resolve_device(name):
    return DEVICES.get(name)


def execute(action, params):
    payload = {
        "action": action,
        "params": params
    }

    r = requests.post(f"{MCP_SERVER}/mcp/execute", json=payload)
    return r.json()
