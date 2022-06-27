# Домашнее задание к занятию "08.03 Работа с Roles"

## Подготовка к выполнению
1. Создайте два пустых публичных репозитория в любом своём проекте: elastic-role и kibana-role.
2. Скачайте [role](./roles/) из репозитория с домашним заданием и перенесите его в свой репозиторий elastic-role.
3. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`. 
4. Установите molecule: `pip3 install molecule`
5. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для elastic, kibana и написать playbook для использования этих ролей. Ожидаемый результат: существуют два ваших репозитория с roles и один репозиторий с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:
   ```yaml
   ---
     - src: git@github.com:netology-code/mnt-homeworks-ansible.git
       scm: git
       version: "1.0.1"
       name: java 
   ```
2. При помощи `ansible-galaxy` скачать себе эту роль. Запустите  `molecule test`, посмотрите на вывод команды.

      
      root@vagrant:/home/vagrant/ansible/hw2/ansible_2/playbook# ansible-galaxy install -r requirements.yml -p roles
      - extracting java to /home/vagrant/ansible/hw2/ansible_2/roles/java
      - java (1.0.1) was installed successfully

      root@vagrant:/home/vagrant/ansible/hw2/ansible_2/playbook/roles/java# molecule test
      INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
      INFO     Performing prerun with role_name_check=0...
      INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/38a096/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
      INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/38a096/collections:/root/.ansible/collections:/usr/share/ansible/collections
      INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/38a096/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
      ERROR    Computed fully qualified role name of java does not follow current galaxy requirements.
      Please edit meta/main.yml and assure we can correctly determine full role name:



3. Перейдите в каталог с ролью elastic-role и создайте сценарий тестирования по умолчаню при помощи `molecule init scenario --driver-name docker`.
4. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.


Ошибки исправлены, тест выполняется без ошибок:


      root@vagrant:/home/vagrant/ansible/hw2/ansible_2/playbook/roles/elastic-role# molecule test
      INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
      INFO     Performing prerun with role_name_check=0...
      INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/12e536/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
      INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/12e536/collections:/root/.ansible/collections:/usr/share/ansible/collections
      INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/12e536/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
      INFO     Running default > dependency
      WARNING  Skipping, missing the requirements file.
      WARNING  Skipping, missing the requirements file.
      INFO     Running default > lint
      INFO     Lint is disabled.
      INFO     Running default > cleanup
      WARNING  Skipping, cleanup playbook not configured.
      INFO     Running default > destroy
      INFO     Sanity checks: 'docker'
      
      PLAY [Destroy] *****************************************************************
      
      TASK [Destroy molecule instance(s)] ********************************************
      changed: [localhost] => (item=instance)
      changed: [localhost] => (item=centos8)
      changed: [localhost] => (item=ubuntu)
      
      TASK [Wait for instance(s) deletion to complete] *******************************
      ok: [localhost] => (item=instance)
      ok: [localhost] => (item=centos8)
      ok: [localhost] => (item=ubuntu)
      
      TASK [Delete docker networks(s)] ***********************************************
      
      PLAY RECAP *********************************************************************
      localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
      
      INFO     Running default > syntax
      
      playbook: /home/vagrant/ansible/hw2/ansible_2/playbook/roles/elastic-role/molecule/default/converge.yml
      INFO     Running default > create
      
      PLAY [Create] ******************************************************************
      
      TASK [Log into a Docker registry] **********************************************
      skipping: [localhost] => (item=None)
      skipping: [localhost] => (item=None)
      skipping: [localhost] => (item=None)
      skipping: [localhost]
      
      TASK [Check presence of custom Dockerfiles] ************************************
      ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})
      ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
      ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
      
      TASK [Create Dockerfiles from image names] *************************************
      skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})
      skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
      skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
      
      TASK [Discover local Docker images] ********************************************
      ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
      ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
      ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})
      
      TASK [Build an Ansible compatible image (new)] *********************************
      skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7)
      skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8)
      skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)
      
      TASK [Create docker network(s)] ************************************************
      
      TASK [Determine the CMD directives] ********************************************
      ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})
      ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
      ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
      
      TASK [Create molecule instance(s)] *********************************************
      changed: [localhost] => (item=instance)
      changed: [localhost] => (item=centos8)
      changed: [localhost] => (item=ubuntu)
      
      TASK [Wait for instance(s) creation to complete] *******************************
      FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
      changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '637077963646.92117', 'results_file': '/root/.ansible_async/637077963646.92117', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
      changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '389544369026.92144', 'results_file': '/root/.ansible_async/389544369026.92144', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
      changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '830969091855.92184', 'results_file': '/root/.ansible_async/830969091855.92184', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
      
      PLAY RECAP *********************************************************************
      localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
      
      INFO     Running default > prepare
      WARNING  Skipping, prepare playbook not configured.
      INFO     Running default > converge
      
      PLAY [Converge] ****************************************************************
      
      TASK [Include elastic-role] ****************************************************
      
      TASK [elastic-role : Upload tar.gz Elasticsearch file from local storage] ******
      changed: [instance]
      changed: [ubuntu]
      changed: [centos8]
      
      TASK [elastic-role : Create directrory for Elasticsearch] **********************
      changed: [ubuntu]
      changed: [instance]
      changed: [centos8]
      
      TASK [elastic-role : Extract Elasticsearch in the installation directory] ******
      changed: [ubuntu]
      changed: [centos8]
      changed: [instance]
      
      TASK [elastic-role : Set environment Elastic] **********************************
      changed: [ubuntu]
      changed: [centos8]
      changed: [instance]
      
      PLAY RECAP *********************************************************************
      centos8                    : ok=4    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
      instance                   : ok=4    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
      ubuntu                     : ok=4    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
      
      INFO     Running default > idempotence
      
      PLAY [Converge] ****************************************************************
      
      TASK [Include elastic-role] ****************************************************
      
      TASK [elastic-role : Upload tar.gz Elasticsearch file from local storage] ******
      ok: [ubuntu]
      ok: [instance]
      ok: [centos8]
      
      TASK [elastic-role : Create directrory for Elasticsearch] **********************
      ok: [ubuntu]
      ok: [centos8]
      ok: [instance]
      
      TASK [elastic-role : Extract Elasticsearch in the installation directory] ******
      skipping: [centos8]
      skipping: [instance]
      skipping: [ubuntu]
      
      TASK [elastic-role : Set environment Elastic] **********************************
      ok: [ubuntu]
      ok: [centos8]
      ok: [instance]
      
      PLAY RECAP *********************************************************************
      centos8                    : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
      instance                   : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
      ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
      
      INFO     Idempotence completed successfully.
      INFO     Running default > side_effect
      WARNING  Skipping, side effect playbook not configured.
      INFO     Running default > verify
      INFO     Running Ansible Verifier
      
      PLAY [Verify] ******************************************************************
      
      TASK [Example assertion] *******************************************************
      ok: [centos8] => {
          "changed": false,
          "msg": "All assertions passed"
      }
      ok: [instance] => {
          "changed": false,
          "msg": "All assertions passed"
      }
      ok: [ubuntu] => {
          "changed": false,
          "msg": "All assertions passed"
      }
      
      PLAY RECAP *********************************************************************
      centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
      instance                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
      ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
      
      INFO     Verifier completed successfully.
      INFO     Running default > cleanup
      WARNING  Skipping, cleanup playbook not configured.
      INFO     Running default > destroy
      
      PLAY [Destroy] *****************************************************************
      
      TASK [Destroy molecule instance(s)] ********************************************
      changed: [localhost] => (item=instance)
      changed: [localhost] => (item=centos8)
      changed: [localhost] => (item=ubuntu)
      
      TASK [Wait for instance(s) deletion to complete] *******************************
      FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
      changed: [localhost] => (item=instance)
      changed: [localhost] => (item=centos8)
      changed: [localhost] => (item=ubuntu)
      
      TASK [Delete docker networks(s)] ***********************************************
      
      PLAY RECAP *********************************************************************
      localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
      
      INFO     Pruning extra files from scenario ephemeral directory


5. Создайте новый каталог с ролью при помощи `molecule init role --driver-name docker kibana-role`. Можете использовать другой драйвер, который более удобен вам.

Создал роль с именем kibana_role

      root@vagrant:/home/vagrant/ansible/hw2/ansible_2/playbook/roles# molecule init role 'acme.kibana-role' --driver-name docker
      CRITICAL Outside collections you must mention role namespace like: molecule init role 'acme.myrole'. Be sure you use only lowercase characters and underlines. See https://galaxy.ansible.com/docs/contributing/creating_role.html
      root@vagrant:/home/vagrant/ansible/hw2/ansible_2/playbook/roles# molecule init role 'acme.kibana_role' --driver-name docker
      INFO     Initializing new role kibana_role...
      No config file found; using defaults
      Role kibana_role was created successfully
      [WARNING]: No inventory was parsed, only implicit localhost is available
      localhost | CHANGED => {"backup": "","changed": true,"msg": "line added"}
      INFO     Initialized role in /home/vagrant/ansible/hw2/ansible_2/playbook/roles/kibana_role successfully.


6. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. Проведите тестирование на разных дистрибитивах (centos:7, centos:8, ubuntu).
7. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию.
8. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

https://github.com/apvanyushin/kibana-role

https://github.com/apvanyushin/elastic-role/tree/master/roles


https://github.com/apvanyushin/example-playbook
