# eventlog-to-syslog
Журнал событий в службу системного журнала для Windows (2k, XP, 2k3, 2k8+)

Журнал событий в службу системного журнала для Windows
Эта программа написана на C и предоставляет метод отправки событий журнала событий Windows на сервер системного журнала. Он работает с новой службой Windows Events в Vista и Server 2008 и может быть скомпилирован как для 32-, так и для 64-разрядных сред. Разработанный для работы с очень загруженными серверами, он быстрый, легкий и эффективный. Программа предназначена для работы в качестве службы Windows.

Это адаптация службы журнала событий Кертиса Смита к службе системного журнала, которую можно найти по адресу https://engineering.purdue.edu/ECN/Resources/Documents/UNIX/evtsys/ .

Он содержит следующие улучшения утилиты Смита:
ПРИМЕЧАНИЕ. Пользователи до версии 4.5. Обновление 4.5 изменяет способ настройки хостов журналов. Пожалуйста, убедитесь, что ваши разделы реестра объединены в один раздел реестра с несколькими хостами, разделенными точкой с запятой при обновлении, или просто переустановите, используя новый формат, чтобы указать хосты вашего журнала. Полную информацию см. в файле readme.

Обновление: * Добавлен новый файл загрузки по запросу пользователя. Он доступен в разделе загрузок, а также в папках исполняемых файлов тега 4.4.3. Он точно такой же, как исходный код 4.4.3, созданный с максимальным размером сообщения 4096.

Изменения в версии 4.5.1: * Исправлена ​​ошибка, из-за которой аргумент хостов командной строки (-h) не сохранялся в реестре. * Исправлена ​​проблема, из-за которой пользователь не мог использовать максимум 6 хостов журнала.

v4.5: * Добавлен параметр Tag (-t), позволяющий указать пользовательский параметр для поля программы. * Добавлен параметр (-a), позволяющий использовать полное доменное имя хоста или IP-адрес * Флаг IncludeOnly больше не используется в Vista/Server 2k8 * Разрешить использование XPath для указания событий для пересылки в Vista/2008+ * Удаление дополнительных DLL, теперь развертывание с одним файлом * Удаление дополнительных ключей хоста журнала вместо использования одного ключа

v4.4.3: * Улучшена производительность в Server 2008 за счет реализации подписки на события. Спасибо Мартину за то, что указал мне правильное направление.

v4.4.2: * Добавлена ​​поддержка пользовательских тегов с сервера. Используйте флаг -t при установке (спасибо wired) * Добавлена ​​поддержка до четырех хостов журналов одновременно * Исправлена ​​ошибка, приводившая к чрезмерным ошибкам, когда событие не может быть получено на сервере 2008 * Исправлена ​​проблема, не позволявшая регистрировать уровень 4 быть действительным * Начата поддержка настраиваемого максимального размера журнала. Еще не завершено * Реализована слегка протестированная поддержка TCP. Проверка ошибок и отказоустойчивость еще не закончены. Документация будет предоставлена ​​тем, кто хочет помочь протестировать ее.

# Установка
Скачиваем последнюю версию Evtsys для своей системы (X86 или X64)
Распаковываем архив
Перемещаем файлы в C:\Windows\System32
Запустить командную строку от имени администратора и перейти в директорию C:\Windows\System32 и выполнить для начала сбора и пересылки журналов

evtsys.exe -i -h ip сервера
После чего запустит службу

net start evtsys
Для проверки работы необходимо зайти в службы и руками проверить запустилась ли служба установить режим запуска автоматически

Для проверки отправки, возможно создать тестовое сообщение


eventcreate /L Application /so TestMessage /t error /id 1 /d "Test"
Параметры командной строки

-i Установить сервис
-u Удалить сервис
-d Дебаг. Запуститься как консольная программа
-h host Имя хоста куда отправлять логи
-b host Имя второго хоста кому дублировать логи
-f facility Facility логов
-l level Минимальный уровень отсылаемых сообщений 0=Всё, 1=Критические, 2=Ошибки, 3=Предупреждение, 4=Информация
-n Отправлять только эвенты включенные в конфиге
-p port Номер порта syslog
-q bool Опросить DHCP чтобы получить имя хоста syslog и порт (0/1 = включить/выключить)
-s minutes Интервал между сообщениями. 0 = Отключить
Настройка Evtsys
После установки в директории system32 появится конфиг evtsys.cfg


'!!!!THIS FILE IS REQUIRED FOR THE SERVICE TO FUNCTION!!!!
'
'Comments must start with an apostrophe and
'must be the only thing on that line.
'
'Do not combine comments and definitions on the same line!
'
'Format is as follows - EventSource:EventID
'Use * as a wildcard to ignore all ID's from a given source
'E.g. Security-Auditing:*
'
'In Vista/2k8 and upwards remove the 'Microsoft-Windows-' prefix
'In Vista/2k8+ you may also specify custom XPath queries
'Format is the word 'XPath' followed by a ':', the event log to search,
'followed by a ':', and then the select expression
'E.g XPath:Application:<expression>
'
'Details can be found in the readme file at the following location:
'https://code.google.com/p/eventlog-to-syslog/downloads/list
'**********************:**************************
XPath:Application:<Select Path="Application">*</Select>
XPath:Security:<Select Path="Security">*</Select>
XPath:Setup:<Select Path="Setup">*</Select>
XPath:System:<Select Path="System">*</Select>
XPath:Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational:<Select Path="Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational">*</Select>
XPath:Windows PowerShell:<Select Path="Windows PowerShell">*</Select>
XPath:Microsoft-Windows-Windows Defender/Operational:<Select Path="Microsoft-Windows-Windows Defender/Operational">*</Select>
XPath:System:<Kaspersky Event Log="Kaspersky Event Log">*</Select>
В файл конфигурации можно добавить сбор логов из любых журналов windows

Синтаксис выглядит следующим образом

Для добавления переслки логов PowerShell


XPath:Windows PowerShell:<Select Path="Windows PowerShell">*</Select>
Для добавления переслки логов Kaspersky Event Log


XPath:System:<Kaspersky Event Log="Kaspersky Event Log">*</Select>
Таким образом можем добавить пересылку любых журналов.
