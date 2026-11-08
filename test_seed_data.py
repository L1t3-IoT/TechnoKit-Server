"""Перевіряє, що дані з таблиці завантажились у всі таблиці категорій."""
import pytest

from app.db import get_connection

CATEGORY_TABLE = {
    "frame": "frames", "motor": "motors", "prop": "propellers",
    "battery": "batteries", "stack": "stacks", "camera": "cameras",
    "vtx": "vtx", "antenna": "antennas", "rx": "receivers", "gps": "gps_modules",
}


@pytest.mark.parametrize("code,table", CATEGORY_TABLE.items())
def test_category_rows_match_detail_table(code, table):
    """Кількість деталей категорії = кількість рядків у її таблиці, і вона не нульова."""
    with get_connection() as conn:
        components = conn.execute(
            "SELECT count(*) FROM components c JOIN categories cat "
            "ON cat.id = c.category_id WHERE cat.code = %s", (code,)
        ).fetchone()[0]
        details = conn.execute(f"SELECT count(*) FROM {table}").fetchone()[0]
    assert components > 0
    assert components == details


def test_prices_are_in_uah_and_positive():
    with get_connection() as conn:
        bad = conn.execute(
            "SELECT count(*) FROM components WHERE currency <> 'UAH' OR price <= 0"
        ).fetchone()[0]
    assert bad == 0
