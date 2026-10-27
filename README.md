1) Запустить приложение https://github.com/anestesia001/carss/tree/main как systemd демон
 ```
[Unit]
Description= cars_py
After=network-online.target

[Service]
User=matvey
Group=matvey
WorkingDirectory=/home/matvey/lesson_17/carss
ExecStart=/home/matvey/lesson_17/carss/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000 --reload
Environment=DATABASE_URL=postgresql://postgres:secret@127.0.0.1:5432/autos
"Restart=always

[Install]
WantedBy=multi-user.target
```
![](https://github.com/matveyframe/Lesson_17/blob/main/cars_service%20status.png "Logo Title Text 1")
![](https://github.com/matveyframe/Lesson_17/blob/main/Psql%20status%20.png "Logo Title Text 1")

2)Настроить nginx как reverse proxy для этого приложения
 ```
server {
    listen 80;
    server_name 127.0.0.1;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
![](https://github.com/matveyframe/Lesson_17/blob/main/proxy_pass%20status.png "Logo Title Text 1")

3)Написать скрипт для бэкапов БД приложения

```
#!/bin/bash

DB_NAME="cars_db"
DB_USER="postgres"
BACKUP_DIR="/var/backups/carss"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/carss_backup_$DATE.sql.gz"

mkdir -p "$BACKUP_DIR"

pg_dump -U "$DB_USER" -h localhost "$DB_NAME" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup created at $BACKUP_FILE"
else
    echo "Backup failed!" >&2
    exit 1
fi

```
![](https://github.com/matveyframe/Lesson_17/blob/main/backups_result.png "Logo Title Text 1")

