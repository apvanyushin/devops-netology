# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

Ответ:
    
    root@vagrant:/home/vagrant/go# go version
    go version go1.13.8 linux/amd64

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
   
Ответ:

Исходные данные вводятся в консоль, если ввели не число, то в терминале будет сообщение об ошибке:

    package main
    
    import (
            "fmt"
            "strconv"
    )
    
    func main() {
            fmt.Print("Enter a number: ")
            var input string
            var ft float64 = 3.28084
            fmt.Scanf("%s", &input)
            if i, err := strconv.ParseInt(input, 10, 64); err == nil {
                    output := float64(i) * ft
                    fmt.Println(output,"ft")
            } else {
                    fmt.Println(input, "is not a number")
            }
    
    }


Проверка:

    root@vagrant:/home/vagrant/go# go run ft.go
    Enter a number: 12
    39.37008 ft

Если в input не число:

    root@vagrant:/home/vagrant/go# go run ft.go
    Enter a number: test
    test is not a number
 
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
   
Ответ:

    package main
    
    import (
        "fmt"
    )
    
    func main() {
        x := []int{927849, 579221, 644176, 864306, 53921, 24267, 26738, 91521, 80441, 44756, 51731, 23164, 91037, 19205, 94377, 34751, 75915, 8633, 69331, 4395, 90759, 58833, 24154, 51233, 55940, 84906, 5489445, 451544, 71565}
    
        smallest := x[0]
        for _, num := range x[1:] {
            if num < smallest {
                smallest = num
            }
        }
        fmt.Println(smallest)
    
    }

    
Проверка:

    root@vagrant:/home/vagrant/go# go run smallint.go
    4395

Удалил из списка число 4395:

    root@vagrant:/home/vagrant/go# go run smallint.go
    8633

1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

В виде решения ссылку на код или сам код. 

Ответ:

    package main

    import (
        "fmt"
    )
    
    func main() {
    
        for i := 1; i <= 100; i++ {
            if i%3 == 0 {
                fmt.Println(i)
            }
        }
    }

Проверка:

    root@vagrant:/home/vagrant/go# go run next.go
    3
    6
    9
    12
    15
    18
    21
    24
    27
    30
    33
    36
    39
    42
    45
    48
    51
    54
    57
    60
    63
    66
    69
    72
    75
    78
    81
    84
    87
    90
    93
    96
    99

Дополнительно выполнил это же задание для варианта с вводом чисел в терминале (максимальное число и делитель)

    package main

    import (
            "fmt"
    )
    
    func main() {
    
            var m int
            var d int
            fmt.Print("Enter the maximum number: ")
            fmt.Scanf("%d", &m)
            fmt.Print("Enter divider: ")
            fmt.Scanf("%d", &d)
            for i := 1; i <= m; i++ {
                    if i%d == 0 {
                            fmt.Println(i)
                    }
            }
    }

Проверка:

    root@vagrant:/home/vagrant/go# nano test.go
    root@vagrant:/home/vagrant/go# go run test.go
    Enter the maximum number: 16
    Enter divider: 2
    2
    4
    6
    8
    10
    12
    14
    16

