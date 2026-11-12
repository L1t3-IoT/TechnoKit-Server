"""REST API для каталогу деталей.

Запуск:  uvicorn app.api:app --reload
Документація і спроби запитів: http://localhost:8000/docs
"""
from math import ceil
from typing import Literal

from fastapi import FastAPI, HTTPException, Query
from psycopg import sql
from psycopg.rows import dict_row

from .add_data import CATEGORY_TABLE
from .db import get_connection
from .query_builder import BASE, FIELDS, build_list_query

app = FastAPI(title="Drone components API")


@app.get("/api/components/{component_id}")
def get_component(component_id: int):
    """Одна деталь за id разом із характеристиками її категорії (details)."""
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        row = cur.execute(FIELDS + BASE + " WHERE c.id = %s", (component_id,)).fetchone()
        if row is None:
            raise HTTPException(status_code=404, detail="Component not found")

        details = None
        table = CATEGORY_TABLE.get(row["category"])
        if table:
            found = cur.execute(
                sql.SQL("SELECT to_jsonb(t) - 'component_id' AS d FROM {} t "
                        "WHERE t.component_id = %s").format(sql.Identifier(table)),
                (component_id,),
            ).fetchone()
            details = found["d"] if found else None

    row["details"] = details
    return row


@app.get("/api/components")
def list_components(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    category: str | None = None,
    manufacturer: str | None = None,
    min_price: float | None = Query(None, ge=0),
    max_price: float | None = Query(None, ge=0),
    search: str | None = None,
    sort: Literal["id", "name", "price", "weight"] = "id",
    order: Literal["asc", "desc"] = "asc",
):
    """Список деталей: пагінація (page, page_size), фільтри й сортування."""
    if min_price is not None and max_price is not None and min_price > max_price:
        raise HTTPException(status_code=400, detail="min_price must be <= max_price")

    count_sql, count_params, items_sql, items_params = build_list_query(
        page, page_size, category, manufacturer, min_price, max_price,
        search, sort, order,
    )
    with get_connection() as conn, conn.cursor(row_factory=dict_row) as cur:
        total = cur.execute(count_sql, count_params).fetchone()["n"]
        items = cur.execute(items_sql, items_params).fetchall()

    return {
        "items": items,
        "total": total,
        "page": page,
        "page_size": page_size,
        "pages": ceil(total / page_size) if total else 0,
    }
