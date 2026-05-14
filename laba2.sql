-- Очистимо старі дані, щоб уникнути дублікатів
TRUNCATE Order_Items, Orders, Menu, Staff, Clients RESTART IDENTITY CASCADE;

-- 1. Меню
INSERT INTO Menu (name, category, price) VALUES 
('Еспресо', 'Напої', 45.00),
('Капучино', 'Напої', 60.00),
('Чізкейк', 'Десерти', 120.00),
('Борщ', 'Основні страви', 150.00),
('Тірамісу', 'Десерти', 130.00);

-- 2. Персонал
INSERT INTO Staff (full_name, role) VALUES ('Іван Петренко', 'Офіціант');

-- 3. Клієнти (додаємо Олексія, який повернеться двічі)
INSERT INTO Clients (name, phone, discount_pct) VALUES 
('Олексій', '+380671112233', 5),
('Ганна', '+380934445566', 10);

-- 4. Замовлення (різні дати та статуси)
INSERT INTO Orders (order_date, client_id, staff_id, total_amount, status) VALUES 
('2026-04-01 10:00:00', 1, 1, 105.00, 'Paid'),      -- Замовлення 1 (Олексій)
('2026-04-01 12:00:00', 1, 1, 120.00, 'Delivered'), -- Замовлення 2 (Олексій повернувся!)
('2026-04-02 15:00:00', 2, 1, 270.00, 'Ready');     -- Замовлення 3 (Ганна)

-- 5. Деталі замовлень (щоб були замовлення з >1 стравою)
INSERT INTO Order_Items (order_id, menu_id, quantity, price_at_time) VALUES 
(1, 1, 1, 45.00), (1, 2, 1, 60.00), -- Замовлення №1: 2 страви (Напої)
(2, 3, 1, 120.00),                  -- Замовлення №2: 1 страва (Десерт)
(3, 3, 1, 120.00), (3, 4, 1, 150.00); -- Замовлення №3: 2 страви

-- 1. Які страви є у меню?
-- (Вибірка всіх даних)
SELECT name, price, category FROM Menu;

-- 2. Яка середня кількість замовлень на день?
-- (Агрегація за часом)
SELECT AVG(daily_count) 
FROM (
    SELECT CAST(order_date AS DATE), COUNT(*) as daily_count 
    FROM Orders 
    GROUP BY CAST(order_date AS DATE)
) subquery;

-- 3. Які замовлення містять більше ніж одну страву?
-- (GROUP BY + HAVING)
SELECT order_id, SUM(quantity) as total_items
FROM Order_Items
GROUP BY order_id
HAVING SUM(quantity) > 1;

-- 4. Скільки замовлень зроблено на певну страву (наприклад, 'Еспресо')?
-- (JOIN + COUNT + WHERE)
SELECT m.name, COUNT(oi.order_id) as order_count
FROM Menu m
JOIN Order_Items oi ON m.id = oi.menu_id
WHERE m.name = 'Еспресо'
GROUP BY m.name;

-- 5. Які клієнти зробили найбільшу кількість замовлень?
-- (JOIN + GROUP BY + ORDER BY)
SELECT c.name, COUNT(o.id) as total_orders
FROM Clients c
JOIN Orders o ON c.id = o.client_id
GROUP BY c.name
ORDER BY total_orders DESC;

-- 6. Скільки замовлень містять напої та десерти?
-- (JOIN + WHERE + COUNT + DISTINCT)
SELECT COUNT(DISTINCT order_id) 
FROM Order_Items oi
JOIN Menu m ON oi.menu_id = m.id
WHERE m.category IN ('Напої', 'Десерти');

-- 7. Яка середня сума замовлення в кафе?
-- (AVG)
SELECT AVG(total_amount) as avg_order_value FROM Orders;

-- 8. Які замовлення були оформлені на певний період (наприклад, квітень 2026)?
-- (WHERE з діапазоном)
SELECT * FROM Orders 
WHERE order_date BETWEEN '2026-04-01' AND '2026-04-30';

-- 9. Скільки клієнтів повернулося для повторних замовлень?
-- (Підрахунок клієнтів з count > 1)
SELECT COUNT(*) FROM (
    SELECT client_id 
    FROM Orders 
    GROUP BY client_id 
    HAVING COUNT(id) > 1
) subquery;

-- 10. Які записи мають статус "приготовано" та "доставлено"?
-- (WHERE + IN)
-- Примітка: перевірте, чи є у вас такі статуси в даних (наприклад, 'Ready', 'Delivered')
SELECT * FROM Orders 
WHERE status IN ('Ready', 'Delivered');