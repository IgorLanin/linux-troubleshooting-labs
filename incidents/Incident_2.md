# Инцидент №2: сайт недоступен (ошибка 502)

Цель: отработка диагностики инцидентов, связанных с работой сайта (backend, nginx)
Инструменты: systemctl, tail, curl, ss, ps, чтение логов


Воспроизвести инцидент можно выполнив следующие команды:
1. `chmod +x ~/linux-troubleshooting-labs/scripts/lab_2/setup.sh`
2. `~/linux-troubleshooting-labs/scripts/lab_2/setup.sh`

В результате запуска `setup.sh` появится backend сайта.
"Сломать" backend:

3. `chmod +x ~/linux-troubleshooting-labs/scripts/lab_2/incident_2.sh`
4. `~/linux-troubleshooting-labs/scripts/lab_2/incident_2.sh`


В рамках данного инцидента может быть сгенерирован следующие тикеты на основании сработавших алертов в системе мониторинга и созданного тикета от пользователя:
1. [INC-005 - Website unavailable — HTTP 502 Bad Gateway](/incidents/tickets/INC-005.md)
2. [INC-006 - Сайт недоступен — ошибка 502 Bad Gateway](/incidents/tickets/INC-006.md)


После завершения работы с инцидентом, нужно запустить скрипт, который удалит созданные конфиги nginx и остановит backend:
1. `chmod +x ~/linux-troubleshooting-labs/scripts/lab_2/fix_incident_2.sh`
2. `~/linux-troubleshooting-labs/scripts/lab_2/fix_incident_2.sh`


Составлю отчет по ситуации. Буду использовать тикет от пользователя.




# [INC-006 - Сайт недоступен — ошибка 502 Bad Gateway](/incidents/tickets/INC-006.md)

Краткое описание инцидентa (симптомы): Сайт недоступен — ошибка 502 Bad Gateway


Источник инцидента: тикет от пользователя


Влияние на сервис:
- Сайт недоступен


Таймлайн инцидента:
- 21.05.2026 12:04:23 - Проблема возникла
- 21.05.2026 12:15:00 - Создан тикет в системе
- 21.05.2026 12:25:00 - Начата диагностика
- 21.05.2026 12:38:00 - Найдена причина
- 21.05.2026 12:43:00 - Инцидент устранен


Диагностика:
1. `sudo systemctl status nginx` - nginx активен
2. `sudo tail -f /var/log/nginx/access.log` - ошибка 502 подтверждена в логах
3. `sudo tail -f /var/log/nginx/error.log` - `(111: Connection refused)` = backend не слушает порт
4. `curl -v http://127.0.0.1:5000` - неудачаня попытка подключения к `127.0.0.1` и порту `5000`
5. `ss -tulpn | grep ":5000"` - порт не прослушивается
6. `ps aux | grep app.py` - процесса нет. Дополнительная проверка: проверить `backend.pid` и попытаться найти процесс по `PID`.


В реальной работе причины могут быть в другом, поэтому нужно будет дополнительно проверить:
- Логи приложения: `tail -f ~/lab2/backend.log`
- Если backend завис: `pkill -f` + restart
- Проверю правильный ли порт в `app.py`
- Проверю config-файл nginx: `/etc/nginx/sites-available/flaskapp.conf`


Первопричина:
- backend не запущен (был остановлен)


Решение:
- Запустить backend повторно: `nohup python3 ~/linux-troubleshooting-labs/scripts/lab_2/app.py >> ~/lab2/backend.log 2>&1 &`



Как предотвратить инцидент в будущем:
- Создать `.service` и настроить перезапуск в случае падения сервиса (`Restart=on-failure`, `RestartSec=3`)


Итоговый статус: Инцидент решён (Resolved)
