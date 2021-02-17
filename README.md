# tada_team_chat

Тестовое задание для компании tada.team.
Реализовать мобильный клиент для чата на фреймворке Flutter.
Приложение взаимодействует с сервером, исходники которого размещены здесь https://github.com/tada-team/nane
А публикация здесь https://nane.tada.team/

## Подход к реализации

Общие принципы:
1. На сервере N комнат чата
2. Вход просто по имени

Функционал:
1. Сокет wss://nane.tada.team/ws
2. Авторизация wss://nane.tada.team/ws?username={username}
3. При входе в комнату отправляем приветственное сообщение в сокет "text": "Всем чмоки в этом чате!" , что приводит к созданию комнаты
4. Ошибки: room %s not found

Что делаю:
1. Делаю проект на базе MaterialApp на Flutter
2. Использую BLoC в реализации HydratedBLoC, чтобы было кэширование и восстановление состояния
3. Добавлю отдельный экран с логом полученных данных из сокета данных
4. Добавилю вывод в консоль events из всех BLoC, потому что на демо возникла ошибка с неправильным их выводом
5. Добавилю юнит-тесты, чтобы потренироваться и показать, что знаком с этим функционалом
  1. Подключаюсь к сокету с именем - получаю в ответ сообщение "Пришел {Имя}"
  2. Кидаю мусор - получаю Exception
  3. Кидаю в сокет сообщение - получаю его же в ответ
  4. Инициирую 2 сокета: в один кидаю сообщение, в другом его считываю
6. При отправке сообщения оно вначале должно попасть в список для отправки и отобразиться в экране чата, затем улететь на сервер, затем прилететь в обновлении данных от сокета. На этом этапе мы сверяем исходящие и входящие сообщения по ИД и помечаем, что сообщение ушло.

Как тестирую:
1. Запуск на нескольких девайсах
2. Проверяю включение / отключение интернета:
3. Если отправлю сообщение в оффлайне, оно повисает с крутилкой в списке сообщений
4. При появлении интернета:
   1. восстанавливаем работу сокета
   2. загружаем историю сообщений: GET https://nane.tada.team/api/rooms/{name}/history
   3. пересылаем все сообщения в списке ожидания
   4. При получении ответа от сервера удаляем все те сообщения, что мы отправили по id (id = GUID)
5. Проверяем запуск в оффлайн
   1. Должна быть возможность войти в чат (кэш чата)
   2. Должна быть возможность отправить сообщения

## Тестирование проводилось

>[✓] Flutter (Channel stable, 1.22.1, on Mac OS X 10.15.7 19H512, locale en-RU)
>    • Flutter version 1.22.1 at /Users/user/dev/flutter
>    • Framework revision f30b7f4db9 (4 months ago), 2020-10-08 10:06:30 -0700
>    • Engine revision 75bef9f6c8
>    • Dart version 2.10.1

И
>[√] Flutter (Channel stable, 1.22.6, on Microsoft Windows [Version 10.0.19042.746], locale tr-TR)

С большой вероятностью приложение будет работать на более поздних стабильных версиях Flutter.

Для проверки окружения используйте команду flutter doctor -v

Для переключения используйте:

> flutter channel stable
> flutter upgrade

После смены версий рекомендуется обновить зависимости в проекте и удалить устаревшие файлы:

> flutter clean 
> cd ios
> pod deintegrate
> cd ..
> flutter pub get
> cd ios
> pod install
  cd ..
