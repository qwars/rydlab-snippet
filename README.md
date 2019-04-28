# rydlab-snippet


## Тестовое задание для rydlab.ru:

Разработать веб приложение для работы со сниппетами (фрагментами) кода, аналогичное https://gist.github.com/. Пользоваться сервисом можно только анонимно без заведения учетных записей.

Сниппеты могут быть публичными, которые видны всем пользователям и скрытыми, которые доступны только по секретной ссылке и в списке сниппетов отсутствуют.

1 сниппет может состоять из нескольких фрагментов кода. Форма отправки сниппетов должна позволять добавлять код 3 способами: вставкой кода в textarea, загрузкой файла и через указание http ссылки на файл, переход по которой должен сделать backend при обработке формы. Форма должна быть динамической, то есть можно создать 1 сниппет, где, например, 2 фрагмента будут добавлены через вставку кода, 4 через загрузку файла и еще 5 через внешние ссылки. После создания сниппета пользователя нужно перенаправить на страницу с этим сниппетом. Редактировать и удалять сниппеты нельзя. У каждого сниппета можно указать язык программирования, если он не указан, то сервис должен попытаться определить его самостоятельно по расширению файла или через shebang. Список поддерживаемых языков можно ограничить, например, 5 популярными языками.

На главной странице сервиса должен отображаться список сниппетов, отсортированных по времени добавления с постраничным выводом. По каждому сниппету видно только время его добавления, сколько в нем файлов и первые 10 строк из первого файла. При переходе на страницу со сниппетом видны уже все полные файлы с подсветкой синтаксиса (для этого нужно использовать готовую библиотеку, например https://highlightjs.org/) Также на главной странице должна отображаться статистика по используемым языкам в сниппетах.

При реализации необходимо использовать любой Perl веб-фреймворк (предпочтительно Mojolicious) и реляционную базу данных PostgreSQL. Интерфейс должен быть аккуратным, с минималистичным дизайном, чтобы продемонстрировать базовые знания CSS. Использовать CSS фреймворки нельзя.

 

Перед тем как сдать задание:

1. Уберите отладочный код и ненужные зависимости (Data::Dumper и т.п.)

2. Убедитесь, что все файлы приложены.

3. Опишите неочевидные моменты, связанные с запуском, чтоб максимально упростить жизнь проверяющему

4. Результат задания должен демонстрировать ваши знания и стиль. Представьте, что пишете производственное приложение. Будут учитываться все аспекты - от читабельности до безопасности.

## Установка и настройка

Для установки понадобиться:

[nodejs](https://nodejs.org/ "nodejs") ```$ sudo apt install nodejs```

Для настройки: ```npm i```

[CPAN](https://www.cpan.org/ "CPAN") ```$ sudo apt install libmojolicious-perl libmojo-pg-perl libjson-validator-perl libmime-types-perl```

CPAN модули

    Mojolicious::Lite
    Mojo::Pg
    Mojo::JSON
    MIME::Types


### Web - сервер 

`develop/application-web` - директория разработки для клиента ( front-end )

`develop/application-web/javascripts` - директория разработки javascript

> при загрузке сервера webpack собирает /javascripts/application.js из index.imba 

`develop/application-web/styleshets` - директория разработки css

> при загрузке сервера webpack собирает /styleshets/styles.css из /javascripts/styleshets.imba 

`develop/application-web/index.html` - основной загрузочный файл, переносится как есть


### Back-end - сервер 

`develop/application-restapi` - директория разработки для клиента ( back-end )

## Запуск

Простого сервера на http://localhost:9090 : ```npm run dev```

Сервера c back-end на http://localhost:3000 : ```npm run dev-server```

> **Note:** Можно по отдельности, перейти в `develop/application-restapi` и запуск back-end ```morbo -m production -w ./index.pl ./index.pl```

Сборка в директорию /public : ```npm run build```

### Video

![Sample Video](https://git.teobit.ru/qwars/rydlab-snippet/raw/master/out.ogv)


