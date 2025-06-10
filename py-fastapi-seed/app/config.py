import os
from dotenv import load_dotenv
from pathlib import Path

# Resolve path to config/.env from project root
env_path = Path(__file__).resolve().parents[1] / "config" / ".env"

print(f"Looking for .env at: {env_path}")
if not env_path.exists():
    print(".env file not found!")
else:
    print(".env file found")

load_dotenv(dotenv_path=env_path)
HELLO_MESSAGE = os.getenv("HELLO_MESSAGE", "All!")
PORT = int(os.getenv("PORT", 8000))
