class Book:

    def __init__(self, pages=0, author="Невідомо", price=0.0,
                 year=0, publisher="Невідомо"):
        self.__pages = pages
        self.__author = author
        self.__price = price
        self.year = year
        self.publisher = publisher

    def get_pages(self):
        return self.__pages

    def get_author(self):
        return self.__author

    def get_price(self):

        return self.__price

    def __str__(self):
        return (f"Книжка: автор — {self.__author}, "
                f"сторінок — {self.__pages}, "
                f"ціна — {self.__price} грн, "
                f"рік — {self.year}, видавець — {self.publisher}")

    def __repr__(self):
        return (f"Book(pages={self.__pages!r}, author={self.__author!r}, "
                f"price={self.__price!r}, year={self.year!r}, "
                f"publisher={self.publisher!r})")

    def __del__(self):
        print(f"Деструктор: об'єкт Book (автор: {self.__author}) видалено")


def show(book):
    print("Сторінок:", book.get_pages())
    print("Автор:", book.get_author())
    print("Ціна (грн):", book.get_price())
    print("Рік видання:", book.year)
    print("Видавець:", book.publisher)
    print("str :", book)
    print("repr:", repr(book))
    print()


def main():
    book1 = Book()
    book2 = Book(320, "Тарас Шевченко", 250.5, 2020, "Основа")
    book3 = Book(pages=544, author="Іван Франко", price=399.0,
                 year=2018, publisher="Видавництво Старого Лева")

    for number, book in enumerate((book1, book2, book3), start=1):
        print(f"--- Об'єкт {number} ---")
        show(book)

    del book1 
    print("Кінець main")

