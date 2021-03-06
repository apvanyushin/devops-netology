### Задача 1
###### Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС:
1. Полная виртуализация - Поверх железа имеет слой гипервизора, на который уже ставятся ВМ. ВМ использует свои выделенные ресурсы.
2. Паравиртуализация - Поверх железа имеет слой ОС, после уже слой гипервизора, на который уже ставятся ВМ. ВМ использует свои выделенные ресурсы.
3. Виртуализации на основе ОС - Основное отличие виртуализации на уровне ОС в том, что виртуализируется не компьютер и не операционная система, а пользовательское окружение ОС. Эти экземпляры пользовательского окружения, называемые также контейнерами, полностью идентичны основному серверу и используют общее ядро ОС. ВМ использует ресурсы хост машины.
### Задача 2
###### Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.
###### Организация серверов:

1. физические сервера,
2. паравиртуализация,
3. виртуализация уровня ОС. 


###### Условия использования:

1. Высоконагруженная база данных, чувствительная к отказу.
2. Различные web-приложения.
3. Windows системы для использования бухгалтерским отделом.
4. Системы, выполняющие высокопроизводительные расчеты на GPU.

###### Опишите, почему вы выбрали к каждому целевому использованию такую организацию:

###### 1. Высоконагруженная база данных, чувствительная к отказу: 
    Физический сервер, так как требуется высокая производительность, 
    сокращает количество точек отказа в виде гипервизора хост машины.

###### 2. Различные web-приложения:

    Виртуализация уровня ОС (контейнеры)
    Возможность быстрого масштабирования.

###### 3. Windows системы для использования бухгалтерским отделом:
    Паравиртуализация 
    Снижение затрат на приобретение оборудования для рабочих мест.
    Dозможность расширени ресурсов на уровне ВМ для особых сулчаев. 
    Нет критичных требований к аппаратной составляющей сервера.

###### 4. Системы, выполняющие высокопроизводительные расчеты на GPU.
    Физический сервер, так как требуется высокая производительность, 
    сокращает количество точек отказа в виде гипервизора хост машины.

### Задача 3
###### Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.
###### Сценарии:

###### 1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
    VMware vSphere - как наиболее сбалансированный и универсальный продукт.
###### 2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
    KVM является нативным для большинства современных ядер Linux.
    Это дает преимущество в производительности по сравнению с другими системами виртуализации.
###### 3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
    Бесплатный MS Hyper-V - приемущество в совместимости с инфраструктурой Microsoft.
###### 4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.
    Для тестироваия можно использовать все что душе угодно, но все таки зависит от поставленных задач. 
    Поэтому пусть для тестов будет Virtual Box + Vagrant для быстрого развертывания разных ОС.



### Задача 4
###### Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.
    Главная проблема - это стоимость лицензии разных продуктов (платить не за один продук, а за 2 или 3).
    Также проблемой будет поддержка разных сред виртуализации, так как каждая система имеет свои нюансы 
    и требования к уровню знаний инженеров, сложности в ведении собственной документации по разным продуктам.
    
    я считаю, что, по возможности, нужно избегать создания гетерогенной среды. 
