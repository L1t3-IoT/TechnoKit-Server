import psycopg

from .config import DATABASE_URL


def get_connection() -> psycopg.Connection:
    """Повертає нове підключення до PostgreSQL.

    Використовуйте через `with`, щоб підключення закривалось автоматично:

        with get_connection() as conn:
            conn.execute("SELECT 1")
    """
    return psycopg.connect(DATABASE_URL)
