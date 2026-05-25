# Инцидент №3: сайт недоступен (ошибка 504)

Цель: отработка диагностики инцидентов, связанных с работой сайта (backend, nginx)
Инструменты: systemctl, tail, curl, ss, time, чтение логов, работа с config-файлом nginx


Воспроизвести инцидент можно выполнив следующие команды:
1. `chmod +x ~/linux-troubleshooting-labs/scripts/lab_3/setup.sh`
2. `~/linux-troubleshooting-labs/scripts/lab_3/setup.sh`

В результате запуска `setup.sh` появится backend сайта.
"Сломать" backend:

3. `chmod +x ~/linux-troubleshooting-labs/scripts/lab_3/incident_3.sh`
4. `~/linux-troubleshooting-labs/scripts/lab_3/incident_3.sh`


В рамках данного инцидента может быть сгенерирован следующие тикеты на основании сработавших алертов в системе мониторинга и созданного тикета от пользователя:
1. [INC-007 504 Gateway Timeout (web-api)](/incidents/tickets/INC-007.md)


После завершения работы с инцидентом, нужно запустить скрипт, который удалит созданные конфиги nginx и остановит backend:
1. `chmod +x ~/linux-troubleshooting-labs/scripts/lab_2/fix_incident_3.sh`
2. `~/linux-troubleshooting-labs/scripts/lab_3/fix_incident_3.sh`


Составлю отчет по ситуации.




# [INC-007 504 Gateway Timeout (web-api)](/incidents/tickets/INC-007.md)

Краткое описание инцидентa (симптомы): Сайт недоступен — ошибка 504


Источник инцидента: система монторинга (Grafana)


Сработавшие алерты:
- Monitoring alert (high 504 rate)


Влияние на сервис:
- Сервис недоступен



Таймлайн инцидента:
- 25.05.2026 12:15:23 - Проблема возникла
- 25.05.2026 12:16:00 - Создан тикет в системе
- 25.05.2026 12:25:00 - Начата диагностика
- 25.05.2026 12:48:00 - Найдена причина
- 25.05.2026 12:53:00 - Инцидент устранен



Диагностика:
1. `curl http://127.0.0.1` - ошибка 504 подтверждена
2. `sudo systemctl status nginx` - nginx активен
3. `sudo tail -f /var/log/nginx/error.log` - `upstream timed out (110: Connection timed out) while reading response header from upstream` => backend отвечает слишком долго
4. `curl http://127.0.0.1:5000` - backend отвечает с задержкой
5. `time curl http://127.0.0.1:5000` - время ответа backend 10 секунд
6. `ss -tulpn | grep 5000` - backend работает (слушает порт `5000`)
7. `tail -f ~/lab3/backend.log` - ошибок нет, только логи со статусом ответа 200
8. Проверка nginx config - установлен timeout в 3 секунды


Первопричина:
- nginx настроен на ожидание ответа в 3 секунды, а backend возвращает ответ в течение 10 секунд - nginx не дожидается ответа.


В реальной работе возможны следующие причины, по которым может возникать ошибка 504:
- Медленный backend (код не оптимизирован)
- CPU перегружен
- Задержка DB (долгие SQL-запросы)
- Задержки в сети


Решение:
- Изменить `proxy_read_timeout 15s` в config file nginx + применить конфигурацию и перезапустить nginx



Как предотвратить инцидент в будущем:
- Оптимизировать backend
- Добавить дополнительные сервера + Load balancing (если проблема будет связана с высокой нагрузкой CPU на сервер и текущее количество серверов не справляется с поступающими запросами)


Итоговый статус: Инцидент решён (Resolved)
