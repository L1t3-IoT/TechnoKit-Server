"""Тести API. Потрібна запущена база з виконаними міграціями (є дані з 004)."""
import pytest
from fastapi.testclient import TestClient

from app.api import app

client = TestClient(app)


def _first_id(**params):
    r = client.get("/api/components", params={"page_size": 1, **params})
    assert r.status_code == 200
    return r.json()["items"][0]["id"]


# ---------- GET /api/components/{id} ----------

def test_get_component_ok():
    cid = _first_id()
    r = client.get(f"/api/components/{cid}")
    assert r.status_code == 200
    body = r.json()
    assert body["id"] == cid
    for key in ("sku", "name", "category", "price", "currency", "specs", "in_stock", "details"):
        assert key in body


def test_get_motor_has_category_details():
    cid = _first_id(category="motor")
    body = client.get(f"/api/components/{cid}").json()
    assert body["category"] == "motor"
    assert "kv" in body["details"] and "stator_size" in body["details"]


def test_get_component_not_found():
    r = client.get("/api/components/999999999")
    assert r.status_code == 404
    assert r.json()["detail"] == "Component not found"


def test_get_component_invalid_id():
    assert client.get("/api/components/abc").status_code == 422


# ---------- GET /api/components ----------

def test_list_default_shape():
    body = client.get("/api/components").json()
    assert set(body) == {"items", "total", "page", "page_size", "pages"}
    assert body["page"] == 1 and body["page_size"] == 20
    assert len(body["items"]) <= 20


def test_pagination_pages_do_not_overlap():
    p1 = client.get("/api/components", params={"page": 1, "page_size": 10}).json()
    p2 = client.get("/api/components", params={"page": 2, "page_size": 10}).json()
    ids1 = {i["id"] for i in p1["items"]}
    ids2 = {i["id"] for i in p2["items"]}
    assert len(p1["items"]) == 10 and ids1.isdisjoint(ids2)
    assert p1["total"] == p2["total"]


def test_page_beyond_end_is_empty():
    body = client.get("/api/components", params={"page": 99999}).json()
    assert body["items"] == [] and body["total"] > 0


def test_filter_by_category():
    body = client.get("/api/components", params={"category": "motor", "page_size": 100}).json()
    assert body["total"] > 0
    assert {i["category"] for i in body["items"]} == {"motor"}


def test_filter_by_price_range():
    body = client.get("/api/components",
                      params={"min_price": 1000, "max_price": 1500, "page_size": 100}).json()
    assert body["total"] > 0
    assert all(1000 <= float(i["price"]) <= 1500 for i in body["items"])


def test_filter_by_manufacturer_and_search():
    body = client.get("/api/components", params={"manufacturer": "EMAX", "search": "eco"}).json()
    assert body["total"] > 0
    assert all(i["manufacturer"] == "EMAX" and "eco" in i["name"].lower() for i in body["items"])


def test_sort_by_price_desc():
    prices = [float(i["price"]) for i in
              client.get("/api/components", params={"sort": "price", "order": "desc",
                                                    "page_size": 100}).json()["items"]]
    assert prices == sorted(prices, reverse=True)


def test_unknown_category_gives_empty_list():
    body = client.get("/api/components", params={"category": "nope"}).json()
    assert body["items"] == [] and body["total"] == 0 and body["pages"] == 0


@pytest.mark.parametrize("params,status", [
    ({"page": 0}, 422),
    ({"page_size": 101}, 422),
    ({"sort": "hacker"}, 422),
    ({"order": "up"}, 422),
    ({"min_price": 500, "max_price": 100}, 400),
])
def test_bad_parameters(params, status):
    assert client.get("/api/components", params=params).status_code == status
