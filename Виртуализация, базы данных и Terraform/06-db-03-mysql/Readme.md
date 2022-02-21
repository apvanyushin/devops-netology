# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.


Ответ:
  
    docker run --name mysql -d -e MYSQL_ROOT_PASSWORD=passw -v ~/postgres/backup:/var/data mysql:8
    docker exec -it 3d036b6ab126 bash
    root@3d036b6ab126:/#cd var/data
    root@3d036b6ab126:/var/data# ls
    test_dump.sql

    root@3d036b6ab126:/var/data# mysql -uroot -p
    CREATE DATABASE testdb;
    \q
    
    root@3d036b6ab126:/var/data# mysql -uroot -p testdb < test_dump.sql
    mysql -uroot -p
    
    mysql> SHOW DATABASES;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | sys                |
    | testdb             |
    +--------------------+
    5 rows in set (0.01 sec)

    mysql> status
    --------------
    mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

    mysql> use testdb;
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A
    
    Database changed
    mysql> SHOW TABLES;
    +------------------+
    | Tables_in_testdb |
    +------------------+
    | orders           |
    +------------------+
    1 row in set (0.00 sec)

    mysql> SELECT * FROM orders WHERE price > 300;
    +----+----------------+-------+
    | id | title          | price |
    +----+----------------+-------+
    |  2 | My little pony |   500 |
    +----+----------------+-------+
    1 row in set (0.00 sec)
        
## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.


Ответ:

    mysql> CREATE USER 'test'@'%' IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3;
    Query OK, 0 rows affected (0.02 sec)

    
    mysql> ALTER USER 'test'@'%'
    -> WITH MAX_QUERIES_PER_HOUR 100;
    Query OK, 0 rows affected (0.02 sec)

    mysql> ALTER USER 'test'@'%' ATTRIBUTE '{"name": "James", "surname": "Pretty"}';
    Query OK, 0 rows affected (0.01 sec)

    mysql> GRANT SELECT ON test_db.* TO 'test';
    Query OK, 0 rows affected (0.01 sec)

    mysql> SHOW GRANTS FOR 'test';
    +-------------------------------------------+
    | Grants for test@%                         |
    +-------------------------------------------+
    | GRANT USAGE ON *.* TO `test`@`%`          |
    | GRANT SELECT ON `test_db`.* TO `test`@`%` |
    +-------------------------------------------+
    2 rows in set (0.00 sec)

    mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
    +------+------+----------------------------------------+
    | USER | HOST | ATTRIBUTE                              |
    +------+------+----------------------------------------+
    | test | %    | {"name": "James", "surname": "Pretty"} |
    +------+------+----------------------------------------+
    1 row in set (0.00 sec)

    
## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`


Ответ:

    mysql> SET profiling = 1;
    Query OK, 0 rows affected, 1 warning (0.00 sec)
    
    
    mysql> SHOW PROFILES;
    +----------+------------+-----------------------------------------------------------------------------------------+
    | Query_ID | Duration   | Query                                                                                   |
    +----------+------------+-----------------------------------------------------------------------------------------+
    |        1 | 0.00056550 | SHOW ENGINES                                                                            |
    |        2 | 0.00230325 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        3 | 0.00168725 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        4 | 0.00012600 | SET profiling = 1                                                                       |
    +----------+------------+-----------------------------------------------------------------------------------------+
    4 rows in set, 1 warning (0.00 sec)
    
    mysql> SHOW ENGINES;
    +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
    | Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
    +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
    | FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
    | MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
    | InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
    | PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
    | MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
    | MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
    | BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
    | CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
    | ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
    +--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
    9 rows in set (0.00 sec)
    
    mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'testdb';
    +------------+--------+
    | TABLE_NAME | ENGINE |
    +------------+--------+
    | orders     | InnoDB |
    +------------+--------+
    1 row in set (0.00 sec)

    ALTER TABLE orders ENGINE = MyISAM;

    mysql> ALTER TABLE orders ENGINE = MyISAM;
    Query OK, 5 rows affected (0.07 sec)
    Records: 5  Duplicates: 0  Warnings: 0

    mysql> SHOW PROFILES;
    +----------+------------+-----------------------------------------------------------------------------------------+
    | Query_ID | Duration   | Query                                                                                   |
    +----------+------------+-----------------------------------------------------------------------------------------+
    |        1 | 0.00056550 | SHOW ENGINES                                                                            |
    |        2 | 0.00230325 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        3 | 0.00168725 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        4 | 0.00012600 | SET profiling = 1                                                                       |
    |        5 | 0.00026675 | SHOW ENGINES                                                                            |
    |        6 | 0.00224000 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        7 | 0.00175725 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'testdb'  |
    |        8 | 0.00007725 | ALTER TABLE orders ENGINE = MyISAM                                                      |
    |        9 | 0.00033450 | ALTER TABLE orders ENGINE = MyISAM                                                      |
    |       10 | 0.00014575 | SELECT DATABASE()                                                                       |
    |       11 | 0.00097200 | show databases                                                                          |
    |       12 | 0.00152375 | show tables                                                                             |
    |       13 | 0.07691000 | ALTER TABLE orders ENGINE = MyISAM                                                      |
    +----------+------------+-----------------------------------------------------------------------------------------+
    13 rows in set, 1 warning (0.00 sec)

    mysql> ALTER TABLE orders ENGINE = InnoDB;
    Query OK, 5 rows affected (0.08 sec)
    Records: 5  Duplicates: 0  Warnings: 0
    
    mysql> SHOW PROFILES;
    +----------+------------+-----------------------------------------------------------------------------------------+
    | Query_ID | Duration   | Query                                                                                   |
    +----------+------------+-----------------------------------------------------------------------------------------+
    |        1 | 0.00056550 | SHOW ENGINES                                                                            |
    |        2 | 0.00230325 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        3 | 0.00168725 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        4 | 0.00012600 | SET profiling = 1                                                                       |
    |        5 | 0.00026675 | SHOW ENGINES                                                                            |
    |        6 | 0.00224000 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db' |
    |        7 | 0.00175725 | SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'testdb'  |
    |        8 | 0.00007725 | ALTER TABLE orders ENGINE = MyISAM                                                      |
    |        9 | 0.00033450 | ALTER TABLE orders ENGINE = MyISAM                                                      |
    |       10 | 0.00014575 | SELECT DATABASE()                                                                       |
    |       11 | 0.00097200 | show databases                                                                          |
    |       12 | 0.00152375 | show tables                                                                             |
    |       13 | 0.07691000 | ALTER TABLE orders ENGINE = MyISAM                                                      |
    |       14 | 0.08264025 | ALTER TABLE orders ENGINE = InnoDB                                                      |
    +----------+------------+-----------------------------------------------------------------------------------------+
    14 rows in set, 1 warning (0.00 sec)
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.


Ответ:

    root@3d036b6ab126:~# cat my.cnf 
    [mysqld]
    pid-file        = /var/run/mysqld/mysqld.pid
    socket          = /var/run/mysqld/mysqld.sock
    datadir         = /var/lib/mysql
    secure-file-priv= NULL
    
    innodb_flush_method		        = O_DSYNC
    innodb_flush_log_at_trx_commit	= 2
    innodb_file_per_table		    = ON 
    innodb_log_file_size		    = 104857600
    #Ставим 1280Mb с учетом доступной памяти в 4G  
    innodb_buffer_pool_size		    = 1342177280
    innodb_log_buffer_size		    = 1048576
    
    
    # Custom config should go here
    !includedir /etc/mysql/conf.d/
    


---