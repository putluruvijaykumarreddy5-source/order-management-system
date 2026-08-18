CREATE TABLE IF NOT EXISTS app_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'ADMIN'
);

CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(id),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING','SHIPPED','DELIVERED','CANCELLED')),
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0)
);

INSERT INTO app_users(username, password, role)
VALUES ('admin', 'admin123', 'ADMIN')
ON CONFLICT (username) DO NOTHING;

INSERT INTO customers(name, email, phone)
VALUES
('Vijay Kumar Reddy', 'vijay@example.com', '9000000001'),
('Rahul Kumar', 'rahul@example.com', '9000000002'),
('Priya Sharma', 'priya@example.com', '9000000003')
ON CONFLICT (email) DO NOTHING;

INSERT INTO products(name, price, stock, active)
SELECT 'Laptop', 50000, 10, TRUE
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Laptop');

INSERT INTO products(name, price, stock, active)
SELECT 'Mouse', 500, 50, TRUE
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Mouse');

INSERT INTO products(name, price, stock, active)
SELECT 'Keyboard', 1500, 25, TRUE
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Keyboard');

INSERT INTO products(name, price, stock, active)
SELECT 'Phone', 30000, 15, TRUE
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Phone');
