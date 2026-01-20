from mcp_client import execute, resolve_device


def setup_infrastructure():
    return execute("setup_infrastructure", [])


def fetch_env(app, device_name):
    device = resolve_device(device_name)

    return execute("fetch_env_files", [
        app,
        device["ip"],
        device["base_path"]
    ])


def fetch_backup(filename, device_name):
    device = resolve_device(device_name)

    return execute("fetch_backup", [
        filename,
        device["ip"],
        device["base_path"]
    ])
