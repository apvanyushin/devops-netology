# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql


Ответ:

    docker run --name psql -d -e POSTGRES_PASSWORD=passw -v data:/var/lib/data postgres:13

Вывод списка БД:
     
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
    
Подключение к БД:

    postgres=# \c postgres
    You are now connected to database "postgres" as user "postgres".

Вывод списка таблиц:

    postgres=# \dS
                            List of relations
       Schema   |              Name               | Type  |  Owner
    ------------+---------------------------------+-------+----------
     pg_catalog | pg_aggregate                    | table | postgres
     pg_catalog | pg_am                           | table | postgres
     pg_catalog | pg_amop                         | table | postgres
     pg_catalog | pg_amproc                       | table | postgres
     pg_catalog | pg_attrdef                      | table | postgres
     pg_catalog | pg_attribute                    | table | postgres
     pg_catalog | pg_auth_members                 | table | postgres
     ...

Вывод описания содержимого таблиц:

    postgres=# \dS pg_aggregate
                   Table "pg_catalog.pg_aggregate"
          Column      |   Type   | Collation | Nullable | Default
    ------------------+----------+-----------+----------+---------
     aggfnoid         | regproc  |           | not null |
     aggkind          | "char"   |           | not null |
     aggnumdirectargs | smallint |           | not null |
     aggtransfn       | regproc  |           | not null |
     aggfinalfn       | regproc  |           | not null |
     aggcombinefn     | regproc  |           | not null |
     aggserialfn      | regproc  |           | not null |
     aggdeserialfn    | regproc  |           | not null |
     aggmtransfn      | regproc  |           | not null |
     aggminvtransfn   | regproc  |           | not null |
     aggmfinalfn      | regproc  |           | not null |
     aggfinalextra    | boolean  |           | not null |
     aggmfinalextra   | boolean  |           | not null |
     aggfinalmodify   | "char"   |           | not null |
     aggmfinalmodify  | "char"   |           | not null |
     aggsortop        | oid      |           | not null |
     aggtranstype     | oid      |           | not null |
     aggtransspace    | integer  |           | not null |
     aggmtranstype    | oid      |           | not null |
     aggmtransspace   | integer  |           | not null |
     agginitval       | text     | C         |          |
     aggminitval      | text     | C         |          |
    Indexes:
        "pg_aggregate_fnoid_index" UNIQUE, btree (aggfnoid)

Выход из psql:

    postgres=# \q
    root@52684b23c5d2:/var/lib/data#
## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

    test_database=# SELECT tablename, attname, avg_width FROM pg_stats WHERE tablename = 'orders' AND avg_width = (SELECT MAX(avg_width) from pg_stats WHERE tablename = 'orders');
     tablename | attname | avg_width 
    -----------+---------+-----------
     orders    | title   |        16
    (1 row)

    
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

---

Ответ:
    
    CREATE TABLE orders_new (
    id      integer,
    title   varchar(80),
    price   integer
    );
    
    CREATE TABLE orders_1 (
    CONSTRAINT pk_1 PRIMARY KEY (id),
    CONSTRAINT pr_1 CHECK ( price > 499 ))
    INHERITS (orders_new);
    
    CREATE TABLE orders_2 (
    CONSTRAINT pk_2 PRIMARY KEY (id),
    CONSTRAINT pr_2 CHECK ( price <= 499 ))
    INHERITS (orders_new);

    INSERT INTO orders_1 (id,title,price)
    SELECT id,title,price
    from orders
    where price > 499;
    
    INSERT INTO orders_2 (id,title,price)
    SELECT id,title,price
    from orders
    where price <= 499;
    
    ALTER TABLE orders RENAME TO orders_backup;
    ALTER TABLE orders_new RENAME TO orders;

"ручное" разбиение при проектировании таблицы orders:

    CREATE TABLE orders (
    id      integer,
    title   varchar(80),
    price   integer
    )
    PARTITION BY RANGE (price);

    CREATE TABLE orders_big
    PARTITION OF orders
    FOR VALUES FROM (500) TO (1000000000);

    CREATE TABLE orders_small
        PARTITION OF orders
        FOR VALUES FROM (0) TO (500);
        

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

Ответ:
    
    pg_dump -U postgres -d test_database >test_database_dump.sql


Доработка файла для уникальности путём добавления Unique constraints (Unique constraints ensure that the data contained in a column, or a group of columns, is unique among all the rows in the table.)

CREATE TABLE public.orders (  
	    id integer NOT NULL,  
	    title character varying(80) NOT NULL,  
	    price integer DEFAULT 0,  
	    UNIQUE (title)  
	); 

