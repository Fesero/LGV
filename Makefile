# Makefile

# Переменные
COMPOSE = docker-compose
COMPOSE_FILE = docker-compose.yml
EXEC_PHP = $(COMPOSE) exec --user 1000:1000 laravel
EXEC_GO = $(COMPOSE) exec --user 1000:1000 gameserver
EXEC_NODE = $(COMPOSE) exec --user 1000:1000 frontend
EXEC_DB = $(COMPOSE) exec --user 1000:1000 postgres
EXEC_REDIS = $(COMPOSE) exec --user 1000:1000 redis

# Цвета для вывода
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Помощь по умолчанию
.DEFAULT_GOAL := help

# ==========================================
# ПОМОЩЬ
# ==========================================

.PHONY: help
help: ## Показать эту справку
	@echo ""
	@echo "$(GREEN)Cultivation Game — Команды$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

# ==========================================
# DOCKER — ОСНОВНЫЕ
# ==========================================

.PHONY: up
up: ## Запустить все сервисы
	$(COMPOSE) up -d
	@echo "$(GREEN)✓ Все сервисы запущены$(NC)"
	@make status

.PHONY: down
down: ## Остановить все сервисы
	$(COMPOSE) down
	@echo "$(GREEN)✓ Все сервисы остановлены$(NC)"

.PHONY: restart
restart: ## Перезапустить все сервисы
	$(COMPOSE) restart
	@echo "$(GREEN)✓ Все сервисы перезапущены$(NC)"

.PHONY: build
build: ## Пересобрать все образы
	$(COMPOSE) build
	@echo "$(GREEN)✓ Образы собраны$(NC)"

.PHONY: rebuild
rebuild: ## Пересобрать без кэша и запустить
	$(COMPOSE) build --no-cache
	$(COMPOSE) up -d
	@echo "$(GREEN)✓ Образы пересобраны и запущены$(NC)"

.PHONY: status
status: ## Статус всех контейнеров
	@echo ""
	@echo "$(GREEN)Статус контейнеров:$(NC)"
	@$(COMPOSE) ps
	@echo ""

.PHONY: logs
logs: ## Логи всех сервисов (follow)
	$(COMPOSE) logs -f

.PHONY: logs-api
logs-api: ## Логи Laravel API
	$(COMPOSE) logs -f laravel

.PHONY: logs-game
logs-game: ## Логи Go Game Server
	$(COMPOSE) logs -f gameserver

.PHONY: logs-web
logs-web: ## Логи Vue Frontend
	$(COMPOSE) logs -f frontend

.PHONY: logs-db
logs-db: ## Логи PostgreSQL
	$(COMPOSE) logs -f postgres

# ==========================================
# DOCKER — ДОПОЛНИТЕЛЬНЫЕ
# ==========================================

.PHONY: stop
stop: ## Остановить без удаления контейнеров
	$(COMPOSE) stop

.PHONY: start
start: ## Запустить остановленные контейнеры
	$(COMPOSE) start

.PHONY: pull
pull: ## Скачать последние образы
	$(COMPOSE) pull

.PHONY: clean
clean: ## Остановить и удалить volumes (ОСТОРОЖНО!)
	@echo "$(RED)ВНИМАНИЕ: Будут удалены все данные!$(NC)"
	@read -p "Продолжить? [y/N] " confirm && [ "$$confirm" = "y" ] || exit 1
	$(COMPOSE) down -v --remove-orphans
	@echo "$(GREEN)✓ Очищено$(NC)"

.PHONY: prune
prune: ## Очистить неиспользуемые Docker ресурсы
	docker system prune -f
	docker volume prune -f
	@echo "$(GREEN)✓ Docker очищен$(NC)"

# ==========================================
# SHELL — ДОСТУП В КОНТЕЙНЕРЫ
# ==========================================

.PHONY: sh-api
sh-api: ## Shell в Laravel контейнер
	$(EXEC_PHP) sh

.PHONY: sh-game
sh-game: ## Shell в Go контейнер
	$(EXEC_GO) sh

.PHONY: sh-web
sh-web: ## Shell в Vue контейнер
	$(EXEC_NODE) sh

.PHONY: sh-db
sh-db: ## Shell в PostgreSQL контейнер
	$(EXEC_DB) sh

