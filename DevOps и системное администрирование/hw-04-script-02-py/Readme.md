##### Обязательная задача 1
Есть скрипт:

    #!/usr/bin/env python3
    a = 1
    b = '2'
    c = a + b
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | name 'c' is not defined  |
| Как получить для переменной `c` значение 12?  | c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

##### Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
    
    #!/usr/bin/env python3
    
    import os
    
    bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break
Ваш скрипт:
    
    # Убрал строку "is_change = False", не знаю что она делает в этом скрипте, работает без нее. 
    # В цикле убрал break, чтобы скрипт продолжал работу после первого совпадения.
    # Добавить переменную 'p', в которую передается полный путь для каждого измененного файла
    #!/usr/bin/env python3
    
    import os
    
    bash_command = ["cd ~/netology/", "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            p = os.path.abspath(prepare_result)
            print(p)
Вывод скрипта при запуске при тестировании:
    
    vagrant@vagrant:~$ python3 scr.py
    /home/vagrant/test.txt
    /home/vagrant/test2.txt
    /home/vagrant/test3.txt
###### Обязательная задача 3
Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
Ваш скрипт:
    
    #!/usr/bin/env python3

    import os
    import sys
    
    dir = sys.argv[1]
    bash_command = ["cd "+dir, "git status"]
    result_os = os.popen(' && '.join(bash_command)).read()
    for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            p = os.path.abspath(prepare_result)
            print(p)
    
Вывод скрипта при запуске при тестировании:
    
    vagrant@vagrant:~$ python3 scr.py ~/netology/
    /home/vagrant/test.txt
    /home/vagrant/test2.txt
    /home/vagrant/test3.txt

    vagrant@vagrant:~$ python3 scr.py ~/test
    fatal: not a git repository (or any of the parent directories): .git
###### Обязательная задача 4
Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.
Ваш скрипт:
    
    ##!/usr/bin/env python3

    import socket as s
    import time as t
    import datetime as dt
    
    i = 1
    wait = 2
    srv = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}
    init=0
    
    print('*** start script ***')
    print(srv)
    
    while 1==1 :
      for host in srv:
        ip = s.gethostbyname(host)
        if ip != srv[host]:
          if i==1 and init !=1:
            print(str(dt.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+srv[host>      srv[host]=ip
    
      t.sleep(wait)
    
Вывод скрипта при запуске при тестировании:

    vagrant@vagrant:~$ python3 srv.py
    *** start script ***
    {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
    2021-12-22 15:00:25 [ERROR] drive.google.com IP mistmatch: 0.0.0.0 64.233.161.194
    2021-12-22 15:00:25 [ERROR] mail.google.com IP mistmatch: 0.0.0.0 216.58.209.197
    2021-12-22 15:00:25 [ERROR] google.com IP mistmatch: 0.0.0.0 216.58.210.174
    2021-12-22 15:01:03 [ERROR] mail.google.com IP mistmatch: 216.58.209.197 216.58.210.165
    2021-12-22 15:02:17 [ERROR] google.com IP mistmatch: 216.58.210.174 216.58.210.142