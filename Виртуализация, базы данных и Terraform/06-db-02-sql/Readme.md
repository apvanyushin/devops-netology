# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.


Ответ:
  
    docker volume create volume1
    docker volume create volume2

    docker run --name postgreSQL12 -p 5432:5432 -ti -e POSTGRES_PASSWORD=passw -v volume1:/var/lib/postgresql/data -v volume2:/var/lib/postgresql/backup postgres:12
    
    docker exec -it c864236310a1 bash
    root@c864236310a1:/# psql --version
    psql (PostgreSQL) 12.10 (Debian 12.10-1.pgdg110+1)

    postgres=# \l
                                 List of databases
       Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
    -----------+----------+----------+------------+------------+-----------------------
     postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
     template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
    (3 rows)
## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

Ответ:

###### создайте пользователя test-admin-user и БД test_db
    postgres=# CREATE DATABASE test_db;
    CREATE DATABASE
    
    postgres=# \l
                                 List of databases
       Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
    -----------+----------+----------+------------+------------+-----------------------
     postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
     template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
     test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
    (4 rows)
    

    postgres=# CREATE USER "test-admin-user";
    CREATE ROLE

###### в БД test_db создайте таблицу orders и clients
    postgres=# CREATE TABLE orders (id SERIAL PRiMARY KEY, name VARCHAR, цена INT);
    CREATE TABLE

    postgres=# CREATE TABLE clients (id SERIAL PRiMARY KEY, фамилия VARCHAR, страна VARCHAR, заказ INT REFERENCES orders);
    CREATE TABLE

    CREATE INDEX country ON clients (страна);

###### предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";
    GRANT ALL PRIVILEGES ON DATABASE "test_db" to "test-admin-user";

    postgres=# \dp
                                               Access privileges
     Schema |      Name      |   Type   |         Access privileges          | Column privileges | Policies
    --------+----------------+----------+------------------------------------+-------------------+----------
     public | clients        | table    | postgres=arwdDxt/postgres         +|                   |
            |                |          | "test-admin-user"=arwdDxt/postgres |                   |
     public | clients_id_seq | sequence |                                    |                   |
     public | orders         | table    | postgres=arwdDxt/postgres         +|                   |
            |                |          | "test-admin-user"=arwdDxt/postgres |                   |
     public | orders_id_seq  | sequence |                                    |                   |
    (4 rows)
###### создайте пользователя test-simple-user  
    CREATE USER "test-simple-user";

###### предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE orders TO "test-simple-user";
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE clients TO "test-simple-user";

    postgres=# \dp
                                               Access privileges
     Schema |      Name      |   Type   |         Access privileges          | Column privileges | Policies
    --------+----------------+----------+------------------------------------+-------------------+----------
     public | clients        | table    | postgres=arwdDxt/postgres         +|                   |
            |                |          | "test-admin-user"=arwdDxt/postgres+|                   |
            |                |          | "test-simple-user"=arwd/postgres   |                   |
     public | clients_id_seq | sequence |                                    |                   |
     public | orders         | table    | postgres=arwdDxt/postgres         +|                   |
            |                |          | "test-admin-user"=arwdDxt/postgres+|                   |
            |                |          | "test-simple-user"=arwd/postgres   |                   |
     public | orders_id_seq  | sequence |                                    |                   |
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.


    postgres=# insert into orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
    INSERT 0 5
    postgres=# insert into clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
    INSERT 0 5
    postgres=# SELECT * FROM orders;
     id |  name   | цена
    ----+---------+------
      1 | Шоколад |   10
      2 | Принтер | 3000
      3 | Книга   |  500
      4 | Монитор | 7000
      5 | Гитара  | 4000
    (5 rows)
    
    postgres=# SELECT * FROM clients;
     id |       фамилия        | страна | заказ
    ----+----------------------+--------+-------
      1 | Иванов Иван Иванович | USA    |
      2 | Петров Петр Петрович | Canada |
      3 | Иоганн Себастьян Бах | Japan  |
      4 | Ронни Джеймс Дио     | Russia |
      5 | Ritchie Blackmore    | Russia |
    (5 rows)

###### вычислите количество записей для каждой таблицы 
    postgres=# select count (*) from orders;
     count
    -------
         5
    (1 row)
    
    postgres=# select count (*) from clients;
     count
    -------
         5
    (1 row)
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

    postgres=# update  clients set заказ = 3 where id = 1;
    UPDATE 1
    postgres=# update  clients set заказ = 4 where id = 2;
    UPDATE 1
    postgres=# update  clients set заказ = 5 where id = 3;
    UPDATE 1

    postgres=# SELECT * FROM clients WHERE заказ is NOT NULL;
     id |       фамилия        | страна | заказ
    ----+----------------------+--------+-------
      1 | Иванов Иван Иванович | USA    |     3
      2 | Петров Петр Петрович | Canada |     4
      3 | Иоганн Себастьян Бах | Japan  |     5
    (3 rows)

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

    EXPLAIN SELECT * FROM clients WHERE заказ is NOT NULL;
                            QUERY PLAN
    -----------------------------------------------------------
     Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
       Filter: ("заказ" IS NOT NULL)
    (2 rows)

Вывести рассчитанную стоимость запуска и общую стоимость каждого узла плана, а также рассчитанное число строк и ширину каждой строки.
