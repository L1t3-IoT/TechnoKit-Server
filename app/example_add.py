"""Приклад додавання деталей. Запуск: python -m app.example_add

Змініть значення на свої. Повторний запуск з тим самим sku дасть помилку,
бо sku унікальний.
"""
from .add_data import add_battery, add_motor, add_other

add_motor("TM-F60-2207", "F60 Pro IV 2207", stator_size="2207", kv=1950,
          manufacturer="T-Motor", weight_g=31.5, price=28.90, quantity=10)

add_battery("TATTU-6S-1300", "Tattu R-Line 6S 1300mAh", cells_s=6,
            capacity_mah=1300, manufacturer="Tattu", c_rating=120,
            connector="XT60", weight_g=190, price=24.50, quantity=5)

add_other("CAM-1", "FPV Camera 1200TVL", "camera",
          specs={"resolution_tvl": 1200, "sensor": "1/3 CMOS"}, quantity=3)

print("Деталі додано. Перевірте: python -m app.main")
