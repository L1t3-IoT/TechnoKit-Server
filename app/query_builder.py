"""Побудова SQL для списку деталей (фільтри, сортування, пагінація).

Без зовнішніх залежностей, тож перевіряється звичайним unit-тестом.
Значення користувача завжди йдуть параметрами (%s), а назви колонок для
сортування беруться лише з білого списку SORT_COLUMNS.
"""

FIELDS = """
    SELECT c.id, c.sku, c.name, cat.code AS category, mf.name AS manufacturer,
           c.weight_g, c.price, c.currency, c.description, c.specs,
           COALESCE(s.quantity, 0) AS in_stock
"""

BASE = """
    FROM components c
    JOIN categories cat        ON cat.id = c.category_id
    LEFT JOIN manufacturers mf ON mf.id = c.manufacturer_id
    LEFT JOIN stock s          ON s.component_id = c.id
"""

SORT_COLUMNS = {
    "id": "c.id",
    "name": "c.name",
    "price": "c.price",
    "weight": "c.weight_g",
}


def _escape_like(text: str) -> str:
    """Символи % та _ у пошуку сприймаємо як звичайні літери."""
    return text.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")


def build_list_query(page=1, page_size=20, category=None, manufacturer=None,
                     min_price=None, max_price=None, search=None,
                     sort="id", order="asc"):
    """Повертає (count_sql, count_params, items_sql, items_params)."""
    if sort not in SORT_COLUMNS:
        raise ValueError(f"Невідоме поле сортування: {sort!r}")
    if order not in ("asc", "desc"):
        raise ValueError(f"order має бути asc або desc, а не {order!r}")
    if page < 1 or page_size < 1:
        raise ValueError("page і page_size мають бути не менше 1")

    where, params = [], []
    if category:
        where.append("cat.code = %s")
        params.append(category)
    if manufacturer:
        where.append("mf.name = %s")
        params.append(manufacturer)
    if min_price is not None:
        where.append("c.price >= %s")
        params.append(min_price)
    if max_price is not None:
        where.append("c.price <= %s")
        params.append(max_price)
    if search:
        where.append("c.name ILIKE %s ESCAPE '\\'")
        params.append(f"%{_escape_like(search)}%")
    where_sql = ("WHERE " + " AND ".join(where)) if where else ""

    column = SORT_COLUMNS[sort]
    order_sql = f"ORDER BY {column} {order.upper()} NULLS LAST"
    if column != "c.id":
        order_sql += ", c.id"  # щоб сторінки не «пливли» при однакових значеннях

    count_sql = "SELECT count(*) AS n " + BASE + where_sql
    items_sql = (FIELDS + BASE + where_sql + f" {order_sql} LIMIT %s OFFSET %s")
    items_params = [*params, page_size, (page - 1) * page_size]
    return count_sql, params, items_sql, items_params
