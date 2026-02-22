-- 
CREATE TABLE IF NOT EXISTS client(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL CHECK (
        last_name ~ '^[А-ЯЁ][а-яё]+(-[А-ЯЁ][а-яё]+)?$'
    ),
    first_name VARCHAR(100) NOT NULL CHECK (
        first_name ~ '^[А-ЯЁ][а-яё]+(-[А-ЯЁ][а-яё]+)?$'
    ),
    patronymic VARCHAR(100) CHECK (
        patronymic ~ '^[А-ЯЁ][а-яё]+$'
    ),
    birth_date DATE NOT NULL CHECK (
        birth_date <= CURRENT_DATE - INTERVAL '18 years' AND birth_date >= CURRENT_DATE - INTERVAL '120 years'
    ),
    passport_series VARCHAR(4) NOT NULL CHECK (
        passport_series ~ '^\d{4}$'
    ),
    passport_number VARCHAR(6) NOT NULL CHECK (
        passport_number ~ '^\d{6}$'
    ),
    phone VARCHAR(18) UNIQUE NOT NULL CHECK (
        phone ~ '^\+7 \(\d{3}\) \d{3}-\d{2}-\d{2}$'
    ),
    email VARCHAR(100) UNIQUE NOT NULL CHECK (
        email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ),
    CONSTRAINT unique_passport UNIQUE (passport_series, passport_number)
);

COMMENT ON TABLE client IS 'Таблица для хранения информации о клиентах';
COMMENT ON COLUMN client.id IS 'Идентификатор';
COMMENT ON COLUMN client.last_name IS 'Фамилия';
COMMENT ON COLUMN client.first_name IS 'Имя';
COMMENT ON COLUMN client.patronymic IS 'Отчество';
COMMENT ON COLUMN client.birth_date IS 'Дата рождения';
COMMENT ON COLUMN client.passport_series IS 'Серия паспорта';
COMMENT ON COLUMN client.passport_number IS 'Номер паспорта';
COMMENT ON COLUMN client.phone IS 'Номер телефона в формате +7 (XXX) XXX-XX-XX';
COMMENT ON COLUMN client.email IS 'Электронная почта';
COMMENT ON CONSTRAINT unique_passport ON client IS 'Уникальность комбинации серии и номера паспорта';

CREATE TABLE IF NOT EXISTS product_type(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL CHECK (
        name ~ '^[А-ЯЁ][а-яё]+([ -][а-яё]+)*$'
    )
);

COMMENT ON TABLE product_type IS 'Таблица для хранения информации о типах банковских продуктов';
COMMENT ON COLUMN product_type.id IS 'Идентификатор';
COMMENT ON COLUMN product_type.name IS 'Название';

CREATE TABLE IF NOT EXISTS currency(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(4) UNIQUE NOT NULL CHECK (
        name ~ '^[A-Z]{2,4}$'
    ),
    rate_to_rub DECIMAL(5, 2) NOT NULL CHECK (
        rate_to_rub > 0
    )
);

COMMENT ON TABLE currency IS 'Таблица для хранения информации о валютах, которых могут использоваться в банковских продуктах';
COMMENT ON COLUMN currency.id IS 'Идентификатор';
COMMENT ON COLUMN currency.name IS 'Название';
COMMENT ON COLUMN currency.rate_to_rub IS 'Курс единицы валюты к рублю';

CREATE TABLE IF NOT EXISTS status(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL CHECK (
        name ~ '^[A-Z]+$'
    )
);

COMMENT ON TABLE status IS 'Таблица для хранения статусов банковских продуктов';
COMMENT ON COLUMN status.id IS 'Идентификатор';
COMMENT ON COLUMN status.name IS 'Название';

CREATE TABLE IF NOT EXISTS product(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    opened_at DATE NOT NULL DEFAULT CURRENT_DATE CHECK (
        opened_at <= CURRENT_DATE AND opened_at >= CURRENT_DATE - INTERVAL '50 years'
    ),
    product_type_id BIGINT NOT NULL REFERENCES product_type(id),
    currency_id BIGINT NOT NULL REFERENCES currency(id),
    interest_rate DECIMAL(4, 2) NOT NULL CHECK (
        interest_rate >= 0 AND interest_rate <= 30.00
    ),
    status_id BIGINT NOT NULL REFERENCES status(id),
    client_id BIGINT NOT NULL REFERENCES client(id)
);

CREATE INDEX idx_product_product_type_id ON product(product_type_id);
CREATE INDEX idx_product_currency_id ON product(currency_id);
CREATE INDEX idx_product_status_id ON product(status_id);
CREATE INDEX idx_product_client_id ON product(client_id);

COMMENT ON TABLE product IS 'Таблица для хранения информации о банковских продуктах, которые есть у клиентов';
COMMENT ON COLUMN product.id IS 'Идентификатор';
COMMENT ON COLUMN product.opened_at IS 'Дата открытия';
COMMENT ON COLUMN product.product_type_id IS 'Идентификатор типа банковского продукта';
COMMENT ON COLUMN product.currency_id IS 'Идентификатор валюты, которая используется в банковском продукте';
COMMENT ON COLUMN product.interest_rate IS 'Процентная ставка';
COMMENT ON COLUMN product.status_id IS 'Идентификатор статуса банковского продукта';
COMMENT ON COLUMN product.client_id IS 'Идентификатор клиента, которому принадлежит банковский продукт';
COMMENT ON INDEX idx_product_product_type_id IS 'Индекс для ускорения поиска по идентификатору типа банковского продукта';
COMMENT ON INDEX idx_product_currency_id IS 'Индекс для ускорения поиска по идентификатору валюты';
COMMENT ON INDEX idx_product_status_id IS 'Индекс для ускорения поиска по идентификатору статуса';
COMMENT ON INDEX idx_product_client_id IS 'Индекс для ускорения поиска по идентификатору клиента';

