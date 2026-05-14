-- Створення таблиці авторів
CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
);

-- Створення таблиці книг
CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT REFERENCES Authors(author_id) ON DELETE CASCADE,
    published_year INT
);

-- Створення таблиці читачів
CREATE TABLE Readers (
    reader_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Book_Loans (
    loan_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES Books(book_id),
    reader_id INT REFERENCES Readers(reader_id),
    loan_date DATE DEFAULT CURRENT_DATE,
    return_date DATE
);

INSERT INTO Book_Loans (book_id, reader_id) VALUES (1, 1);

INSERT INTO Authors (full_name) VALUES ('Тарас Шевченко'), ('Джоан Роулінг');

INSERT INTO Books (title, author_id, published_year) 
VALUES ('Кобзар', 1, 1840), ('Гаррі Поттер', 2, 1997);

INSERT INTO Readers (first_name, last_name, email) 
VALUES ('Олександр', 'Коваленко', 'alex@example.com');

SELECT Books.title, Authors.full_name, Books.published_year 
FROM Books 
JOIN Authors ON Books.author_id = Authors.author_id;

-- Оновлення даних (зміна email читача)
UPDATE Readers SET email = 'petrenko_new@email.com' WHERE reader_id = 1;

-- Видалення книги
DELETE FROM Books WHERE book_id = 2;

UPDATE Book_Loans 
SET return_date = '2026-04-21' 
WHERE loan_id = 1;

DELETE FROM Readers WHERE reader_id = 2;

SELECT 
    r.first_name || ' ' || r.last_name AS "Читач",
    b.title AS "Назва книги",
    a.full_name AS "Автор",
    bl.loan_date AS "Дата видачі",
    CASE 
        WHEN bl.return_date IS NULL THEN 'На руках'
        ELSE 'Повернуто: ' || bl.return_date
    END AS "Статус"
FROM Book_Loans bl
JOIN Readers r ON bl.reader_id = r.reader_id
JOIN Books b ON bl.book_id = b.book_id
JOIN Authors a ON b.author_id = a.author_id;