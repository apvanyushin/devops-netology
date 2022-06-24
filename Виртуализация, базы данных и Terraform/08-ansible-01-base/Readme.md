# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

    root@vagrant:/home/vagrant/ansible/ansible# ansible-playbook site.yml -i inventory/test.yml


    PLAY [Print os facts] **************************************************************************************************
    
    TASK [Gathering Facts] *************************************************************************************************
    ok: [localhost]
    
    TASK [Print OS] ********************************************************************************************************
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    
    TASK [Print fact] ******************************************************************************************************
    ok: [localhost] => {
        "msg": 12
    }
    
    PLAY RECAP *************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

some_fact = 12, это видно в таске "Print fact". 12 потому что значение переменной some_fact заданно в файле ansible/group_vars/all/examp.yml

---

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

Готово:

    PLAY [Print os facts] **************************************************************************************************
    
    TASK [Gathering Facts] *************************************************************************************************
    ok: [localhost]
    
    TASK [Print OS] ********************************************************************************************************
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ******************************************************************************************************
    ok: [localhost] => {
        "msg": "all default fact"
    }
    
    PLAY RECAP *************************************************************************************************************
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.


    root@vagrant:/home/vagrant/ansible/ansible# docker ps
    CONTAINER ID   IMAGE      COMMAND           CREATED          STATUS          PORTS     NAMES
    867b4b51b2b2   ubuntu     "sleep 6000000"   5 seconds ago    Up 3 seconds              ubuntu
    59d39c467f5a   centos:7   "sleep 6000000"   52 seconds ago   Up 49 seconds             centos7

5. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.


    root@vagrant:/home/vagrant/ansible/ansible# ansible-playbook site.yml -i inventory/prod.yml
    
    PLAY [Print os facts] ******************************************************************************************************************************************
    
    TASK [Gathering Facts] *****************************************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] **********************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el"
    }
    ok: [ubuntu] => {
        "msg": "deb"
    }
    
    PLAY RECAP *****************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

6. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
7. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.


    root@vagrant:/home/vagrant/ansible/ansible# ansible-playbook site.yml -i inventory/prod.yml
    
    PLAY [Print os facts] ******************************************************************************************************************************************
    
    TASK [Gathering Facts] *****************************************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] **********************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    
    PLAY RECAP *****************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

8. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.


    root@vagrant:/home/vagrant/ansible/ansible# ansible-vault encrypt group_vars/deb/examp.yml
    root@vagrant:/home/vagrant/ansible/ansible# ansible-vault encrypt group_vars/el/examp.yml

9. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.


    root@vagrant:/home/vagrant/ansible/ansible# ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
    Vault password:

    PLAY[Print os facts] ******************************************************************************************************************************************
    
    TASK [Gathering Facts] *****************************************************************************************************************************************
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ************************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] **********************************************************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    
    PLAY RECAP *****************************************************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

10. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

root@vagrant:/home/vagrant/ansible/ansible# ansible-doc -t connection -l | grep control
community.docker.nsenter       execute on host running controller container
local                          execute on controller

---

11. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.


      GNU nano 4.8                                            prod.yml                                                      ---
          el:
            hosts:
              centos7:
                ansible_connection: docker
          deb:
            hosts:
              ubuntu:
                ansible_connection: docker
          local:
            hosts:
              localhost:
                ansible_connection: local

12. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.


    root@vagrant:/home/vagrant/ansible/ansible# ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
    Vault password:
    
    PLAY [Print os facts] **************************************************************************************************
    
    TASK [Gathering Facts] *************************************************************************************************
    ok: [localhost]
    ok: [ubuntu]
    ok: [centos7]
    
    TASK [Print OS] ********************************************************************************************************
    ok: [centos7] => {
        "msg": "CentOS"
    }
    ok: [ubuntu] => {
        "msg": "Ubuntu"
    }
    ok: [localhost] => {
        "msg": "Ubuntu"
    }
    
    TASK [Print fact] ******************************************************************************************************
    ok: [centos7] => {
        "msg": "el default fact"
    }
    ok: [ubuntu] => {
        "msg": "deb default fact"
    }
    ok: [localhost] => {
        "msg": "all default fact"
    }
    
    PLAY RECAP *************************************************************************************************************
    centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

13. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

https://github.com/apvanyushin/ansible
