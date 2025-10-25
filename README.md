# 🔐 **Lunacipher**

A simple and secure **Flutter-based Password Manager** built with **SQLite** and **AES encryption**.

![Lunacipher Logo](image.png)

---

## 🧭 Overview

**Lunacipher** is a mobile application that helps users **store, manage, and secure passwords locally**.

---

## 🗂️ Database Schema

### **Table: `tbUsers`**

| Column         | Type                      | Description                |
| :------------- | :------------------------ | :------------------------- |
| `id`           | `INTEGER (AUTOINCREMENT)` | Unique user ID             |
| `username`     | `TEXT`                    | Chosen username            |
| `email`        | `TEXT`                    | User’s email               |
| `userAuthData` | `TEXT`                    | Hashed authentication data |

### **Table: `tbPasswords`**

| Column                | Type                      | Description                |
| :-------------------- | :------------------------ | :------------------------- |
| `id`                  | `INTEGER (AUTOINCREMENT)` | Unique password entry ID   |
| `email`               | `TEXT (FK)`               | References `tbUsers.email` |
| `platformUrl`         | `TEXT`                    | Platform or website URL   |
| `platformPassword`    | `TEXT`                    | AES-encrypted password     |
| `passwordDescription` | `TEXT`                    | Optional description       |
| `created_at`          | `DATE`                    | Date of creation           |

---

## 🔑 Authentication Flow

### **Registration**

1. User enters their **email** and **password**.
2. The app **hashes** and **concatenates** these credentials.
3. The result is stored in the `userAuthData` field within `tbUsers`.

### **Login**

1. When logging in, the app repeats the same hashing process.
2. If the computed hash **matches** the stored `userAuthData`, the user gains access.


---

## 🛡️ Password Storage Security

All stored passwords are **encrypted using AES (Advanced Encryption Standard)** before being saved in the SQLite database.
Only decrypted when needed during app runtime.

🔗 **Reference:** [AES encryption in Flutter & SQLite](https://stackoverflow.com/questions/70061906/how-to-encrypt-password-while-saving-in-database-in-flutter-sqlite-dart-applicat)

---

## 💡 Planned Features

| Feature                        | Description                                       | Status         |
| :----------------------------- | :------------------------------------------------ | :------------- |
| ✉️ **Email Verification**      | Enables password recovery through verified email. | 🟡 Planned     |
| ⚙️ **Password Generator**      | Generates strong, random passwords for users.     | 🟡 Planned     |
