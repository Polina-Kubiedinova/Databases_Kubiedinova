import redis

def main():
   print("=== Запуск міні-програми для роботи з Redis ===")

   try:
      r = redis.Redis(host='localhost', port=6379, decode_responses=True)
      
      if r.ping():
         print("[ОК] Успішно підключено до локального сервера Redis!")
   except redis.ConnectionError:
      print("[ПОМИЛКА] Не вдалося підключитися до Redis.")
      print("Будь ласка, переконайтеся, що служба запущена у WSL командою: sudo service redis-server start")
      return

   counter_value = r.incr('mycounter')
   print(f"\n[Крок 1] Лічильник 'mycounter' успішно збільшено!")
   print(f" -> Поточне значення лічильника: {counter_value}")

   print("\n[Крок 2] Зчитування списку задач 'tasks'...")
   tasks = r.lrange('tasks', 0, -1)
   
   if tasks:
      print(" -> Знайдені задачі у списку:")
      for index, task in enumerate(tasks, start=1):
            print(f"    {index}. {task}")
   else:
      print(" -> [Увага] Список задач порожній. Ви можете додати їх у redis-cli за допомогою команди: LPUSH tasks 'Task1'")

   channel_name = 'news'
   message_text = "Привіт! Це повідомлення відправлене автоматично з нашої програми на Python!"
   
   print(f"\n[Крок 3] Публікація повідомлення в канал '{channel_name}'...")
   subscribers_count = r.publish(channel_name, message_text)
   
   print(f" -> Текст повідомлення: \"{message_text}\"")
   print(f" -> Кількість активних підписників, які отримали повідомлення: {subscribers_count}")
   print("\n=== Роботу програми успішно завершено ===")

if __name__ == "__main__":
   main()