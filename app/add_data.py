from psycopg.types.json import Jsonb

from .db import get_connection


def _get_or_create_manufacturer(conn, name: str | None) -> int | None:
    if not name:
        return None
    row = conn.execute(
        """
        INSERT INTO manufacturers (name) VALUES (%s)
        ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name
        RETURNING id
        """,
        (name,),
    ).fetchone()
    return row[0]


def _add_component(conn, sku, name, category_code, manufacturer,
                   weight_g, price, specs, quantity) -> int:
    cat = conn.execute(
        "SELECT id FROM categories WHERE code = %s", (category_code,)
    ).fetchone()
    if cat is None:
        raise ValueError(f"Невідома категорія: {category_code!r}")

    manufacturer_id = _get_or_create_manufacturer(conn, manufacturer)

    component_id = conn.execute(
        """
        INSERT INTO components
            (sku, name, category_id, manufacturer_id, weight_g, price, specs)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        RETURNING id
        """,
        (sku, name, cat[0], manufacturer_id, weight_g, price, Jsonb(specs or {})),
    ).fetchone()[0]

    if quantity:
        conn.execute(
            "INSERT INTO stock (component_id, quantity) VALUES (%s, %s)",
            (component_id, quantity),
        )
    return component_id


def add_motor(sku, name, stator_size, kv, manufacturer=None, weight_g=None,
              price=None, max_current_a=None, max_thrust_g=None,
              shaft_mm=None, mount_mm=None, quantity=0) -> int:
    with get_connection() as conn:
        cid = _add_component(conn, sku, name, "motor", manufacturer,
                             weight_g, price, None, quantity)
        conn.execute(
            """
            INSERT INTO motors (component_id, stator_size, kv, max_current_a,
                                max_thrust_g, shaft_mm, mount_mm)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (cid, stator_size, kv, max_current_a, max_thrust_g, shaft_mm, mount_mm),
        )
        return cid


def add_battery(sku, name, cells_s, capacity_mah, manufacturer=None,
                weight_g=None, price=None, c_rating=None, chemistry="LiPo",
                connector=None, quantity=0) -> int:
    with get_connection() as conn:
        cid = _add_component(conn, sku, name, "battery", manufacturer,
                             weight_g, price, None, quantity)
        conn.execute(
            """
            INSERT INTO batteries (component_id, cells_s, capacity_mah,
                                   c_rating, chemistry, connector)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (cid, cells_s, capacity_mah, c_rating, chemistry, connector),
        )
        return cid


def add_other(sku, name, category_code, manufacturer=None, weight_g=None,
              price=None, specs=None, quantity=0) -> int:
    """Для камер, VTX, GPS, приймачів та інших: характеристики йдуть у specs (JSON)."""
    with get_connection() as conn:
        return _add_component(conn, sku, name, category_code, manufacturer,
                              weight_g, price, specs, quantity)
