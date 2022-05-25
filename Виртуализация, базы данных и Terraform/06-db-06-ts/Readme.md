# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя

Найти операции, которые выполняются больше 180сек.

	db.currentOp().inprog.forEach(
	  function(op) {
	    if(op.secs_running > 180) printjson(op);
	  }
	)

Убить зависшую операцию:

        db.killOp(<opid>)

- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

Ответ: Задать лимит на выполнение операции через maxTimeMS()


## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?
 
Ответ:

Вероятно блокировка записи вызвана процессом сброса буфера записи на диск:

Latency due to AOF and disk I/O

"Another source of latency is due to the Append Only File support on Redis. 
The AOF basically uses two system calls to accomplish its work. One is write(2) 
that is used in order to write data to the append only file, and the other one is fdatasync(2) 
that is used in order to flush the kernel file buffer on disk in order to ensure the durability level specified by the user."

Также возможная причина блокировки может быть вызвана большим количеством удаляемых ключей - операция записи блокируется до завершения процесса удаления ключей:

"if the database has many many keys expiring in the same second, and these make up at least 25% of the current population of keys with an expire set, Redis can block in order to get the percentage of keys already expired below 25%.

This approach is needed in order to avoid using too much memory for keys that are already expired, and usually is absolutely harmless since it's strange that a big number of keys are going to expire in the same exact second, but it is not impossible that the user used EXPIREAT extensively with the same Unix time.

In short: be aware that many keys expiring at the same moment can be a source of latency."
## Задача 3

Перед выполнением задания познакомьтесь с документацией по [Common Mysql errors](https://dev.mysql.com/doc/refman/8.0/en/common-errors.html).

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения данной проблемы вы можете предложить?


Ответ:

Подобное сообщение может появиться при выборке таблицы с очень большим количеством строк. 
Решение - увеличение значения параметра net_read_timeout

## Задача 4

Перед выполнением задания ознакомтесь со статьей [Common PostgreSQL errors](https://www.percona.com/blog/2020/06/05/10-common-postgresql-errors/) из блога Percona.

Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

Как бы вы решили данную проблему?

Ответ:

Процесс СУБД был прекращен из-за превышения количества памяти процессом ядра OOM-killer (Когда памяти не хватает, OOM-killer вызывает и уничтожает процесс PostgreSQL). 
Возможное решение - модифицировать параметр процесса СУБД oom_score_adj
