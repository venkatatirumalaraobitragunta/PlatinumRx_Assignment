text = input("Enter string: ")

result = ""

for ch in text:
    if ch not in result:
        result += ch

print("Unique string:", result)
