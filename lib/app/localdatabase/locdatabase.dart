import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sqldb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await iniDataBase() as Database;
      return _db;
    } else {
      return _db;
    }
  }

  Future<void> iniDataBase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'awab.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
        ALTER TABLE "praises" (
        id INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY,
        npraise TEXT NOT NULL,
        count int,
        totalcount int)
         ''');
    print("doneeeeeeeeeeeee");
  }

  Future<void> readData() async {
    Database? mydb = await db;
  }
}
