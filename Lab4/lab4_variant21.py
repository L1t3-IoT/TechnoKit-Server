
class Farm:
    """Ферма."""

    def __init__(self, location="Невідомо", animals_count=0, fan_power=0.0):
        """Конструктор."""
        self.__location = location
        self.__animals_count = animals_count
        self.__fan_power = fan_power
        self.year_founded = 0
        self.owner = "Невідомо"

    def __del__(self):
        """Деструктор."""
        print(f"Знищено ферму: {self.__location}")

    def __str__(self):
        """Опис для людини."""
        return (f"Ферма «{self.__location}»: тварин - "
                f"{self.__animals_count}, вентиляторів - "
                f"{self.__fan_power} Вт")

    def __repr__(self):
        """Технічний опис."""
        return (f"Farm({self.__location!r}, "
                f"{self.__animals_count!r}, {self.__fan_power!r})")

    def get_location(self):
        """Місцезнаходження."""
        return self.__location

    def get_animals_count(self):
        """Кількість тварин."""
        return self.__animals_count

    def get_fan_power(self):
        """Потужність вентиляторів."""
        return self.__fan_power


def print_farm(farm):
    """Виводить усі поля ферми."""
    print("Місцезнаходження:", farm.get_location())
    print("Кількість тварин:", farm.get_animals_count())
    print("Потужність вентиляторів:", farm.get_fan_power(), "Вт")
    print("Власник:", farm.owner)
    print("Рік заснування:", farm.year_founded)
    print("str:", farm)
    print("repr:", repr(farm))
    print()


def main():
    """Створює три ферми та виводить їхні поля."""
    farm1 = Farm()
    farm2 = Farm("Львівська обл., с. Зубра", 120, 450.0)
    farm3 = Farm("Київська обл., с. Мостище", 300, 1200.5)

    farm2.owner = "ТОВ «Зубрівка»"
    farm2.year_founded = 2005
    farm3.owner = "ФГ «Нива»"
    farm3.year_founded = 2012

    print_farm(farm1)
    print_farm(farm2)
    print_farm(farm3)


if __name__ == "__main__":
    main()
