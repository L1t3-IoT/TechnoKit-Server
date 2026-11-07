from app.db import get_connection

EXPECTED_TABLES = {
    "manufacturers", "categories", "components", "motors", "batteries",
    "propellers", "frames", "escs", "flight_controllers", "stock",
    "drones", "drone_parts",
}


def test_all_tables_exist():
    with get_connection() as conn:
        rows = conn.execute(
            "SELECT table_name FROM information_schema.tables "
            "WHERE table_schema = 'public'"
        ).fetchall()
    assert EXPECTED_TABLES <= {r[0] for r in rows}


def test_can_insert_and_rollback():
    with get_connection() as conn:
        conn.execute("INSERT INTO manufacturers (name) VALUES ('__test__')")
        count = conn.execute(
            "SELECT count(*) FROM manufacturers WHERE name = '__test__'"
        ).fetchone()[0]
        assert count == 1
        conn.rollback()  # тестовий запис не зберігається
