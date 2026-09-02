// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notifications.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            isRead INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertNotification(Map<String, dynamic> item) async {
    try {
      final database = await db;
      return await database.insert('notifications', item);
    } catch (e) {
      return Future.error('Failed to insert notification: $e');
    }
  }

  Future<List<dynamic>> getAllNotifications() async {
    final database = await db;
    final result = await database.query('notifications', orderBy: 'id DESC');
    return result;
  }

  Future<void> markAsRead(int id) async {
    final database = await db;
    await database.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final database = await db;
    await database.delete('notifications');
  }

  Future<void> markAllAsRead() async {
    final database = await db;
    await database.update(
      'notifications',
      {'isRead': 1},
    );
  }

  Future<void> deleteNotificationById(int id) async {
    final database = await db;
    await database.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getUnreadCount() async {
    final database = await db;
    final result = Sqflite.firstIntValue(
      await database
          .rawQuery('SELECT COUNT(*) FROM notifications WHERE isRead = 0'),
    );
    return result ?? 0;
  }
}
