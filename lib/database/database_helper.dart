import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static Box? _hiveBox;

  DatabaseHelper._init();

  Future<void> initDatabase() async {
    if (kIsWeb) {
      await Hive.initFlutter();
      _hiveBox = await Hive.openBox('users');
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (kIsWeb) throw UnsupportedError("Gunakan Hive di Web!");

    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> registerUser(String username, String password) async {
    if (kIsWeb) {
      await _hiveBox?.put(username, password);
    } else {
      final db = await database;
      await db.insert(
        'users',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    if (kIsWeb) {
      final storedPassword = _hiveBox?.get(username);
      if (storedPassword == password) {
        return {'username': username, 'password': password};
      }
      return null;
    } else {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      return result.isNotEmpty ? result.first : null;
    }
  }
}
