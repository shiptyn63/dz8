Новое ДЗ:
Добавить в таблицу книг столбец «кол-во страниц»
С помощью подзапроса в условии найти все книги, количество страниц в которых больше среднего.
Добавить к книгам столбцы с ценой, количеством экземпляров (допустим, у нас БД для магазина книг) и год издания (или публикации, на ваше усмотрение).
С помощью подзапроса найти самые свежие книги (подзапрос определяет MAX год, этот год используется в условии, как было на занятии с максимальной ценой).
Написать аналогичный запрос

--SELECT *
--FROM	(SELECT name, SUM(amount * price) AS total
  --       FROM product
    --     GROUP BY name)
--WHERE total > 300000
-- ORDER BY total;

--Но для книг (количество * цена) и фильтрация этого значения по условию.
-- Лучше всего написать его с помощью подзапроса, с помощью HAVING и с помощью CTE – одна и та же логика в трех реализациях, лучше поймете.
create table publisher (
                           id bigint generated always as identity primary key ,
                           name varchar (200),
                           adress varchar (200)
);
insert into publisher (name, adress)
values ('Эксмо','Санкт-Петербург'),
       ('АСТ','Москва');
select name as "Название издательства",
       adress as "Адрес"
from publisher;
-- книги
create table book (
                      id bigint generated always as identity primary key ,
                      name varchar(200),
                      date date,
                      publisher_id bigint,
                      constraint fk_book_publisher foreign key (publisher_id) references publisher (id)
);
insert into book (name , date ,publisher_id)
values ('книга 1', '2015-01-25',1),
       ('книга 2','2023-10-26',1),
       ('книга 3','2020-03-07',2);
select *
from book;
-- автор
create table author (
                        id bigint generated always as identity primary key ,
                        surname varchar(200),
                        name varchar (200)
);
insert into author (surname, name)
values ('Петров','Пётр'),
       ('Сидоров','Николай'),
       ('Иванов','Иван');
-- связующая таблица
create table book_author (
                             book_id bigint,
                             author_id bigint,

                             constraint fk_book foreign key (book_id) references book (id),
                             constraint fk_author foreign key (author_id) references author(id)
);
insert into book_author (book_id, author_id)
values (1,1),
       (1,3),
       (2,2),
       (3,2),
       (3,3);
select *
from book_author;
select b.name ,b.date ,p.name
from book b
         join publisher p on b.publisher_id=p.id
         join book_author ba on b.id =ba.book_id;
ALTER TABLE book
    ADD COLUMN nubmer_of_pages BIGINT;
UPDATE book set nubmer_of_pages = 246 where id = 1;
UPDATE book set nubmer_of_pages = 355 where id = 2;
UPDATE book set nubmer_of_pages = 426 where id = 3;
select * from book ;
SELECT name
FROM book
WHERE book.nubmer_of_pages > (SELECT AVG (book.nubmer_of_pages) FROM book);
ALTER TABLE BOOK
    ADD COLUMN PRICE DECIMAL,
    ADD COLUMN amount  BIGINT,
    ADD COLUMN release_year DATE ;
UPDATE book set price = 1500 where id = 1;
UPDATE book set price = 2000 where id = 2;
UPDATE book set price = 3000 where id = 3;
UPDATE book SET amount = 40 where id = 1;
UPDATE book SET amount = 70 where id = 2;
UPDATE book SET amount = 10 where id = 3;
update book set  release_year = '1995-01-26' where id = 1;
update book set  release_year = '1995-02-12' where id = 1;
update book set  release_year = '1997-03-30' where id = 1;
SELECT name
from book
where book.release_year = (SELECT MAX(book.release_year) from book);
SELECT name
FROM book
GROUP BY name, price, book.amount
HAVING book.amount * price > 5000
    WITH BookTotals AS (
    SELECT name, book.amount * price AS total_cost
    FROM book
)
SELECT name
FROM BookTotals
WHERE total_cost > 5000;
