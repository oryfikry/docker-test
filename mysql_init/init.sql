-- Create schema (created by env too, but safe)
CREATE DATABASE IF NOT EXISTS appdb;
USE appdb;

-- wisdom_words table for service1
CREATE TABLE IF NOT EXISTS wisdom_words (
  id INT AUTO_INCREMENT PRIMARY KEY,
  text VARCHAR(255) NOT NULL
);

INSERT INTO wisdom_words (text) VALUES
  ("Stay hungry, stay foolish."),
  ("Simplicity is the soul of efficiency."),
  ("Make it work, make it right, make it fast.")
ON DUPLICATE KEY UPDATE text = VALUES(text);

-- todos table for service2
CREATE TABLE IF NOT EXISTS todos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  item VARCHAR(255) NOT NULL
);

INSERT INTO todos (item) VALUES
  ("buy milk"),
  ("write code"),
  ("test app")
ON DUPLICATE KEY UPDATE item = VALUES(item);


