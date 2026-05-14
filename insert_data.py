import random
import datetime
from pymongo import MongoClient

# 1. Підключення до MongoDB
client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

# 2. Створення тестових даних
categories = ["Electronics", "Clothing", "Books", "Home", "Sports"]

print("Генерація 100,000 документів... зачекайте.")

documents = [
   {
      "customer_id": random.randint(1, 1000),
      "category": random.choice(categories),
      "amount": random.uniform(5, 500),
      "timestamp": datetime.datetime(2024, random.randint(1, 12), random.randint(1, 28))
   }
   for _ in range(100000)
]

# 3. Вставка даних у MongoDB
print("Вставка даних у базу...")
result = collection.insert_many(documents)

print(f"Успішно вставлено {len(result.inserted_ids)} документів.")