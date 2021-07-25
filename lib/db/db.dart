import 'package:sqflite/sqflite.dart';


class AppDatabase {
  static AppDatabase? _instance;
  Database? db;

  final String onCreateSQL =
      'create table appImages(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,comment TEXT,data TEXT,lat DOUBLE,long DOUBLE,img TEXT);';

  onCreateFunction(Database db, int version) {
    db.execute(onCreateSQL);
  }

  Future<void> openDb() async {
    if (db == null)
      return await getDatabasesPath().then((value) async {
        String path = value += 'test.db';
        await openDatabase(
          path,
          version: 1,
          onCreate: onCreateFunction,
        ).then((value) {
          db = value;
        });
      });
  }

  AppDatabase._();

  factory AppDatabase() {
    return _instance ??= AppDatabase._();
  }
}