.PHONY: psql
psql: ## Подключиться к PostgreSQL
	$(EXEC_DB) psql -U $${POSTGRES_USER:-cultivator} -d $${POSTGRES_DB:-cultivation_game}

.PHONY: redis-cli
redis-cli: ## Подключиться к Redis
	$(EXEC_REDIS) redis-cli -a $${REDIS_PASSWORD}

# ==========================================
# LARAVEL — КОМАНДЫ
# ==========================================

.PHONY: artisan
artisan: ## Laravel artisan (использование: make artisan cmd="migrate")
	$(EXEC_PHP) php artisan $(cmd)

.PHONY: migrate
migrate: ## Запустить миграции
	$(EXEC_PHP) php artisan migrate
	@echo "$(GREEN)✓ Миграции выполнены$(NC)"

.PHONY: migrate-fresh
migrate-fresh: ## Пересоздать БД и запустить миграции
	$(EXEC_PHP) php artisan migrate:fresh --seed
	@echo "$(GREEN)✓ БД пересоздана$(NC)"

.PHONY: migrate-rollback
migrate-rollback: ## Откатить последнюю миграцию
	$(EXEC_PHP) php artisan migrate:rollback

.PHONY: seed
seed: ## Запустить сидеры
	$(EXEC_PHP) php artisan db:seed

.PHONY: tinker
tinker: ## Laravel Tinker (REPL)
	$(EXEC_PHP) php artisan tinker

.PHONY: cache-clear
cache-clear: ## Очистить все кэши Laravel
	$(EXEC_PHP) php artisan cache:clear
	$(EXEC_PHP) php artisan config:clear
	$(EXEC_PHP) php artisan route:clear
	$(EXEC_PHP) php artisan view:clear
	@echo "$(GREEN)✓ Кэши очищены$(NC)"

.PHONY: composer
composer: ## Composer команда (использование: make composer cmd="require package")
	$(EXEC_PHP) composer $(cmd)

.PHONY: composer-install
composer-install: ## Composer install
	$(EXEC_PHP) composer install

.PHONY: composer-update
composer-update: ## Composer update
	$(EXEC_PHP) composer update

# ==========================================
# GO — КОМАНДЫ
# ==========================================

.PHONY: go-build
go-build: ## Собрать Go приложение
	$(EXEC_GO) go build -o /app/bin/gameserver ./cmd/server

.PHONY: go-test
go-test: ## Запустить Go тесты
	$(EXEC_GO) go test -v ./...

.PHONY: go-fmt
go-fmt: ## Форматировать Go код
	$(EXEC_GO) go fmt ./...

.PHONY: go-lint
go-lint: ## Линтер Go
	$(EXEC_GO) golangci-lint run

# ==========================================
# VUE/FRONTEND — КОМАНДЫ
# ==========================================

.PHONY: npm
npm: ## NPM команда (использование: make npm cmd="install package")
	$(EXEC_NODE) npm $(cmd)

.PHONY: npm-install
npm-install: ## NPM install
	$(EXEC_NODE) npm install

.PHONY: npm-build
npm-build: ## Собрать frontend для production
	$(EXEC_NODE) npm run build

.PHONY: npm-dev
npm-dev: ## Запустить dev сервер
	$(EXEC_NODE) npm run dev

# ==========================================
# ТЕСТИРОВАНИЕ
# ==========================================

.PHONY: test
test: ## Запустить все тесты
	@echo "$(YELLOW)Запуск тестов Laravel...$(NC)"
	$(EXEC_PHP) php artisan test
	@echo "$(YELLOW)Запуск тестов Go...$(NC)"
	$(EXEC_GO) go test ./...
	@echo "$(GREEN)✓ Все тесты пройдены$(NC)"

.PHONY: test-api
test-api: ## Тесты Laravel
	$(EXEC_PHP) php artisan test

.PHONY: test-game
test-game: ## Тесты Go
	$(EXEC_GO) go test -v ./...

.PHONY: test-web
test-web: ## Тесты Vue
	$(EXEC_NODE) npm run test

# ==========================================
# ЛИНТЕРЫ И КАЧЕСТВО КОДА
# ==========================================

