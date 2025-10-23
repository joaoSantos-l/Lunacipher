# Enciphered

A simple flutter-based password manager mobile application.

## Tables
- tbUsers
  - id int autoincrement
  - username string
  - email string
  - userAuthData string
    
- tbPasswords
  - id int autoincrement
  - email fk
  - platformUrl string
  - platformPassword string
  - passwordDescription string
  - created_at date

## Login & Register
When the user registers a new account, the email and loginPassword are hashed, concatenated and stored in SQLite.
On login, the userAuthData is compared to the loginAuthData. If the hashes match, the user successfully logs in.

## Stored Passwords
We will encrypt the passwords using [AES](https://stackoverflow.com/questions/70061906/how-to-encrypt-password-while-saving-in-database-in-flutter-sqlite-dart-applicat) for more security.

## Ideas
Email verification for password recovery.
Password Generator.
