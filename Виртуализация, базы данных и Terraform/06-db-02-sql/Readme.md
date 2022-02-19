# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.


Ответ:
  
    docker volume create volume1
    docker volume create volume2

    docker run --name postgreSQL12 -d -p 5432:5432 -ti -e POSTGRES_PASSWORD=passw -v volume1:/var/lib/postgresql/data -v volume2:/var/lib/postgresql/backup postgres:12
    
    docker exec -it c864236310a1 bash
    root@c864236310a1:/# psql --version
    psql (PostgreSQL) 12.10 (Debian 12.10-1.pgdg110+1)
    psql -U postgres

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
вычислите количество записей для каждой таблицы 
приведите в ответе:
запросы 
результаты их выполнения.


    postgres=# INSERT INTO orders VALUES (1, 'Шоколад', 10), 
    (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
    INSERT 0 5
    postgres=# INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), 
    (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), 
    (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
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


## Задача 6
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.


Ответ:
    
    docker start c864236310a1
    docker exec -it c864236310a1 bash
    root@c864236310a1:/# cd /var/lib/postgresql/backup
    root@c864236310a1:/var/lib/postgresql/backup# pg_dump -U postgres test_db > backup.dump
    root@c864236310a1:/var/lib/postgresql/backup# ls
    backup.dump
    root@c864236310a1:/var/lib/postgresql/backup# exit
    exit
    vagrant@server1:~/postgres$ docker stop c864236310a1
    c864236310a1

    docker run --name postgresql_backup -d -p 5432:5432 -ti -e POSTGRES_PASSWORD=passw -v volume2:/var/lib/postgresql/backup postgres:12
    docker exec -it 4d46feb299a3 bash
    root@4d46feb299a3:/# cd /var/lib/postgresql/backup
    
Команда для восстановления "psql -U postgres test_db < database-backup.dump", но в документации сказано что эта команда не создает БД, ее нужно создать предварительно вручную.

    createdb -U postgres -T template0 test_db

    root@4d46feb299a3:/var/lib/postgresql/backup# psql -U postgres test_db < database-backup.dump
    SET
    SET
    SET
    SET
    SET
     set_config
    ------------
    
    (1 row)
    
    SET
    SET
    SET
    SET
    SET
    SET
    CREATE TABLE
    ALTER TABLE
    CREATE SEQUENCE
    ALTER TABLE
    ALTER SEQUENCE
    CREATE TABLE
    ALTER TABLE
    CREATE SEQUENCE
    ALTER TABLE
    ALTER SEQUENCE
    ALTER TABLE
    ALTER TABLE
    COPY 5
    COPY 5
     setval
    --------
          1
    (1 row)
    
     setval
    --------
          1
    (1 row)
    
    ALTER TABLE
    ALTER TABLE
    CREATE INDEX
    ALTER TABLE
    ERROR:  role "test-admin-user" does not exist
    ERROR:  role "test-simple-user" does not exist
    ERROR:  role "test-admin-user" does not exist
    ERROR:  role "test-simple-user" does not exist

При развертывании БД из бекапа возникли ошибки, судя по документации это нормально. 
Перед восстановлением SQL-дампа все пользователи, которые владели объектами или имели права на объекты в выгруженной базе данных, должны уже существовать. Если их нет, при восстановлении будут ошибки пересоздания объектов с изначальными владельцами и/или правами.
При этом все данные и таблицы в БД существуют, но это неприемлемый результат.
Поэтому я удалил восстановленную БД, внес правки в файл database-backup.dump, добавив для строки для создания нужных пользователей.

CREATE USER "test-admin-user";

CREATE USER "test-simple-user";

После чего восстановление БД из бекапа происходит без ошибок (не буду повторно спамить весь вывод при восстановлении БД, а покажу только строки которые раньше были с ошибками):
    
     setval
    --------
          1
    (1 row)
    
    ALTER TABLE
    ALTER TABLE
    CREATE INDEX
    ALTER TABLE
    GRANT
    GRANT
    GRANT
    GRANT

    root@4d46feb299a3:/var/lib/postgresql/backup# psql -U postgres -d test_db
    psql (12.10 (Debian 12.10-1.pgdg110+1))
    Type "help" for help.
    
    test_db=# SELECT * FROM clients;
     id |       фамилия        | страна | заказ
    ----+----------------------+--------+-------
      4 | Ронни Джеймс Дио     | Russia |
      5 | Ritchie Blackmore    | Russia |
      1 | Иванов Иван Иванович | USA    |     3
      2 | Петров Петр Петрович | Canada |     4
      3 | Иоганн Себастьян Бах | Japan  |     5
    (5 rows)
    
            
