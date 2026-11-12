"""Unit-тести побудови SQL. Базі даних не потрібні."""
import pytest

from app.query_builder import build_list_query


def test_no_filters():
    count_sql, count_params, items_sql, items_params = build_list_query()
    assert "WHERE" not in count_sql
    assert count_params == []
    assert "ORDER BY c.id ASC NULLS LAST" in items_sql
    assert items_params == [20, 0]


def test_pagination_offset():
    *_, items_params = build_list_query(page=3, page_size=10)
    assert items_params == [10, 20]


def test_filters_are_parametrized_in_order():
    count_sql, count_params, items_sql, items_params = build_list_query(
        category="motor", manufacturer="EMAX", min_price=100, max_price=900, search="eco"
    )
    assert count_sql.count("%s") == 5
    assert count_params == ["motor", "EMAX", 100, 900, "%eco%"]
    assert items_params == [*count_params, 20, 0]


def test_search_wildcards_are_escaped():
    *_, items_params = build_list_query(search="50%_x")
    assert items_params[0] == "%50\\%\\_x%"


def test_user_text_never_goes_into_sql():
    count_sql, _, items_sql, _ = build_list_query(category="x'; DROP TABLE components;--")
    assert "DROP" not in count_sql and "DROP" not in items_sql


def test_sort_by_price_has_tiebreaker():
    *_, items_sql, _ = build_list_query(sort="price", order="desc")
    assert "ORDER BY c.price DESC NULLS LAST, c.id" in items_sql


@pytest.mark.parametrize("kwargs", [
    {"sort": "price; DROP TABLE components"},
    {"order": "sideways"},
    {"page": 0},
    {"page_size": 0},
])
def test_invalid_arguments_rejected(kwargs):
    with pytest.raises(ValueError):
        build_list_query(**kwargs)