CREATE TABLE IF NOT EXISTS operation_type(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) UNIQUE NOT NULL CHECK (
        name ~ '^[А-ЯЁ][а-яё]+([ -][а-яё]+)*$'
    )
);

COMMENT ON TABLE operation_type IS 'Таблица для хранения типов операций с банковскими продуктами';
COMMENT ON COLUMN operation_type.id IS 'Идентификатор';
COMMENT ON COLUMN operation_type.name IS 'Название';

CREATE TABLE IF NOT EXISTS operation(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP CHECK (
        created_at <= CURRENT_TIMESTAMP AND created_at >= CURRENT_TIMESTAMP - INTERVAL '50 years'
    ),
    amount DECIMAL(12, 2) NOT NULL CHECK (
        amount >= 0
    ),
    operation_type_id BIGINT NOT NULL REFERENCES operation_type(id),
    product_id BIGINT NOT NULL REFERENCES product(id),
    balance_after_operation DECIMAL(12, 2) NOT NULL CHECK (
        balance_after_operation >= 0
    ),
    CONSTRAINT unique_product_id_operation_type_id_created_at UNIQUE (product_id, operation_type_id, created_at)
);

CREATE INDEX idx_operation_operation_type_id ON operation(operation_type_id);
CREATE INDEX idx_operation_product_id ON operation(product_id);

COMMENT ON TABLE operation IS 'Таблица для хранения операций с банковскими продуктами';
COMMENT ON COLUMN operation.id IS 'Идентификатор';
COMMENT ON COLUMN operation.created_at IS 'Дата создания операции';
COMMENT ON COLUMN operation.amount IS 'Сумма';
COMMENT ON COLUMN operation.operation_type_id IS 'Идентификатор типа операции';
COMMENT ON COLUMN operation.product_id IS 'Идентификатор банковского продукта';
COMMENT ON COLUMN operation.balance_after_operation IS 'Баланс счета после операции';
COMMENT ON CONSTRAINT unique_product_id_operation_type_id_created_at ON operation IS 'Уникальность комбинации идентификатора банковского продукта, идентификатора типа операции и даты создания операции';
COMMENT ON INDEX idx_operation_operation_type_id IS 'Индекс для ускорения поиска по идентификатору типа операции';
COMMENT ON INDEX idx_operation_product_id IS 'Индекс для ускорения поиска по идентификатору банковского продукта';

CREATE TABLE IF NOT EXISTS interest_rate_history(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_type_id BIGINT NOT NULL REFERENCES product_type(id),
    interest_rate DECIMAL(4, 2) NOT NULL CHECK (
        interest_rate >= 0 AND interest_rate <= 30.00
    ),
    started_at DATE NOT NULL DEFAULT CURRENT_DATE CHECK (
        started_at <= CURRENT_DATE AND started_at >= CURRENT_DATE - INTERVAL '50 years'
    ),
    CONSTRAINT unique_product_type_id_started_at UNIQUE (product_type_id, started_at)
);

CREATE INDEX idx_interest_rate_history_product_type_id ON interest_rate_history(product_type_id);

COMMENT ON TABLE interest_rate_history IS 'Таблица для хранения информации об истории процентных ставок';
COMMENT ON COLUMN interest_rate_history.id IS 'Идентификатор';
COMMENT ON COLUMN interest_rate_history.product_type_id IS 'Идентификатор типа банковского продукта';
COMMENT ON COLUMN interest_rate_history.interest_rate IS 'Размер процентной ставки';
COMMENT ON COLUMN interest_rate_history.started_at IS 'Дата начала действия';
COMMENT ON CONSTRAINT unique_product_type_id_started_at ON interest_rate_history IS 'Уникальность комбинации идентификатора типа банковского продукта и даты начала действия';
COMMENT ON INDEX idx_interest_rate_history_product_type_id IS 'Индекс для ускорения поиска по идентификатору типа банковского продукта';

CREATE TABLE product_status_history (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES product(id),
    status_id BIGINT NOT NULL REFERENCES status(id),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP CHECK (
        changed_at <= CURRENT_TIMESTAMP AND changed_at >= CURRENT_TIMESTAMP - INTERVAL '50 years'
    ),
    CONSTRAINT unique_product_id_status_id_changed_at UNIQUE (product_id, status_id, changed_at)
);

CREATE INDEX idx_product_status_history_product_id ON product_status_history(product_id);
CREATE INDEX idx_product_status_history_status_id ON product_status_history(status_id);

COMMENT ON TABLE product_status_history IS 'Таблица для хранения информации об истории статусов банковских продуктов';
COMMENT ON COLUMN product_status_history.id IS 'Идентификатор';
COMMENT ON COLUMN product_status_history.product_id IS 'Идентификатор банковского продукта';
COMMENT ON COLUMN product_status_history.status_id IS 'Идентификатор статуса банковского счета';
COMMENT ON COLUMN product_status_history.changed_at IS 'Дата изменения статуса банковского счета';
COMMENT ON INDEX idx_product_status_history_product_id IS 'Индекс для ускорения поиска по идентификатору типа банковского продукта';
COMMENT ON INDEX idx_product_status_history_status_id IS 'Индекс для ускорения поиска по идентификатору статуса банковского продукта';
COMMENT ON CONSTRAINT unique_product_id_status_id_changed_at ON product_status_history IS 'Уникальность комбинации идентификатора типа банковского продукта, идентификатора статуса и даты изменения статуса'
-- Ваш SQL код здесь
