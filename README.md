# ATM Machine Console Application 🏧

A simple, console-based ATM (Automated Teller Machine) system developed using Java and MySQL. This project demonstrates fundamental programming concepts, Object-Oriented Programming (OOP) principles, and database connectivity.

## Features

* **Login System:** Users can log in with a unique account number and PIN.
* **Check Balance:** View the current balance of the account.
* **Deposit:** Add money to the account.
* **Withdrawal:** Withdraw money from the account, with validation for insufficient funds.
* **Transaction Logging:** All deposits and withdrawals are securely logged in a MySQL database.
* **Secure Data:** Uses a MySQL database to store account and transaction data, ensuring data integrity.

## Technologies Used

* **Java:** The core programming language.
* **MySQL:** The relational database for storing user accounts and transaction history.
* **JDBC (Java Database Connectivity):** Used to connect the Java application to the MySQL database.
* **Object-Oriented Programming (OOP):** The code is structured using classes to model real-world entities and their behaviors.

## Prerequisites

1.  **Java Development Kit (JDK):** Ensure you have a JDK installed (version 8 or higher).
2.  **MySQL Server:** A running MySQL server instance.
3.  **MySQL JDBC Driver:** You need the Connector/J JAR file to enable database communication. You can download it from the [MySQL website](https://dev.mysql.com/downloads/connector/j/).

## Setup Instructions

### 1. Database Configuration

* Open your MySQL client (e.g., MySQL Workbench, command line).
* Run the following SQL script to create the `atm_db` database and the necessary tables.

```sql
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
