import asyncio
import logging
import subprocess
import os
from dotenv import load_dotenv

# Load configuration from .env
load_dotenv()

MASTER_IP = os.getenv("MASTER_IP")
MASTER_USER = os.getenv("MASTER_USER")

INITIAL_INTERVAL = 5
MAX_INTERVAL = 180


logging.basicConfig(
    filename="external_watcher.log",
    level=logging.INFO,
    format="%(asctime)s - %(message)s"
)


def log(msg):
    logging.info(msg)
    print(msg)


async def ping_check():
    try:
        result = subprocess.call(
            ["ping", "-c", "1", MASTER_IP],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return result == 0
    except:
        return False


async def ssh_check():
    try:
        result = subprocess.call(
            ["ssh", f"{MASTER_USER}@{MASTER_IP}", "echo ok"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return result == 0
    except:
        return False


async def is_master_online():
    ping = await ping_check()
    ssh = await ssh_check()
    return ping and ssh


async def bootstrap_master():

    log("Master online – starting bootstrap process")

    commands = [
        f"ssh {MASTER_USER}@{MASTER_IP} 'sudo apt update -y'",

        f"ssh {MASTER_USER}@{MASTER_IP} 'sudo apt install -y docker.io python3 python3-pip'",

        f"ssh {MASTER_USER}@{MASTER_IP} 'sudo systemctl enable docker'",
        f"ssh {MASTER_USER}@{MASTER_IP} 'sudo systemctl start docker'",

        # Provide docker access to the configured user
        f"ssh {MASTER_USER}@{MASTER_IP} 'sudo usermod -aG docker {MASTER_USER}'",

        # Ensure group change takes effect
        f"ssh {MASTER_USER}@{MASTER_IP} 'newgrp docker || true'",

        # Start MCP server container
        f"ssh {MASTER_USER}@{MASTER_IP} 'docker start mcp-server || docker run -d --name mcp-server executor-runtime'"
    ]

    for cmd in commands:
        log(f"Executing: {cmd}")
        subprocess.call(cmd, shell=True)

    log("Bootstrap completed successfully")


async def watcher_loop():

    log("Starting external infrastructure watcher")

    if not MASTER_IP or not MASTER_USER:
        log("ERROR: MASTER_IP and MASTER_USER must be set in .env file")
        return

    interval = INITIAL_INTERVAL
    was_offline = False

    while True:

        online = await is_master_online()

        if online:

            if was_offline:
                log("Master just recovered – initiating bootstrap")
                await bootstrap_master()

            log("Master healthy")
            interval = INITIAL_INTERVAL
            was_offline = False

        else:

            log(f"Master offline – current interval {interval}s")

            was_offline = True

            interval = interval * 2

            if interval > MAX_INTERVAL:
                log("Max interval reached – resetting interval to 5 seconds")
                interval = INITIAL_INTERVAL

        await asyncio.sleep(interval)


def start_watcher():
    try:
        asyncio.run(watcher_loop())
    except KeyboardInterrupt:
        log("Watcher stopped manually")


if __name__ == "__main__":
    start_watcher()
