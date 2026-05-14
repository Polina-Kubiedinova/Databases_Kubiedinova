import time
from pymongo import MongoClient

# 1. Підключення до MongoDB
client = MongoClient("mongodb://localhost:27017")

# 2. Вибір бази даних та колекції
db = client["performance_test"]
collection = db["sales"]

# 3. Виконання запиту та вимір часу
start_time = time.time()  # Записуємо час ПЕРЕД запитом

# Шукаємо всі документи з категорією "Electronics"
# Метод list() змушує MongoDB витягнути всі дані з курсора в пам'ять
query_results = list(collection.find({"category": "Electronics"}))

end_time = time.time()    # Записуємо час ПІСЛЯ запиту

# 4. Виведення результату
execution_time = end_time - start_time
print(f"Знайдено документів: {len(query_results)}")
print(f"Time taken: {execution_time:.6f} seconds")