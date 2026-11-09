from .db import get_connection

TABLES = [
    "manufacturers", "categories", "components",
    "frames", "motors", "propellers", "batteries", "escs", "flight_controllers",
    "stacks", "cameras", "vtx", "antennas", "receivers", "gps_modules",
    "stock", "drones", "drone_parts",
]


def main() -> None:
    print("Кількість записів у таблицях:")
    with get_connection() as conn:
        for table in TABLES:
            count = conn.execute(f"SELECT count(*) FROM {table}").fetchone()[0]
            print(f"  {table:<20} {count}")


if __name__ == "__main__":
    main()
