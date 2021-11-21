

###### 1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

    Установка:
    vagrant@vagrant:~$ wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz -P /tmp
    vagrant@vagrant:~$ cd /tmp
    Распаковка:
    vagrant@vagrant:/tmp$ tar -zxpvf node_exporter-1.0.1.linux-amd64.tar.gz
    vagrant@vagrant:/tmp$ cd node_exporter-1.0.1.linux-amd64
    Копирование в bin:
    vagrant@vagrant:/tmp/node_exporter-1.0.1.linux-amd64$ sudo cp node_exporter /usr/local/bin
    Создание системного пользователя:
    vagrant@vagrant:/tmp/node_exporter-1.0.1.linux-amd64$ sudo useradd --no-create-home --shell /bin/false node_exporter
    Предоставоление прав на запуск:
    vagrant@vagrant:/tmp/node_exporter-1.0.1.linux-amd64$ sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
    Создание unit файла:
    vagrant@vagrant:/tmp/node_exporter-1.0.1.linux-amd64$ sudo nano /etc/systemd/system/node_exporter.service
    Содержимое unit файла:
    [Unit]
    Description=Prometheus Node Exporter
    Wants=network-online.target
    After=network-online.target
    
    [Service]
    User=node_exporter
    Group=node_exporter
    Type=simple
    ExecStart=/usr/local/bin/node_exporter
    
    [Install]
    WantedBy=multi-user.target
    
    Добавление в автозагрузку и проверка статуса:
    vagrant@vagrant:/tmp/node_exporter-1.0.1.linux-amd64$ sudo systemctl daemon-reload
    vagrant@vagrant:/tmp/node_exporter-1.0.1.linux-amd64$ sudo systemctl enable --now node_exporter
    Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
    vagrant@vagrant:/tmp/node_exporter-1.0.1.linux-amd64$ sudo systemctl status node_exporter
    ● node_exporter.service - Prometheus Node Exporter
         Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset>
         Active: active (running)since Sun 2021-11-21 09:43:34 UTC; 10s ago
       Main PID: 1305 (node_exporter)
          Tasks: 5 (limit: 1071)
         Memory: 2.2M
         CGroup: /system.slice/node_exporter.service
                 └─1305 /usr/local/bin/node_exporter

    После перезагрузки служба успешно запускается (то есть работает автозагрузка), команды stop и start отрабатывают корректно:
    vagrant@vagrant:~$ sudo systemctl stop node_exporter
    vagrant@vagrant:~$ sudo systemctl status node_exporter
    ● node_exporter.service - Prometheus Node Exporter
         Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset>
         Active: inactive (dead) since Sun 2021-11-21 10:00:24 UTC; 1s ago
        Process: 640 ExecStart=/usr/local/bin/node_exporter (code=killed, signal=TERM)
       Main PID: 640 (code=killed, signal=TERM)

##### Cron
    Создание таблицы для node_explorer:
    vagrant@vagrant:~$ sudo crontab -u node_exporter -e
    Запуск файла каждое воскресенье (пока не придумал действительно полезный пример для использования cron и node_exporter)
    0 17 * * sun /usr/local/bin/node_exporter


##### 2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
    CPU:
    node_cpu_seconds_total{cpu="0",mode="idle"} 270.41
    node_cpu_seconds_total{cpu="0",mode="system"} 5.93
    node_cpu_seconds_total{cpu="0",mode="user"} 5.86
    
    Memory:
        node_memory_MemAvailable_bytes 
        node_memory_MemFree_bytes
        
    Disk:
        node_disk_io_time_seconds_total{device="sda"} 
        node_disk_read_bytes_total{device="sda"} 
        node_disk_read_time_seconds_total{device="sda"} 
        node_disk_write_time_seconds_total{device="sda"}
        
    Network:
        node_network_receive_errs_total{device="eth0"} 
        node_network_receive_bytes_total{device="eth0"} 
        node_network_transmit_bytes_total{device="eth0"}
        node_network_transmit_errs_total{device="eth0"}
##### 3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
![image](https://user-images.githubusercontent.com/92942650/142770154-dc9aed29-4ea3-42d9-a282-4eb540e1e05c.png)

##### 4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
    Да, возможно.
    vagrant@vagrant:~$ dmesg | grep virtual
    [    0.008750] CPU MTRRs all blank - virtualized system.
    [    0.165568] Booting paravirtualized kernel on KVM
    [    3.823958] systemd[1]: Detected virtualization oracle.
##### 5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
    file: /proc/sys/fs/nr_open
    variable: fs.nr_open
    Задает аксимальное количество дескрипторов файлов, которое может выделить процесс. 
    vagrant@vagrant:~$ sysctl fs.nr_open
    fs.nr_open = 1048576
    ulimit -n задает Максимальное количество открытых файловых дескрипторов. Имеет два параметар S (Soft) и H(Hard) (soft лимит может быть привышен до пределов hard лимита, hard лимит привысить нельзя).
    ulimit -Sn и -Hn не могут превысить fs.nr_open.
##### 6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
    Запустил bash в новом namespace при помощи unshare
    vagrant@vagrant:~$ unshare -Urpf --mount-proc bash
    root@vagrant:~# ps
        PID TTY          TIME CMD
          1 pts/0    00:00:00 bash
          7 pts/0    00:00:00 ps 
##### 7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
    Определяет функцию с именем : , которая вызывает себя дважды (Код: : | : ). Это происходит в фоновом режиме ( & ). После ; определение функции выполнено, и функция : запускается.
    "Механизм" восстановления - [ 6629.402945] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-11.scope
    Можно ограничить число прцоессов для пользователя ulimit -u 50 
