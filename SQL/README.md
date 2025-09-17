import java.sql.*;
import java.util.Scanner;

public class ATM {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/atm_db";
    private static final String USER = "root"; // Replace with your MySQL username
    private static final String PASS = "your_password"; // Replace with your MySQL password

    // Nested class to represent a bank account
    static class Account {
        private int pin;
        private double balance;
        private int accountNumber;

        public Account(int accountNumber, int pin, double balance) {
            this.accountNumber = accountNumber;
            this.pin = pin;
            this.balance = balance;
        }

        public int getAccountNumber() {
            return accountNumber;
        }

        public int getPin() {
            return pin;
        }

        public double getBalance() {
            return balance;
        }

        public void deposit(double amount) {
            balance += amount;
        }

        public boolean withdraw(double amount) {
            if (balance >= amount) {
                balance -= amount;
                return true;
            }
            return false;
        }
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Welcome to the ATM!");

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            System.out.print("Enter account number: ");
            int accountNumber = scanner.nextInt();
            System.out.print("Enter PIN: ");
            int pin = scanner.nextInt();

            Account account = getAccount(conn, accountNumber, pin);
            if (account != null) {
                System.out.println("Login successful!");
                showMenu(conn, scanner, account);
            } else {
                System.out.println("Invalid account number or PIN.");
            }
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
        } finally {
            scanner.close();
        }
    }

    private static Account getAccount(Connection conn, int accountNumber, int pin) throws SQLException {
        String sql = "SELECT * FROM accounts WHERE account_number = ? AND pin = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNumber);
            stmt.setInt(2, pin);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Account(rs.getInt("account_number"), rs.getInt("pin"), rs.getDouble("balance"));
            }
        }
        return null;
    }

    private static void showMenu(Connection conn, Scanner scanner, Account account) throws SQLException {
        while (true) {
            System.out.println("\nATM Menu:");
            System.out.println("1. Check Balance");
            System.out.println("2. Deposit");
            System.out.println("3. Withdraw");
            System.out.println("4. Exit");
            System.out.print("Choose an option: ");

            int choice = scanner.nextInt();
            switch (choice) {
                case 1:
                    System.out.println("Current Balance: $" + account.getBalance());
                    break;
                case 2:
                    System.out.print("Enter amount to deposit: ");
                    double depositAmount = scanner.nextDouble();
                    account.deposit(depositAmount);
                    updateBalance(conn, account);
                    logTransaction(conn, account.getAccountNumber(), "DEPOSIT", depositAmount);
                    System.out.println("Deposit successful. New balance: $" + account.getBalance());
                    break;
                case 3:
                    System.out.print("Enter amount to withdraw: ");
                    double withdrawAmount = scanner.nextDouble();
                    if (account.withdraw(withdrawAmount)) {
                        updateBalance(conn, account);
                        logTransaction(conn, account.getAccountNumber(), "WITHDRAWAL", withdrawAmount);
                        System.out.println("Withdrawal successful. New balance: $" + account.getBalance());
                    } else {
                        System.out.println("Insufficient funds.");
                    }
                    break;
                case 4:
                    System.out.println("Thank you for using the ATM. Goodbye!");
                    return;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        }
    }

    private static void updateBalance(Connection conn, Account account) throws SQLException {
        String sql = "UPDATE accounts SET balance = ? WHERE account_number = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, account.getBalance());
            stmt.setInt(2, account.getAccountNumber());
            stmt.executeUpdate();
        }
    }

    private static void logTransaction(Connection conn, int accountNumber, String type, double amount) throws SQLException {
        String sql = "INSERT INTO transactions (account_number, transaction_type, amount, transaction_date) VALUES (?, ?, ?, NOW())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountNumber);
            stmt.setString(2, type);
            stmt.setDouble(3, amount);
            stmt.executeUpdate();
        }
    }
}