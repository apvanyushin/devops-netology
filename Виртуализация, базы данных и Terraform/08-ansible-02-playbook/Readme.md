# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook. 
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`. 

## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.


        ---
        elasticsearch:
          hosts:
              ubuntu:
                ansible_connection: docker
              centos7:
                ansible_connection: docker

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.


        При выполнении ansible-lint site.yml ошибок нет, есть предупреждения, 
        которые не менают выполнению playbook

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.


        При выполнении ansible-playbook --check site.yml -i inventory/prod.yml возникает ошибка:
        TASK [Extract java in the installation directory] **********************************************************************
        An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
        fatal: [ubuntu]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.11' must be an existing dir"}
        An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
        fatal: [centos7]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.11' must be an existing dir"}
    
        Это связанос с тем что при запуске check не выполняет действия, 
        а просто показывает какие изменения будут внесены при запуске playbook.
        То есть task "Create directrory for Java" не создает папку, а показывает что при выполнении такая папка будет создана.
        TASK [Create directrory for Java] **************************************************************************************
        changed: [ubuntu]
        changed: [centos7]

        Но при выполнении task "Extract java in the installation directory" этой папки нет и playbook валится с ошибкой.


7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.


        root@vagrant:/home/vagrant/ansible/hw2/ansible_2/playbook# ansible-playbook --diff site.yml -i inventory/prod.yml

        PLAY [Install Java] ****************************************************************************************************

        TASK [Gathering Facts] *************************************************************************************************
        ok: [ubuntu]
        ok: [centos7]
        
        TASK [Set facts for Java 11 vars] **************************************************************************************
        ok: [ubuntu]
        ok: [centos7]

        TASK [Upload .tar.gz file containing binaries from local storage] ******************************************************
        diff skipped: source file size is greater than 104448
        changed: [ubuntu]
        diff skipped: source file size is greater than 104448
        changed: [centos7]

        TASK [Create directrory for Java] **************************************************************************************
        --- before
        +++ after
        @@ -1,4 +1,4 @@
        {
            "path": "/opt/jdk/11.0.11",
        -    "state": "absent"
        + "state": "directory"
        }
        
        changed: [ubuntu]
        --- before
        +++ after
        @@ -1,4 +1,4 @@
        {
             "path": "/opt/jdk/11.0.11",
         -    "state": "absent"
         + "state": "directory"
        }

        changed: [centos7]
        
        TASK [Extract java in the installation directory] **********************************************************************
        changed: [ubuntu]
        changed: [centos7]

        TASK [Export environment variables] ************************************************************************************
        --- before
        +++ after: /root/.ansible/tmp/ansible-local-17294ik61y_7n/tmp03be631l/jdk.sh.j2
        @@ -0,0 +1,5 @@
        +# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
        +#!/usr/bin/env bash
        +
        +export JAVA_HOME=/opt/jdk/11.0.11
        +export PATH=$PATH:$JAVA_HOME/bin
        \ No newline at end of file

        changed: [centos7]
        --- before
        +++ after: /root/.ansible/tmp/ansible-local-17294ik61y_7n/tmp1uzzycqc/jdk.sh.j2
        @@ -0,0 +1,5 @@
        +# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
        +#!/usr/bin/env bash
        +
        +export JAVA_HOME=/opt/jdk/11.0.11
        +export PATH=$PATH:$JAVA_HOME/bin
        \ No newline at end of file

        changed: [ubuntu]
        
        PLAY [Install Elasticsearch] *******************************************************************************************
        
        TASK [Gathering Facts] *************************************************************************************************
        ok: [ubuntu]
        ok: [centos7]

        TASK [Upload tar.gz Elasticsearch file from local storage] *************************************************************
        diff skipped: source file size is greater than 104448
        changed: [centos7]
        diff skipped: source file size is greater than 104448
        changed: [ubuntu]

        TASK [Create directrory for Elasticsearch] *****************************************************************************
        --- before
        +++ after
        @@ -1,4 +1,4 @@
        {
             "path": "/opt/elastic/7.10.1",
        -    "state": "absent"
        + "state": "directory"
        }

        changed: [centos7]
        --- before
        +++ after
        @@ -1,4 +1,4 @@
        {
             "path": "/opt/elastic/7.10.1",
         -    "state": "absent"
         + "state": "directory"
        }

        changed: [ubuntu]

        TASK [Extract Elasticsearch in the installation directory] *************************************************************
        changed: [ubuntu]
        changed: [centos7]

        TASK [Set environment Elastic] *****************************************************************************************
        --- before
        +++ after: /root/.ansible/tmp/ansible-local-17294ik61y_7n/tmp7t98ec28/elk.sh.j2
        @@ -0,0 +1,5 @@
        +# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
        +#!/usr/bin/env bash
        +
        +export ES_HOME=/opt/elastic/7.10.1
        +export PATH=$PATH:$ES_HOME/bin
        \ No newline at end of file

        changed: [centos7]
        --- before
        +++ after: /root/.ansible/tmp/ansible-local-17294ik61y_7n/tmp367ap44m/elk.sh.j2
        @@ -0,0 +1,5 @@
        +# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
        +#!/usr/bin/env bash
        +
        +export ES_HOME=/opt/elastic/7.10.1
        +export PATH=$PATH:$ES_HOME/bin
        \ No newline at end of file

        changed: [ubuntu]
        
        PLAY [Install Kibana] **************************************************************************************************
        
        TASK [Gathering Facts] *************************************************************************************************
        ok: [ubuntu]
        ok: [centos7]
        
        TASK [Upload tar.gz Kibana file from local storage] ********************************************************************
        diff skipped: source file size is greater than 104448
        changed: [ubuntu]
        diff skipped: source file size is greater than 104448
        changed: [centos7]

        TASK [Create directrory for kibana] ************************************************************************************
        --- before
        +++ after
        @@ -1,4 +1,4 @@
        {
            "path": "/opt/kibana/7.10.1",
        -    "state": "absent"
        + "state": "directory"
        }

        changed: [centos7]
        --- before
        +++ after
        @@ -1,4 +1,4 @@
         {
             "path": "/opt/kibana/7.10.1",
        -    "state": "absent"
        + "state": "directory"
        }

        changed: [ubuntu]
        
        TASK [Extract kibana in the installation directory] ********************************************************************
        changed: [ubuntu]
        changed: [centos7]

        PLAY RECAP *************************************************************************************************************
        centos7                    : ok=15   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
        ubuntu                     : ok=15   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


Проверка, что изменения были выполнены:


        root@vagrant:/home/vagrant/ansible/hw2/ansible_2/playbook# docker exec -it centos7 bash
        [root@8e24979b16ad /]# cd opt
        [root@8e24979b16ad opt]# ls
        elastic  jdk  kibana


8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.


        PLAY RECAP *************************************************************************************************************
        centos7                    : ok=12   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
        ubuntu                     : ok=12   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0


9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.

    https://github.com/apvanyushin/ansible_2


