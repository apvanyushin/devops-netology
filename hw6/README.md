###### 1. Какого типа команда cd? 
    cd - это встроенная команда оболочки 

###### 2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? 
    Создал тестовый файл с набором символов и выполнил команду
    vagrant@vagrant:~$ grep 3 test | wc -l
        3
    (количество строк, где встречается симвор "3" равно трём.)
    Аналогичная команда без pipe:
    vagrant@vagrant:~$ grep 3 test -c
        3

###### 3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
    systemd PID 1
###### 4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
    ls %(пример несуществующей директории) 2>/dev/pts/1
    В другом терминале появится сообщение об ошибке "ls: cannot access '%': No such file or directory"
    При этом в первом окне терминала не будет сообщения об ошибке.
    Термнал 1, по завершению выполнения команды ls, будет в состоянии ожидания ввода команды. 
###### 5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
    Создал файл input (nano input), с содержимым:
     /dev
    /bin
    test
    Для команды cat вводные данные взял из файла input и вывел их в файл output
        vagrant@vagrant:~$ cat < input > output
    Проверить результат: 
        vagrant@vagrant:~$ cat output
        /dev
        /bin
        test
###### 6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
    Вывести данные получится. 
    Выполнил вход в систему через vitrualbox, чтобы создалась сессия с tty. 
        vagrant@vagrant:~$ tty
        /dev/tty2
    В терминале, который подключен по ssh выполнил:
        echo Hello word to tty2 >/dev/tty2
    В терминале tty появляется сообщение "echo Hello word to tty2", но в pty эта информация недоступна.
    
    PS. Выполнял задание с использованием virtualbox, так как в windows terminal не удается получить доступ к эмулятору терминала (в лекции было сказано, что в Linux нажатие Ctrl + Alt + F1..F6 позволяет запустить несколько независимых сессий), но в windows terminal, при нажатии, например, на ctrl + alt + F2 просто пишется символ "Q"  vagrant@vagrant:~$ Q.
    
###### 7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
    bash 5>&1 создаст FD 5 и перенаправит его в стандартный выходной поток (stdout)
    echo netology > /proc/$$/fd/5 -  FD 5 примет данные и выведет их в терминале, так как был перенаправлен в stdout

###### 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
    Придумал команду, которая пишет и в stdout и в stderr (предварительно создал папку testFolder).
        ls testolder testFolder
    Поменял потоки местами через промежуточный дескриптор, как указано в подсказке. 
        Промежуточный FD перенаправлен в stderr 4>&2, stderr перенаправлен в stdout 2>&1, а stdout в свою очередь перенаправлен в промежуточный FD 1>&4
    Проверил, что в pipe на вход принимается данные из stderr, при этом stdout отображается в терминале:
        vagrant@vagrant:~$ ls testolder testFolder 4>&2 2>&1 1>&4 | grep cannot -c 
        testFolder:
        1
    PS. В данном примере grep ведет счетчик по слову "cannot", полный текст ошибки "ls: cannot access 'testolder': No such file or directory" 
    
###### 9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
    Альтернативный вариант получения переменных среды - команда printenv

###### 10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.
    /proc/[pid]/cmdline - Это файл, доступный только для чтения, содержит полную командную строку для процесса, если только процесс не является зомби.
    /proc/[pid]/exe - В Linux 2.2 и более поздних версиях этот файл представляет собой символьную ссылку, содержащую фактический путь к исполняемому файлу.

###### 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.
    Это sse4_2.
        vagrant@vagrant:~$ cat /proc/cpuinfo | grep sse
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid
        sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase avx2 invpcid md_clear flush_l1d
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid
        sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm invpcid_single pti fsgsbase avx2 invpcid md_clear flush_l1d

###### 12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:
    vagrant@netology1:~$ ssh localhost 'tty'
    not a tty
###### Почитайте, почему так происходит, и как изменить поведение.
    По умолчанию при подчключении через ssh tty недоступен. Исправить это можно задав ключ -t. 
    Полная команда выгляит вот так:
        ssh -t localhost 'tty'
###### 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
    Потребовалась предварительная установка reptyr.
        apt-get install reptyr
    Задал значение kernel.yama.ptrace_scope = 0 и перезагрузил виртуальную машину
    Создал "безобидный" процесс, который можно переместить в screen
        nano 123
    Выполнил команду Ctrl + Z, чтобы процесс nano остался в фоне
    Проверил список процессов в фоне (и их PID)
        vagrant@vagrant:~$ ps
            PID TTY          TIME CMD
            1510 pts/7    00:00:00 bash
            1533 pts/7    00:00:00 nano
            1536 pts/7    00:00:00 ps
    Запустил screen
    В новом окно выполнил reptyr 1533. Открылся редактор nano с несохраненными данными. 
    
    
###### 14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
    tee - Читает данные из stdinput и передает их в stdout и в файл (если он указан в виде параметра).
    echo string | sudo tee /root/new_file выполнится, так как echo это команда оболочки и повышение прав sudo на нее не рабоает, в отличии от tee (tee is /usr/bin/tee)





