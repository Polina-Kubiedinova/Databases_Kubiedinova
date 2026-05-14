from pymongo import MongoClient

# 1. Підключення до бази даних
client = MongoClient("mongodb://localhost:27017")

# 2. Вибір бази даних та колекції
db = client["performance_test"]
collection = db["sales"]

# 3. Створення індексу для поля "category"
# 1 означає сортування за зростанням (ASCENDING)
print("Створення індексу... зачекайте.")
collection.create_index([("category", 1)])

# 4. Виведення повідомлення
print("Індекс створено")