CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- Генерация UUID
CREATE EXTENSION IF NOT EXISTS "pgcrypto";       -- Криптографические функции
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- Поиск по триграммам (fuzzy search)

SET timezone = 'UTC';

CREATE SCHEMA IF NOT EXISTS game;        -- Игровые данные
CREATE SCHEMA IF NOT EXISTS auth;        -- Авторизация
CREATE SCHEMA IF NOT EXISTS logs;        -- Логи и аналитика

COMMENT ON SCHEMA game IS 'Игровые сущности: персонажи, предметы, бои';
COMMENT ON SCHEMA auth IS 'Авторизация: пользователи, токены, сессии';
COMMENT ON SCHEMA logs IS 'Логирование: действия игроков, события';

GRANT ALL ON SCHEMA game TO cultivator;
GRANT ALL ON SCHEMA auth TO cultivator;
GRANT ALL ON SCHEMA logs TO cultivator;

ALTER DEFAULT PRIVILEGES IN SCHEMA game 
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO cultivator;
ALTER DEFAULT PRIVILEGES IN SCHEMA auth 
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO cultivator;
ALTER DEFAULT PRIVILEGES IN SCHEMA logs 
    GRANT SELECT, INSERT ON TABLES TO cultivator;

DO $$
BEGIN
    RAISE NOTICE 'Database initialization completed!';
    RAISE NOTICE 'Extensions: uuid-ossp, pgcrypto, pg_trgm';
    RAISE NOTICE 'Schemas: game, auth, logs';
END $$;