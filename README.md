# Visions Portfolio API

Backend API для управления данными портфолио, включая проекты, CV информацию и навыки.

## 🚀 Быстрый старт

### Предварительные требования

- Node.js 18+
- PostgreSQL 14+
- npm или yarn

### Установка

1. **Клонируйте репозиторий и перейдите в папку сервера:**

   ```bash
   cd visions-server
   npm install
   ```

2. **Настройте переменные окружения:**
   Создайте файл `.env` в корне проекта:

   ```env
   # Database Configuration
   DB_HOST=localhost
   DB_PORT=5432
   DB_USERNAME=postgres
   DB_PASSWORD=postgres
   DB_NAME=visions_db

   # Application Configuration
   NODE_ENV=development
   PORT=3000
   ```

3. **Создайте базу данных PostgreSQL:**

   ```sql
   CREATE DATABASE visions_db;
   ```

4. **Запустите сервер:**

   ```bash
   npm run start:dev
   ```

5. **Инициализируйте данные (опционально):**
   ```bash
   npm run seed
   ```

## 📚 API Documentation

После запуска сервера, Swagger документация доступна по адресу:

- **Swagger UI:** http://localhost:3000/api/docs
- **API Base URL:** http://localhost:3000/api

## 🛠 API Endpoints для проектов

### Базовые CRUD операции

| Method | Endpoint                          | Description                                      |
| ------ | --------------------------------- | ------------------------------------------------ |
| GET    | `/api/projects`                   | Получить все проекты                             |
| GET    | `/api/projects/featured`          | Получить рекомендуемые проекты                   |
| GET    | `/api/projects/by-language/:code` | Получить проекты по языку (совместимо с Angular) |
| GET    | `/api/projects/:id`               | Получить проект по ID                            |
| POST   | `/api/projects`                   | Создать новый проект                             |
| PATCH  | `/api/projects/:id`               | Обновить проект                                  |
| DELETE | `/api/projects/:id`               | Удалить проект                                   |

### Специальные операции

| Method | Endpoint                            | Description                        |
| ------ | ----------------------------------- | ---------------------------------- |
| PATCH  | `/api/projects/:id/toggle-featured` | Переключить статус "рекомендуемый" |
| PATCH  | `/api/projects/reorder/:languageId` | Изменить порядок проектов          |

### Примеры запросов

#### Создать новый проект

```bash
curl -X POST http://localhost:3000/api/projects \
  -H "Content-Type: application/json" \
  -d '{
    "languageId": 1,
    "title": "My New Project",
    "description": "Project description",
    "imageUrl": "./assets/images/project.png",
    "technologies": ["Angular", "TypeScript", "NestJS"],
    "demoLink": "https://demo.example.com",
    "codeLink": "https://github.com/user/repo",
    "featured": true,
    "showDemo": true,
    "showCode": true
  }'
```

#### Получить проекты для Angular сервиса

```bash
curl http://localhost:3000/api/projects/by-language/de
```

Ответ будет в формате, совместимом с существующим Angular ProjectService:

```json
{
  "featuredProjects": [
    {
      "id": 1,
      "title": "visions.shkrsltn",
      "description": "Portfolio description...",
      "imageUrl": "./assets/images/project-images/visions-shkrsltnv.png",
      "technologies": ["Angular", "TypeScript", "OpenAI API"],
      "demoLink": "https://shkrsltn.github.io/visions.shkrsltn/",
      "codeLink": "https://github.com/ShkrSltn/visions.shkrsltn.git",
      "featured": true,
      "showDemo": false,
      "showCode": true
    }
  ]
}
```

## 🗄 Структура базы данных

### Таблицы

#### `languages`

- `id` - Primary key
- `code` - Код языка (en, ru, de, tr, ua)
- `name` - Название языка
- `isActive` - Активен ли язык
- `isDefault` - Язык по умолчанию

#### `projects`

- `id` - Primary key
- `languageId` - Foreign key к таблице languages
- `title` - Название проекта
- `description` - Описание проекта
- `imageUrl` - URL изображения
- `demoLink` - Ссылка на демо
- `codeLink` - Ссылка на код
- `featured` - Рекомендуемый проект
- `showDemo` - Показывать кнопку демо
- `showCode` - Показывать кнопку кода
- `orderIndex` - Порядок сортировки

#### `project_technologies`

- `id` - Primary key
- `projectId` - Foreign key к таблице projects
- `technology` - Название технологии
- `orderIndex` - Порядок сортировки

## 📦 Скрипты

```bash
# Разработка
npm run start:dev      # Запуск с hot reload
npm run start:debug    # Запуск в режиме отладки

# Производство
npm run build          # Сборка проекта
npm run start:prod     # Запуск production сервера

# База данных
npm run seed           # Инициализация данных

# Тестирование
npm run test           # Запуск тестов
npm run test:watch     # Тесты с наблюдением
npm run test:e2e       # End-to-end тесты

# Форматирование
npm run format         # Форматирование кода
npm run lint           # Проверка линтером
```

## 🔧 Переменные окружения

| Variable      | Description       | Default     |
| ------------- | ----------------- | ----------- |
| `DB_HOST`     | PostgreSQL host   | localhost   |
| `DB_PORT`     | PostgreSQL port   | 5432        |
| `DB_USERNAME` | Database username | postgres    |
| `DB_PASSWORD` | Database password | postgres    |
| `DB_NAME`     | Database name     | visions_db  |
| `NODE_ENV`    | Environment mode  | development |
| `PORT`        | Server port       | 3000        |

## 🔗 Интеграция с Angular

API полностью совместимо с существующим Angular ProjectService. Для перехода:

1. Обновите URL в `ProjectService`:

   ```typescript
   private apiUrl = 'http://localhost:3000/api/projects/by-language';
   ```

2. API вернет данные в том же формате, что и JSON файлы

## 🚦 Статусы разработки

- ✅ **Базовые CRUD операции**
- ✅ **Swagger документация**
- ✅ **Валидация данных**
- ✅ **Многоязычность**
- ✅ **Управление порядком**
- ✅ **Совместимость с Angular**
- 🔄 **Аутентификация** (в планах)
- 🔄 **Загрузка файлов** (в планах)
- 🔄 **Admin панель** (в планах)

## 📝 Следующие шаги

1. Добавить аутентификацию и авторизацию
2. Создать API для CV данных
3. Создать API для навыков
4. Добавить загрузку изображений
5. Создать Vue.js админ панель
