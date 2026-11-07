from psycopg.rows import dict_row

from .db import get_connection


def search_motors(kv_min: int = 0, kv_max: int = 100_000) -> list[dict]:
    """Моторі із заданого діапазону KV разом із виробником і залишком на складі."""
    sql = """
        SELECT c.sku, c.name, mf.name AS manufacturer,
               m.stator_size, m.kv, m.max_thrust_g, c.price,
               COALESCE(s.quantity, 0) AS in_stock
        FROM motors m
        JOIN components c          ON c.id = m.component_id
        LEFT JOIN manufacturers mf ON mf.id = c.manufacturer_id
        LEFT JOIN stock s          ON s.component_id = c.id
        WHERE m.kv BETWEEN %s AND %s
        ORDER BY m.kv
    """
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        return cur.execute(sql, (kv_min, kv_max)).fetchall()


def find_by_category(category_code: str) -> list[dict]:
    """Усі деталі однієї категорії (motor, battery, prop, ...)."""
    sql = """
        SELECT c.sku, c.name, c.weight_g, c.price
        FROM components c
        JOIN categories cat ON cat.id = c.category_id
        WHERE cat.code = %s
        ORDER BY c.name
    """
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        return cur.execute(sql, (category_code,)).fetchall()


def esc_fits_battery(esc_sku: str, battery_sku: str) -> bool:
    """Перевіряє, чи підтримує регулятор кількість банок акумулятора."""
    sql = """
        SELECT b.cells_s BETWEEN e.min_cells_s AND e.max_cells_s
        FROM escs e
        JOIN components ce ON ce.id = e.component_id AND ce.sku = %s
        CROSS JOIN batteries b
        JOIN components cb ON cb.id = b.component_id AND cb.sku = %s
    """
    with get_connection() as conn:
        row = conn.execute(sql, (esc_sku, battery_sku)).fetchone()
    return bool(row and row[0])


def total_weight(drone_name: str) -> float:
    """Сумарна вага збірки в грамах."""
    sql = """
        SELECT COALESCE(SUM(c.weight_g * dp.quantity), 0)
        FROM drones d
        JOIN drone_parts dp ON dp.drone_id = d.id
        JOIN components c   ON c.id = dp.component_id
        WHERE d.name = %s
    """
    with get_connection() as conn:
        return float(conn.execute(sql, (drone_name,)).fetchone()[0])
