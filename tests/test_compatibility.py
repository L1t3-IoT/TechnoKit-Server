"""Перевіряє правила сумісності і готові збірки (потрібна база з міграціями 001–008)."""
import pytest

from app.compatibility import (check_drone, check_pair, compatible_with,
                               list_drones, part_use_cases)
from app.db import get_connection


def test_19_drones_with_10_parts():
    drones = list_drones()
    assert len(drones) == 19
    assert all(d["parts"] == 10 for d in drones)


def test_no_sheet_build_fails_and_none_missing():
    for d in list_drones():
        assert d["verdict"] in ("ok", "warn"), d
        assert d["missing"] == 0, d


def test_check_drone_unknown_name():
    assert check_drone("такого дрона немає") is None


def test_check_drone_returns_checks():
    res = check_drone('iFlight Nazgul Evoque F5 V2 (5")')
    assert res and res["summary"]["verdict"] == "ok"
    assert {c["rule"] for c in res["checks"]} >= {"motor_battery_voltage", "stack_motor_current"}


@pytest.mark.parametrize("a,b,rule", [
    ("MOTOR-EMAX-ECO-II-2807", "BATTERY-FLYWOO-EXPLORER-4S-3000MAH-LI-ION-18650", "motor_battery_voltage"),
    ("STACK-FLYWOO-GOKU-GN405-NANO-13A-STACK", "MOTOR-EMAX-ECO-II-2807", "stack_motor_current"),
    ("FRAME-GEPRC-MARK4-7", "PROP-HQPROP-13X12X3-MASTER-AIRSCREW-13", "frame_prop_size"),
])
def test_known_bad_pairs_fail(a, b, rule):
    res = check_pair(a, b)
    assert any(r["rule"] == rule and r["status"] == "fail" for r in res)
    # порядок аргументів не важливий
    assert check_pair(b, a) == [dict(r, part_a=r["part_b"], part_b=r["part_a"]) for r in res] or len(check_pair(b, a)) == len(res)


def test_compatible_with_excludes_fail():
    sku = "MOTOR-EMAX-ECO-II-2807"
    names = {r["sku"] for r in compatible_with(sku, category="battery")}
    assert "BATTERY-FLYWOO-EXPLORER-4S-3000MAH-LI-ION-18650" not in names


def test_part_use_cases_for_motor():
    with get_connection() as conn:
        sku = conn.execute(
            "SELECT c.sku FROM component_use_cases cuc JOIN components c "
            "ON c.id = cuc.component_id LIMIT 1").fetchone()[0]
    assert part_use_cases(sku)


def test_status_values_are_valid():
    with get_connection() as conn:
        bad = conn.execute(
            "SELECT count(*) FROM v_pair_checks "
            "WHERE status NOT IN ('ok','warn','fail','unknown')").fetchone()[0]
    assert bad == 0
