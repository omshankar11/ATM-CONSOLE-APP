CREATE DATABASE IF NOT EXISTS atm_db;
USE atm_db;

CREATE TABLE IF NOT EXISTS accounts (
    account_number INT PRIMARY KEY,
    pin INT NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_number INT NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME NOT NULL,
    FOREIGN KEY (account_number) REFERENCES accounts(account_number)
);

-- Insert some sample data for testing
INSERT INTO accounts (account_number, pin, balance) VALUES (123456, 1111, 5000.00);
INSERT INTO accounts (account_number, pin, balance) VALUES (789012, 2222, 1500.50);