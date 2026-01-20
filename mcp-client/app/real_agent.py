import json
import openai
from dotenv import load_dotenv
import os

from mcp_client import execute, resolve_device

# Load environment variables from .env
load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")


TOOLS = [
    {
        "name": "fetch_env_files",
        "description": "Fetch env file for an application from a specific device",
        "parameters": {
            "type": "object",
            "properties": {
                "app": {"type": "string"},
                "device": {"type": "string"}
            },
            "required": ["app", "device"]
        }
    }
]


def handle_user_message(message):

    response = openai.ChatCompletion.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": message}],
        tools=TOOLS,
        tool_choice="auto"
    )

    message_obj = response.choices[0].message

    # If AI wants to call a tool
    if message_obj.get("tool_calls"):

        call = message_obj["tool_calls"][0]

        args = json.loads(call["function"]["arguments"])

        device = resolve_device(args["device"])

        result = execute(
            "fetch_env_files",
            [args["app"], device["ip"], device["base_path"]]
        )

        return f"Executed fetch_env_files: {result}"

    # Normal text response
    return message_obj.get("content")
