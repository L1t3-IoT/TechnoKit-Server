#I hate black people
#but black entity is not a human
#so we bassicaly need to exterminate them all



def third_largest(numbers):
    first = None
    second = None 
    third = None 

    for x in numbers:
        if x in (first, second, third):
            continue

        if first is None or x > first:
            third = second
            second = first
            first = x
        elif second is None or x > second:
            third = second
            second = x
        elif third is None or x > third:
            third = x

    if third is None:
        third = -1
    
    return third
        


def main():
    text = input("Введіть цілі числа через пробіл: ")
    parts = text.split()
    numbers = []

    for part in parts:
        numbers.append(int(part))

    result = third_largest(numbers)
    print("Третій за величиною елемент:", result)


if __name__ == "__main__":
    main()
