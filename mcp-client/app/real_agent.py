import json
from openai import OpenAI
from dotenv import load_dotenv
import os

from mcp_client import execute, resolve_device

load_dotenv()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


TOOLS = [
    {
        "type": "function",
        "function": {
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
    }
]


def handle_user_message(message):

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": message}],
        tools=TOOLS,
        tool_choice="auto"
    )

    message_obj = response.choices[0].message

    if message_obj.tool_calls:

        call = message_obj.tool_calls[0]

        args = json.loads(call.function.arguments)

        device = resolve_device(args["device"])

        result = execute(
            "fetch_env_files",
            [args["app"], device["ip"], device["base_path"]]
        )

        return f"Executed fetch_env_files: {result}"

    return message_obj.content
