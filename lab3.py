def to_upper(ch):
    code = ord(ch)
    if ord('a') <= code <= ord('z'):
        symbol = chr(code - 32)
    else:
        symbol = ch
    return symbol


def capitalize(s, indices):
    chars = []
    for ch in s:
        chars.append(ch)

    for idx in indices:
        if 0 <= idx < len(s):
            chars[idx] = to_upper(chars[idx])

    result = ""
    for ch in chars:
        result += ch
    return result


text = input("Введіть рядок: ")
indices_text = input("Введіть індекси через пробіл: ")
parts = indices_text.split()

idx_list = []
for part in parts:
    idx_list.append(int(part))
print(capitalize(text, idx_list))