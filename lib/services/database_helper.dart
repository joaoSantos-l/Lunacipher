import 'package:enciphered_app/models/password.dart';
import 'package:enciphered_app/models/user.dart';
import 'package:enciphered_app/services/security_service.dart';
import 'package:enciphered_app/services/session_manager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateContructor();

  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  static const int _version = 3;
  static const String _dbName = "lunacipher_db.db";

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _dbName);
    print('🗄️ Database path resolved to: $path');
    return openDatabase(
      path,
      version: _version,
      onCreate: _createDb,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS users');
        await db.execute('DROP TABLE IF EXISTS passwords');
        await _createDb(db, newVersion);
      },
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON;');
    await db.execute('''
    CREATE TABLE users
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    createdAt DATE,
    userAuthData TEXT NOT NULL UNIQUE);
    ''');

    await db.execute('''
    CREATE TABLE passwords
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    platformPassword TEXT NOT NULL,
    platformName TEXT NOT NULL,
    passwordDescription TEXT,
    createdAt DATE,
    userId INTEGER NOT NULL,
    platformType TEXT NOT NULL,

    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
    );
    ''');
  }

  Future<List<PasswordModel>> getPasswordsByUserId({String? filter}) async {
    final userId = await SessionManager.getCurrentUserId();
    Database db = await instance.database;

    if (filter != null && filter.isNotEmpty) {
      final passwords = await db.query(
        'passwords',
        where: 'userId = ? AND platformName LIKE ?',
        whereArgs: [userId, '%${filter.toLowerCase()}%'],
      );
      List<PasswordModel> passwordFilteredList = passwords.isNotEmpty
          ? passwords.map((item) => PasswordModel.fromMap(item)).toList()
          : [];
      return passwordFilteredList;
    }
    final passwords = await db.query(
      'passwords',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    List<PasswordModel> passwordList = passwords.isNotEmpty
        ? passwords.map((item) => PasswordModel.fromMap(item)).toList()
        : [];
    return passwordList;
  }

  Future<int> addPassword(
    PasswordModel newPassword,
    String plainPassword,
  ) async {
    newPassword.encrypt(plainPassword);
    Database db = await instance.database;
    return await db.insert('passwords', newPassword.toMap());
  }

  Future<int> removePassword(int id) async {
    Database db = await instance.database;
    return await db.delete('passwords', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> removePasswordByUserId(int? userId) async {
    Database db = await instance.database;
    return await db.delete(
      'passwords',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updatePassword(PasswordModel password) async {
    Database db = await instance.database;

    if (!password.platformPassword.contains(':')) {
      password.encrypt(password.platformPassword);
    }

    return await db.update(
      'passwords',
      password.toMap(),
      where: 'id = ?',
      whereArgs: [password.id],
    );
  }

  Future<UserModel?> getUserById() async {
    Database db = await instance.database;
    final userId = await SessionManager.getCurrentUserId();

    var user = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );

    if (user.isNotEmpty) {
      return UserModel.fromMap(user.first);
    }
    return null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    Database db = await instance.database;
    var users = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (users.isNotEmpty) {
      return UserModel.fromMap(users.first);
    }
    return null;
  }

  Future<UserModel?> login(String email, String password) async {
    UserModel? user = await getUserByEmail(email);
    if (user != null &&
        SecurityService.verifyAuthHash(email, password, user.userAuthData)) {
      await SessionManager.saveCurrentUser(user);
      await SecurityService.init();
      return user;
    }
    return null;
  }

  Future<int> addUser(UserModel newUser, String password) async {
    newUser.userAuthData = SecurityService.hashAuthData(
      newUser.email,
      password,
    );
    Database db = await instance.database;

    try {
      return await db.insert('users', newUser.toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return -1;
      }
      rethrow;
    }
  }

  Future<int> removeUser() async {
    Database db = await instance.database;
    final userId = await SessionManager.getCurrentUserId();
    DatabaseHelper.instance.removePasswordByUserId(userId);
    return await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  Future<int> updateUser(UserModel editedUser, String password) async {
    editedUser.userAuthData = SecurityService.hashAuthData(
      editedUser.email,
      password,
    );
    Database db = await instance.database;
    return await db.update(
      'users',
      editedUser.toMap(),
      where: 'id = ?',
      whereArgs: [editedUser.id],
    );
  }
}
