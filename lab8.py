import redis
import time

def main():
   print("=== Лабораторна робота №8: Робота з Redis Streams через Python ===")

   try:
      r = redis.Redis(host='localhost', port=6379, decode_responses=True)
      if r.ping():
            print("[ОК] Підключення до Redis успішне!")
   except redis.ConnectionError:
      print("[ПОМИЛКА] Не вдалося підключитися. Запустіть сервер: sudo service redis-server start")
      return

   stream_name = 'weather_stream'

   r.delete(stream_name)

   print(f"\n1. Додавання нових подій до потоку '{stream_name}'...")

   data_points = [
      {"sensor_id": "WS-01", "temp": "18.5", "humidity": "65%"},
      {"sensor_id": "WS-01", "temp": "19.0", "humidity": "64%"},
      {"sensor_id": "WS-02", "temp": "21.2", "humidity": "50%"}
   ]

   for data in data_points:

      event_id = r.xadd(stream_name, data, id='*')
      print(f" -> Додано подію з ID: {event_id} | Дані: {data}")
      time.sleep(0.5)

   print(f"\n2. Читання всіх подій з потоку '{stream_name}' за допомогою XRANGE...")

   events = r.xrange(stream_name, min='-', max='+')
   for event in events:
      event_id, event_data = event
      print(f" -> [{event_id}] Сенсор: {event_data.get('sensor_id')}, "
            f"Температура: {event_data.get('temp')}°C, Вологість: {event_data.get('humidity')}")

   print(f"\n3. Читання нових подій за допомогою XREAD...")

   read_data = r.xread({stream_name: '0-0'}, count=2)
   for stream, messages in read_data:
      print(f" -> Зчитано {len(messages)} повідомлень з потоку '{stream}':")
      for msg_id, msg_data in messages:
            print(f"    - ID: {msg_id} -> {msg_data}")

   print("\n=== Тестування програми на Python успішно завершено ===")

if __name__ == "__main__":
   main()