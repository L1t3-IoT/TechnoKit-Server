from psycopg import sql
from psycopg.types.json import Jsonb

from .db import get_connection

# Категорія -> таблиця зі специфічними характеристиками.
CATEGORY_TABLE = {
    "frame": "frames",
    "motor": "motors",
    "prop": "propellers",
    "battery": "batteries",
    "esc": "escs",
    "fc": "flight_controllers",
    "stack": "stacks",
    "camera": "cameras",
    "vtx": "vtx",
    "antenna": "antennas",
    "rx": "receivers",
    "gps": "gps_modules",
}

# Дозволені колонки кожної таблиці (захист від помилок у назвах полів).
DETAIL_COLUMNS = {
    "frames": {"wheelbase_mm", "max_prop_in", "stack_mount_mm", "material",
               "size_in", "arm_thickness_mm", "wingspan_mm", "frame_type"},
    "motors": {"stator_size", "kv", "kv_max", "max_current_a", "max_thrust_g",
               "shaft_mm", "mount_mm", "voltage_cells"},
    "propellers": {"diameter_in", "pitch_in", "blades", "hole_mm"},
    "batteries": {"cells_s", "cells_s_max", "capacity_mah", "capacity_mah_max",
                  "c_rating", "max_discharge_a", "chemistry", "connector"},
    "escs": {"max_current_a", "min_cells_s", "max_cells_s", "protocol", "mount_mm"},
    "flight_controllers": {"mcu", "firmware", "mount_mm", "uarts"},
    "stacks": {"variant", "mcu", "esc_current_a", "esc_current_a_max",
               "esc_peak_a", "mount_mm", "firmware", "esc_firmware"},
    "cameras": {"camera_type", "signal", "resolution_tvl", "lens_mm",
                "form_factor", "has_thermal", "has_gimbal"},
    "vtx": {"link_type", "power_min_mw", "power_max_mw", "frequency_ghz",
            "channels", "protocol", "connector"},
    "antennas": {"frequency_ghz", "polarization", "gain_dbi", "length_mm", "connector"},
    "receivers": {"frequency", "protocol", "update_rate_hz", "diversity"},
    "gps_modules": {"chip", "compass", "constellations", "rtk", "visual_nav", "protocol"},
}


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
                   weight_g, price, specs, quantity,
                   description=None, currency="UAH") -> int:
    cat = conn.execute(
        "SELECT id FROM categories WHERE code = %s", (category_code,)
    ).fetchone()
    if cat is None:
        raise ValueError(f"Невідома категорія: {category_code!r}")

    manufacturer_id = _get_or_create_manufacturer(conn, manufacturer)

    component_id = conn.execute(
        """
        INSERT INTO components
            (sku, name, category_id, manufacturer_id, weight_g, price,
             currency, description, specs)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id
        """,
        (sku, name, cat[0], manufacturer_id, weight_g, price,
         currency, description, Jsonb(specs or {})),
    ).fetchone()[0]

    if quantity:
        conn.execute(
            "INSERT INTO stock (component_id, quantity) VALUES (%s, %s)",
            (component_id, quantity),
        )
    return component_id


def add_part(category_code, sku, name, details=None, manufacturer=None,
             weight_g=None, price=None, currency="UAH", description=None,
             specs=None, quantity=0) -> int:
    """Універсальне додавання деталі будь-якої категорії.

    category_code: frame, motor, prop, battery, stack, camera, vtx,
                   antenna, rx, gps (або esc, fc, other)
    details: словник характеристик для таблиці цієї категорії, напр.
             {"camera_type": "analog", "resolution_tvl": 1200}
    """
    details = details or {}
    table = CATEGORY_TABLE.get(category_code)
    if table is None and details:
        raise ValueError(f"Для категорії {category_code!r} немає окремої таблиці; "
                         "використовуйте specs замість details")
    if table is not None:
        unknown = set(details) - DETAIL_COLUMNS[table]
        if unknown:
            raise ValueError(f"Невідомі поля для {table}: {sorted(unknown)}. "
                             f"Доступні: {sorted(DETAIL_COLUMNS[table])}")

    with get_connection() as conn:
        cid = _add_component(conn, sku, name, category_code, manufacturer,
                             weight_g, price, specs, quantity, description, currency)
        if table is not None:
            columns = ["component_id", *details]
            query = sql.SQL("INSERT INTO {} ({}) VALUES ({})").format(
                sql.Identifier(table),
                sql.SQL(", ").join(sql.Identifier(c) for c in columns),
                sql.SQL(", ").join(sql.Placeholder() for _ in columns),
            )
            conn.execute(query, [cid, *details.values()])
        return cid


def add_motor(sku, name, stator_size, kv, manufacturer=None, weight_g=None,
              price=None, max_current_a=None, max_thrust_g=None,
              shaft_mm=None, mount_mm=None, quantity=0) -> int:
    return add_part(
        "motor", sku, name, manufacturer=manufacturer, weight_g=weight_g,
        price=price, quantity=quantity,
        details={"stator_size": stator_size, "kv": kv, "max_current_a": max_current_a,
                 "max_thrust_g": max_thrust_g, "shaft_mm": shaft_mm, "mount_mm": mount_mm},
    )


def add_battery(sku, name, cells_s, capacity_mah, manufacturer=None,
                weight_g=None, price=None, c_rating=None, chemistry="LiPo",
                connector=None, quantity=0) -> int:
    return add_part(
        "battery", sku, name, manufacturer=manufacturer, weight_g=weight_g,
        price=price, quantity=quantity,
        details={"cells_s": cells_s, "capacity_mah": capacity_mah, "c_rating": c_rating,
                 "chemistry": chemistry, "connector": connector},
    )


def add_other(sku, name, category_code, manufacturer=None, weight_g=None,
              price=None, specs=None, quantity=0) -> int:
    """Для категорії other та будь-яких деталей без окремої таблиці:
    характеристики йдуть у specs (JSON)."""
    return add_part(category_code, sku, name, manufacturer=manufacturer,
                    weight_g=weight_g, price=price, specs=specs, quantity=quantity)
