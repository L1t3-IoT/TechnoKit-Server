import os

from dotenv import load_dotenv

# Підтягує змінні з файлу .env у середовище процесу
load_dotenv()

DATABASE_URL = os.environ["DATABASE_URL"]
