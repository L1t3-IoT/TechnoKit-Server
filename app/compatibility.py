"""Сумісність деталей і перевірка збірок (на основі views з 007_compatibility.sql).

Статуси: ok — підходить, warn — працюватиме з застереженням,
fail — не підходить, unknown — бракує даних (це НЕ означає "несумісно").
Правила евристичні і не є гарантією польоту.
"""
from psycopg.rows import dict_row

from .db import get_connection

_ORDER = {"fail": 0, "warn": 1, "unknown": 2, "ok": 3}


def part_use_cases(sku: str) -> list[dict]:
    """Для яких цілей (сценаріїв) підходить деталь."""
    sql = """
        SELECT u.code, u.name, u.description
        FROM component_use_cases cuc
        JOIN components c ON c.id = cuc.component_id
        JOIN use_cases u  ON u.id = cuc.use_case_id
        WHERE c.sku = %s ORDER BY u.sort_order
    """
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        return cur.execute(sql, (sku,)).fetchall()


def check_pair(sku_a: str, sku_b: str) -> list[dict]:
    """Результати всіх правил для двох деталей (порядок у парі не важливий)."""
    sql = """
        SELECT pc.rule, pc.status, pc.message, a.name AS part_a, b.name AS part_b
        FROM v_pair_checks pc
        JOIN components a ON a.id = pc.a_id
        JOIN components b ON b.id = pc.b_id
        WHERE (a.sku = %(x)s AND b.sku = %(y)s) OR (a.sku = %(y)s AND b.sku = %(x)s)
    """
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        rows = cur.execute(sql, {"x": sku_a, "y": sku_b}).fetchall()
    return sorted(rows, key=lambda r: _ORDER[r["status"]])


def compatible_with(sku: str, category: str | None = None,
                    include_warn: bool = True) -> list[dict]:
    """Деталі, з якими поєднується задана (без жодного fail).

    category — код категорії результату (motor, battery, ...).
    include_warn=False залишає лише пари без застережень.
    """
    bad = ("fail",) if include_warn else ("fail", "warn")
    sql = """
        WITH pairs AS (
            SELECT pc.a_id AS me, pc.b_id AS other, pc.status FROM v_pair_checks pc
            UNION ALL
            SELECT pc.b_id, pc.a_id, pc.status FROM v_pair_checks pc
        )
        SELECT o.sku, o.name, cat.code AS category,
               bool_or(p.status = 'warn') AS has_warn,
               bool_and(p.status = 'unknown') AS only_unknown
        FROM pairs p
        JOIN components m ON m.id = p.me AND m.sku = %(sku)s
        JOIN components o ON o.id = p.other
        JOIN categories cat ON cat.id = o.category_id
        WHERE (%(cat)s::text IS NULL OR cat.code = %(cat)s)
        GROUP BY o.sku, o.name, cat.code
        HAVING NOT bool_or(p.status = ANY(%(bad)s))
        ORDER BY o.name
    """
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        return cur.execute(sql, {"sku": sku, "cat": category, "bad": list(bad)}).fetchall()


def check_drone(name: str) -> dict | None:
    """Підсумок збірки: verdict, лічильники, перелік перевірок і відсутні деталі.

    None, якщо збірки з такою назвою немає.
    """
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        summary = cur.execute(
            "SELECT * FROM v_drone_summary WHERE drone = %s", (name,)).fetchone()
        if summary is None:
            return None
        checks = cur.execute(
            "SELECT rule, status, message, part_a, part_b FROM v_drone_checks "
            "WHERE drone_id = %s", (summary["drone_id"],)).fetchall()
        missing = cur.execute(
            "SELECT * FROM v_drone_missing_parts WHERE drone_id = %s",
            (summary["drone_id"],)).fetchall()
    checks.sort(key=lambda r: _ORDER[r["status"]])
    return {"summary": summary, "checks": checks, "missing": missing}


def list_drones() -> list[dict]:
    """Усі збірки з вердиктом (ok / warn / fail)."""
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        return cur.execute(
            "SELECT drone, use_case, parts, ok, warn, fail, unknown, missing, verdict "
            "FROM v_drone_summary ORDER BY drone_id").fetchall()
