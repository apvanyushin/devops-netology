# Netology Devops. Homework 1.2

Итак, что мы имеем:
##
 1. Команду разработчиков, тестировщика, менеджера и Devops (в виде меня)
 2. Рабочий продукт
 3. Клиентов (заказчиков)

Нужно организовать работу команды по спринтам (например двухнедельный спринт)

Обязанности команды:
##
1. Менеджер берет на себя организационные моменты (встречи, стэндапы, решение проблем), общается с заказчиком, ставит приоритет задачам. Вместе со всей командой оценивает "вес" задачи.
2. Разработчики - пишут код
3. Тестировщик - тестирует то, что ему отдают разработчики
4. Devops - ведет поддержку инфраструктуры(интеграции средств поставления задач, документации, репозитория и т.п.), отвечает за автоматизацию доставки кода и публикации в продакшн. Создает тестовые среды, настраивает мониторинг. (а что еще может делать devops расскажу когда закончу курс)

На примере одной конкретной задачи:
Менеджер получает ТЗ от клиентов, обсуждает возможность реализации с командой разработки, заводит задачу, оценивает задачу совместно со всей командой, ставит приоритет задачи.
Разработчик берет задачу, реализует ее, отправляет код в репозиторий, его коллеги проверяют его работу и если все ок - согласовывают. 
Devops создает тестовую среду с новой фичей.
Тестировщик тестирует фичу, если все ок - переводит задачу в testing done.
Менеджер переводит задачу с ready, разработчики сливают код в мастер. После сливания кода запускаются автоматические тесты (настроенные devops), и автоматическая (или почти) доставка приложения к пользователям.
##
Как-то так, пусть сумбурно, но мысли свои передал. 
