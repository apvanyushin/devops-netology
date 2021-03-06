# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

Ответ:

Изначально конфигурация elastic в контейнере планировалась через следующие команды в Dockerfile:

    RUN \
      mkdir -p $ES_HOME/config && \
      touch $ES_CONFIG && \
      printf "path.data: /var/lib/data \n" >> $ES_CONFIG && \
      printf "node.name: netology_test \n" >> $ES_CONFIG && \

Но этот подход записывает все данные в конец файла elasticsearch.yml, а не отдельным секциям конфигурации. (пусть это и не влияет на валидность конфигурации, но это сильно влияет на неудобность работы с конфигурацией elasticsearch.yml)

Поэтому на хосте был создан файл конфигурации elasticsearch.yml, который был скопирован при билде.

Содержимое Dockerfile:

    FROM centos:7
    LABEL ElasticSearch \
        apvanyushin
    
    ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH
    
    RUN yum install java-11-openjdk -y
    RUN yum install wget -y
    RUN yum install perl-Digest-SHA -y
    
    RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.0-linux-x86_64.tar.gz \
        && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.0-linux-x86_64.tar.gz.sha512
    
    RUN shasum -a 512 -c elasticsearch-8.0.0-linux-x86_64.tar.gz.sha512 && tar -xzf elasticsearch-8.0.0-linux-x86_64.tar.gz
    
    ENV ES_HOME=/elasticsearch-8.0.0
    ENV ES_CONFIG=/elasticsearch-8.0.0/config/elasticsearch.yml
    
    RUN groupadd elasticsearch \
        && useradd -g elasticsearch elasticsearch
    RUN mkdir /var/lib/data \
        && mkdir -p $ES_HOME/config \
        && chown elasticsearch:elasticsearch /var/lib/data \
        && chown -R elasticsearch:elasticsearch /elasticsearch-8.0.0/
    
    
    COPY ./elasticsearch.yml $ES_CONFIG
    
    
    RUN rm elasticsearch-8.0.0-linux-x86_64.tar.gz && \
        rm elasticsearch-8.0.0-linux-x86_64.tar.gz.sha512
    
    
    USER elasticsearch
    CMD ["/elasticsearch-8.0.0/bin/elasticsearch"]

Ссылка на image - https://hub.docker.com/r/apvanyushin/elasticsearch

GET запрос к /
    
    curl localhost:9200/
    {
      "name" : "netology_test",
      "cluster_name" : "elasticsearch",
      "cluster_uuid" : "suZgU_wxQjm9kpmk2m6Z1Q",
      "version" : {
        "number" : "8.0.0",
        "build_flavor" : "default",
        "build_type" : "tar",
        "build_hash" : "1b6a7ece17463df5ff54a3e1302d825889aa1161",
        "build_date" : "2022-02-03T16:47:57.507843096Z",
        "build_snapshot" : false,
        "lucene_version" : "9.0.0",
        "minimum_wire_compatibility_version" : "7.17.0",
        "minimum_index_compatibility_version" : "7.0.0"
      },
      "tagline" : "You Know, for Search"
    }


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.


Ответ:

    curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1}}'
    curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 1, "number_of_shards": 2}}'
    curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 2, "number_of_shards": 4}}'

Состояние индексов:

    curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 qrUWFo52QECofsobCklAhQ   1   0          0            0       225b           225b
    yellow open   ind-3 rixLNr-TT12ScVAukNSuHQ   4   2          0            0       225b           225b
    yellow open   ind-2 Ep479SJWT5ugE29Zh4lKNw   2   1          0            0       450b           450b

Статус кластера:

    curl -X GET 'http://localhost:9200/_cluster/health/?pretty'
    {
      "cluster_name" : "elasticsearch",
      "status" : "yellow",
      "timed_out" : false,
      "number_of_nodes" : 1,
      "number_of_data_nodes" : 1,
      "active_primary_shards" : 8,
      "active_shards" : 8,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 10,
      "delayed_unassigned_shards" : 0,
      "number_of_pending_tasks" : 0,
      "number_of_in_flight_fetch" : 0,
      "task_max_waiting_in_queue_millis" : 0,
      "active_shards_percent_as_number" : 44.44444444444444
    }

Кластер "yellow" потому что 2 индекса "yellow". ind-2 и ind-3, так как в их параметрах указано явное количество реплик, но в кластере только одна data.node и негде хранить реплики, от того есть не распределённые шарды (unassigned_shards)

Удаление индексов:

    curl -X DELETE 'http://localhost:9200/ind-1?pretty'
    curl -X DELETE 'http://localhost:9200/ind-2?pretty'
    curl -X DELETE 'http://localhost:9200/ind-3?pretty'

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

Ответ:

    curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch-8.0.0/snapshots" }}'
    
    curl -XGET localhost:9200/_snapshot/netology_backup?pretty
    {
      "netology_backup" : {
        "type" : "fs",
        "settings" : {
          "location" : "/elasticsearch-8.0.0/snapshots"
        }
      }
    }

    curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'

    curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test  WT3TB20OT0GyjQ3RWothZg   1   0          0            0       225b           225b

    curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
    {"snapshot":{"snapshot":"elasticsearch","uuid":"G1kQu56xSaW25qwO1PLg5Q","repository":"netology_backup","version_id":8000099,"version":"8.0.0","indices":["test",".geoip_databases"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-02-27T19:10:49.705Z","start_time_in_millis":1645989049705,"end_time":"2022-02-27T19:10:51.714Z","end_time_in_millis":1645989051714,"duration_in_millis":2009,"failures":[],"shards":{"total":2,"failed":0,"successful":2},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}

    [elasticsearch@e457026d0536 snapshots]$ ls -la
    total 48
    drwxrwxr-x 3 elasticsearch elasticsearch  4096 Feb 27 19:10 .
    drwxr-xr-x 1 elasticsearch elasticsearch  4096 Feb 27 17:46 ..
    -rw-r--r-- 1 elasticsearch elasticsearch   846 Feb 27 19:10 index-0
    -rw-r--r-- 1 elasticsearch elasticsearch     8 Feb 27 19:10 index.latest
    drwxr-xr-x 4 elasticsearch elasticsearch  4096 Feb 27 19:10 indices
    -rw-r--r-- 1 elasticsearch elasticsearch 17457 Feb 27 19:10 meta-G1kQu56xSaW25qwO1PLg5Q.dat
    -rw-r--r-- 1 elasticsearch elasticsearch   357 Feb 27 19:10 snap-G1kQu56xSaW25qwO1PLg5Q.dat

    curl -X DELETE 'http://localhost:9200/test?pretty'

    url -X PUT localhost:9200/test-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 0 }}'
   
    curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 mi3T5AETS3-TFJO9wlnZVA   2   0          0            0       450b           450b

    curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'

    curl -X GET 'http://localhost:9200/_cat/indices?v'
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 mi3T5AETS3-TFJO9wlnZVA   2   0          0            0       450b           450b
    green  open   test   uo7VaA5VTsKwp1-JiU55iQ   1   0          0            0       225b           225b