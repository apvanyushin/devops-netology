
###### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
    Windows - ipconfig
    Linux - "netstat -i" или "ifconfig" или "ip -a"

###### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
    Протокол NDP. 
    Пакет ndptool, команды monitor или send

###### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
    Технология vlan
    Пакет vlan (sudo apt-get install vlan)
    Пример конфига:
    ##vlan с ID-100 для интерфейса eth0 with ID - 100 в Debian/Ubuntu Linux##
    auto eth0.100
    iface eth0.100 inet static
    address 192.168.1.200
    netmask 255.255.255.0
    vlan-raw-device eth0
    После настройки vlan и перезапуска службы networking можно выполнить команлу ifconfig для проверки результата:
    vagrant@vagrant:/$ ifconfig
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
            inet6 fe80::a00:27ff:fe73:60cf  prefixlen 64  scopeid 0x20<link>
            ether 08:00:27:73:60:cf  txqueuelen 1000  (Ethernet)
            RX packets 5296  bytes 651401 (651.4 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 3537  bytes 392068 (392.0 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    
    eth0.100: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.3.200  netmask 255.255.255.0  broadcast 192.168.3.255
            inet6 fe80::a00:27ff:fe73:60cf  prefixlen 64  scopeid 0x20<link>
            ether 08:00:27:73:60:cf  txqueuelen 1000  (Ethernet)
            RX packets 0  bytes 0 (0.0 B)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 6  bytes 516 (516.0 B)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

###### 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
    mode=0 (balance-rr)
    При этом методе объединения трафик распределяется по принципу «карусели»: пакеты по очереди направляются на сетевые карты объединённого интерфейса. Например, если у нас есть физические интерфейсы eth0, eth1, and eth2, объединенные в bond0, первый пакет будет отправляться через eth0, второй — через eth1, третий — через eth2, а четвертый снова через eth0 и т.д.
    
    mode=1 (active-backup)
    Когда используется этот метод, активен только один физический интерфейс, а остальные работают как резервные на случай отказа основного.
    
    mode=2 (balance-xor)
    В данном случае объединенный интерфейс определяет, через какую физическую сетевую карту отправить пакеты, в зависимости от MAC-адресов источника и получателя.
    
    mode=3 (broadcast) Широковещательный режим, все пакеты отправляются через каждый интерфейс. Имеет ограниченное применение, но обеспечивает значительную отказоустойчивость.
    
    mode=4 (802.3ad)
    Особый режим объединения. Для него требуется специально настраивать коммутатор, к которому подключен объединенный интерфейс. Реализует стандарты объединения каналов IEEE и обеспечивает как увеличение пропускной способности, так и отказоустойчивость.
    
    mode=5 (balance-tlb)
    Распределение нагрузки при передаче. Входящий трафик обрабатывается в обычном режиме, а при передаче интерфейс определяется на основе данных о загруженности.
    
    mode=6 (balance-alb)
    Адаптивное распределение нагрузки. Аналогично предыдущему режиму, но с возможностью балансировать также входящую нагрузку.

    Пример конфига mode=0:
    $ sudo nano /etc/network/interfaces
    # The primary network interface
    auto bond0
    iface bond0 inet static
        address 192.168.1.150
        netmask 255.255.255.0    
        gateway 192.168.1.1
        dns-nameservers 192.168.1.1 8.8.8.8
        dns-search domain.local
            slaves eth0 eth1
            bond_mode 0
            bond-miimon 100
            bond_downdelay 200
            bound_updelay 200
        

###### 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
    В сети с маской /29 - 6 адресов.
    vagrant@vagrant:/$ ipcalc 172.16.0.1/29
    Address:   172.16.0.1           10101100.00010000.00000000.00000 001
    Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
    Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
    =>
    Network:   172.16.0.0/29        10101100.00010000.00000000.00000 000
    HostMin:   172.16.0.1           10101100.00010000.00000000.00000 001
    HostMax:   172.16.0.6           10101100.00010000.00000000.00000 110
    Broadcast: 172.16.0.7           10101100.00010000.00000000.00000 111
    Hosts/Net: 6                     Class B, Private Internet
    
    Из сети с маской /24 можно получить 32 подсети с маской /29
    
    1. Requested size: 6 hosts
    Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
    Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
    HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
    HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
    Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
    Hosts/Net: 6                     Class A, Private Internet

    2. Requested size: 6 hosts
    Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
    Network:   10.10.10.8/29        00001010.00001010.00001010.00001 000
    HostMin:   10.10.10.9           00001010.00001010.00001010.00001 001
    HostMax:   10.10.10.14          00001010.00001010.00001010.00001 110
    Broadcast: 10.10.10.15          00001010.00001010.00001010.00001 111
    Hosts/Net: 6                     Class A, Private Internet
        
    ...
    
    32. Requested size: 6 hosts
    Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
    Network:   10.10.10.248/29      00001010.00001010.00001010.11111 000
    HostMin:   10.10.10.249         00001010.00001010.00001010.11111 001
    HostMax:   10.10.10.254         00001010.00001010.00001010.11111 110
    Broadcast: 10.10.10.255         00001010.00001010.00001010.11111 111
    Hosts/Net: 6                     Class A, Private Internet

###### 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
    Диапазон 100.64.0.0 — 100.127.255.255.
    Requested size: 50 hosts
    Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
    Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
    HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
    HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
    Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
    Hosts/Net: 62                    Class A
###### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
    Проверить ARP таблицу:
    Windows - arp -a
    Linux - arp
    
    Очистить кэш ARP:
    netsh interface ip delete arpcache
    
    Удалить только один нужный IP:
    arp -d IP