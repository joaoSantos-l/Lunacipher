import 'package:enciphered_app/models/password.dart';
import 'package:enciphered_app/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateContructor();

  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  static const int _version = 1;
  static const String _dbName = "lunacipher_db.db";

  Future<Database> _initDatabase() async {
    Directory documentDiretory = await getApplicationDocumentsDirectory();
    String path = join(documentDiretory.path, _dbName);
    return openDatabase(path, onCreate: _createDb, version: _version);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
    PRAGMA foreign_keys = ON;

    CREATE TABLE users
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    userAuthData TEXT NOT NULL UNIQUE);
    ''');

    await db.execute('''
    CREATE TABLE passwords
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    platformPassword TEXT NOT NULL,
    platformName TEXT NOT NULL,
    passwordDescription TEXT,
    createdAt DATE
    userId INTEGER NOT NULL,

    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
    );
    ''');
  }

  Future<List<PasswordModel>> getPasswords() async {
    Database db = await instance.database;
    var passwords = await db.query('passwords', orderBy: 'id DESC');
    List<PasswordModel> passwordList = passwords.isNotEmpty
        ? passwords.map((item) => PasswordModel.fromMap(item)).toList()
        : [];
    return passwordList;
  }

  Future<int> addPassword(PasswordModel newPassword) async {
    Database db = await instance.database;
    return await db.insert('passwords', newPassword.toMap());
  }

  Future<int> removePassword(int id) async {
    Database db = await instance.database;
    return await db.delete('passwords', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePassword(PasswordModel password) async {
    Database db = await instance.database;
    return await db.update(
      'passwords',
      password.toMap(),
      where: 'id = ?',
      whereArgs: [password.id],
    );
  }

  Future<List<PasswordModel>> getUser() async {
    Database db = await instance.database;
    var users = await db.query('passwords', orderBy: 'id DESC');
    List<PasswordModel> userList = users.isNotEmpty
        ? users.map((item) => PasswordModel.fromMap(item)).toList()
        : [];
    return userList;
  }

  Future<int> addUser(UserModel newUser) async {
    Database db = await instance.database;
    return await db.insert('users', newUser.toMap());
  }

  Future<int> removeUser(int id) async {
    Database db = await instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateUser(UserModel user) async {
    Database db = await instance.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
