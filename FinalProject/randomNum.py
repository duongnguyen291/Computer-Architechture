import random

def generate_random_numbers(n, low, high):
    return [random.randint(low, high) for _ in range(n)]

random_numbers = generate_random_numbers(2000, -1000, 1000)

# Mở file sort.txt để ghi kết quả
with open(r'C:\Users\Admin\OneDrive\BÁCH KHOA\2024-1\Assembly Language and Computer Architecture Lab\CA\FinalProject\sortBasic.txt', 'w') as file:
    # Ghi các số vào file, mỗi số cách nhau bằng dấu cách
    file.write(' '.join(map(str, random_numbers)))
    
print("Dữ liệu đã được ghi vào file sort.txt")
