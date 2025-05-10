# Pomodoro Platform

Pomodoro Platform — это инструмент для управления временем на основе популярной техники Помодоро. С её помощью вы можете:

- **Добавлять задачи и привычки**, чтобы структурировать свою работу и повседневные действия.
- **Запускать таймер**, который помогает сосредоточиться на одной задаче в течение заданного времени.
- **Останавливать интервал досрочно**, если срочно нужно переключиться на другое дело.
- **Просматривать статистику** своей продуктивности: сколько задач выполнено, сколько времени потрачено...

К каждой задаче и привычке можно добавлять **теги** для лучшей организации.
Всё это помогает оставаться организованным, мотивированным и эффективным! 🕒✅

---
## 1. Структура приложения
### 🛡️ Auth Service

Центральный сервис для работы с пользовательскими аккаунтами и авторизацией. Используется всеми другими микросервисами для проверки подлинности пользователей.

---
### 🧠Task & Habit Service

Сервис управления задачами и привычками. Реализует логику Pomodoro-таймера, позволяет создавать, редактировать, удалять задачи и привычки, добавлять/удалять теги к ним.

---
### 📊 Statistics Service

Обеспечивает аналитическую основу для отображения прогресса и эффективности пользователя.

---
## 2. Архитектура и технологии

### 🛠️ Используемые технологии

- **PHP / Laravel** — основной фреймворк для всех микросервисов.
- **PostgreSQL** — база данных, используемая каждым сервисом для хранения данных.
- **Apache Kafka (через Kraft)** — для асинхронного обмена сообщениями между микросервисами.
- **Docker / Docker Compose** — контейнеризация сервисов.
- **Pest** — для тестирования.
- **PHPStan** — статический анализ кода для повышения качества и предсказуемости.

### 🔄 Взаимодействие между микросервисами

Сервисы обмениваются данными через **Apache Kafka**. 
#### Примеры событий:

- `user.created` — публикуется в Auth Service, подписан Task & Habit Service для создания приветственных задач.
- `task.completed`, `interval.stopped` — отправляются из Task & Habit Service и используются Statistics Service для обновления пользовательской статистики.
### 🌐Внешние сервисы:

- PostgreSQL (хранение данных в каждом микросервисе).
- Laravel Jobs и Events (асинхронная обработка задач).
- Shedule (Cron) — используется в Task & Habit Service для регулярной очистки временных данных.

---
## 3. Способы запуска сервиса

### 🐳 Локальный запуск через Docker 

Для удобного запуска всех микросервисов в локальном окружении используется `docker-compose`.  
Все сервисы запускаются в отдельных контейнерах и взаимодействуют друг с другом через внутреннюю сеть.

---
#### 🔧 Шаги для запуска:

1. Клонируйте репозитории с сервисами:
```bash
git clone https://github.com/kr1ta/auth_service_laravel.git auth_service_laravel
git clone https://github.com/kr1ta/task_service_laravel.git task_service_laravel
git clone https://github.com/kr1ta/stat_service_laravel.git stat_service_laravel
```

2. Клонируйте файл `docker-compose.yml` в ту же папку
3. Запустите:
```bash
docker-compose up --build
```    

---
### 🌐 Доступ к сервисам после запуска

|Сервис|URL|
|---|---|
|Auth Service|[http://localhost:8001](http://localhost:8001/)|
|Task & Habit Service|[http://localhost:8002](http://localhost:8002/)|
|Stat Service|[http://localhost:8003](http://localhost:8003/)|

---
### ⚙️ Переменные окружения

Каждый сервис использует свой `.env` файл, который находится в соответствующей папке (`auth_service/.env`, `task_service/.env`, `stat_service/.env`).  

В каждом репозитории настроен `.env.example`, который с помощью `Dockerfile` копируется в `.env` внутри контейнеров.

---
## 4. API документация

Публичная коллекция Postman:  
🔗 [Postman Collection](https://www.postman.com/cool-guys-team/workspace/task-habit-service/collection/42546659-a3a53caf-fa2d-4dda-bf9f-541f34ca5fff?action=share&creator=42546659)

---
### Основные эндпоинты:

#### 🛡️Auth Service:
- `POST /register` — регистрация
- `POST /login` — вход
- `POST /logout` — выход
- `GET /user` — текущий пользователь
- `GET /validate-token` — проверка токена (используется в других микросервисах)

#### 🧠Task & Habit Service:
- `GET /tasks`, `POST /tasks`, `PATCH /tasks/{id}`, `DELETE /tasks/{id}`
- `GET /habits`, `POST /habits`, `PATCH /habits/{id}`, `DELETE /habits/{id}`
- `POST /tags` — создание тега
- `POST /{tasks|habits}/{id}/attach-tag/{tag_id}` — добавление тега
- `POST /{tasks|habits}/{id}/detach-tag/{tag_id}` — удаление тега
- `POST /start-interval`, `POST /stop-interval` — управление Pomodoro-таймером

#### 📊 Statistics Service:
- `GET /user-statistics/{userId}` — общая статистика пользователя
- `GET /daily-statistics/{userId}/{date}` — ежедневная статистика
---
## 5. Запуск тестов

1. Убедитесь, что контейнеры собраны.

2. Запустите тесты в нужном сервисе:
	- Authentication Service
	    `docker-compose exec auth_service ./vendor/bin/pest`
	- Task & Habit Service:
	    `docker-compose exec task_service ./vendor/bin/pest`
	- Statistic Service:
		`docker-compose exec stat_service ./vendor/bin/pest`
## 6. Контакты и поддержка

Авторы: [kr1ta](https://github.com/kr1ta), [savaIesus](https://github.com/savaIesus), [StarAres1](https://github.com/StarAres1)
GitHub Issues: [pomodoro-platform/issues](https://github.com/kr1ta/pomodoro-platform/issues)  
Telegram: [@justkr1ta](https://t.me/justkr1ta)