.PHONY: lint
lint: ## Запустить все линтеры
	@echo "$(YELLOW)PHP...$(NC)"
	$(EXEC_PHP) ./vendor/bin/pint
	@echo "$(YELLOW)PHPStan...$(NC)"
	$(EXEC_PHP) ./vendor/bin/phpstan analyse --memory-limit=1G
	@echo "$(YELLOW)Go...$(NC)"
	$(EXEC_GO) golangci-lint run
	@echo "$(YELLOW)Vue/TS...$(NC)"
	$(EXEC_NODE) npm run lint
	@echo "$(GREEN)✓ Линтинг пройден$(NC)"

.PHONY: lint-fix
lint-fix: ## Автоисправление линтеров
	$(EXEC_PHP) ./vendor/bin/pint
	$(EXEC_GO) go fmt ./...
	$(EXEC_NODE) npm run lint:fix
	@echo "$(GREEN)✓ Код отформатирован$(NC)"

# ==========================================
# ИНИЦИАЛИЗАЦИЯ ПРОЕКТА
# ==========================================

.PHONY: init
init: ## Полная инициализация проекта с нуля
	@echo "$(YELLOW)Создание .env файла...$(NC)"
	@test -f .env || cp .env.example .env
	@echo "$(YELLOW)Сборка образов...$(NC)"
	$(COMPOSE) build
	@echo "$(YELLOW)Запуск сервисов...$(NC)"
	$(COMPOSE) up -d
	@echo "$(YELLOW)Ожидание готовности БД...$(NC)"
	@sleep 10
	@echo "$(YELLOW)Установка зависимостей Laravel...$(NC)"
	$(EXEC_PHP) composer install
	@echo "$(YELLOW)Генерация ключа приложения...$(NC)"
	$(EXEC_PHP) php artisan key:generate
	@echo "$(YELLOW)Запуск миграций...$(NC)"
	$(EXEC_PHP) php artisan migrate --seed
	@echo "$(YELLOW)Установка зависимостей Vue...$(NC)"
	$(EXEC_NODE) npm install
	@echo ""
	@echo "$(GREEN)╔════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║  ✓ Проект успешно инициализирован!    ║$(NC)"
	@echo "$(GREEN)╠════════════════════════════════════════╣$(NC)"
	@echo "$(GREEN)║  Laravel API:  http://localhost:8000   ║$(NC)"
	@echo "$(GREEN)║  Vue Frontend: http://localhost:3000   ║$(NC)"
	@echo "$(GREEN)║  WebSocket:    ws://localhost:8080     ║$(NC)"
	@echo "$(GREEN)║  Adminer:      http://localhost:8081   ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════╝$(NC)"
	@echo ""

# ==========================================
# TOOLS — ДОПОЛНИТЕЛЬНЫЕ ИНСТРУМЕНТЫ
# ==========================================

.PHONY: tools-up
tools-up: ## Запустить dev-инструменты (Adminer, Redis Commander)
	$(COMPOSE) --profile tools up -d adminer redis-commander
	@echo "$(GREEN)Adminer: http://localhost:8081$(NC)"
	@echo "$(GREEN)Redis Commander: http://localhost:8082$(NC)"

.PHONY: tools-down
tools-down: ## Остановить dev-инструменты
	$(COMPOSE) --profile tools down

# ==========================================
# БАЗА ДАННЫХ
# ==========================================

.PHONY: db-dump
db-dump: ## Дамп базы данных
	@mkdir -p backups
	$(EXEC_DB) pg_dump -U $${POSTGRES_USER:-cultivator} $${POSTGRES_DB:-cultivation_game} > backups/dump_$$(date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✓ Дамп создан в backups/$(NC)"

.PHONY: db-restore
db-restore: ## Восстановить БД из дампа (использование: make db-restore file=dump.sql)
	@test -f $(file) || (echo "$(RED)Файл не найден: $(file)$(NC)" && exit 1)
	$(EXEC_DB) psql -U $${POSTGRES_USER:-cultivator} -d $${POSTGRES_DB:-cultivation_game} < $(file)
	@echo "$(GREEN)✓ БД восстановлена$(NC)"

# ==========================================
# PRODUCTION
# ==========================================

.PHONY: prod-build
prod-build: ## Собрать production образы
	$(COMPOSE) -f docker-compose.yml -f docker-compose.prod.yml build

.PHONY: prod-up
prod-up: ## Запустить в production режиме
	$(COMPOSE) -f docker-compose.yml -f docker-compose.prod.yml up -d