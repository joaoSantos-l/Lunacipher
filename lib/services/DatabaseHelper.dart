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

    CREATE TABLE passwords
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    platformPassword TEXT NOT NULL,
    platformUrl TEXT NOT NULL,
    passwordDescription TEXT,
    createdAt DATE
    userId INTEGER NOT NULL,

    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
    );
    ''');
  }
  
}
