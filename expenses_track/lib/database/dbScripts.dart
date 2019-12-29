import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ExpensesTrackDb{
  final categories = ['food','entertainment','shopping','household','travel','investments','transfers','others'];
  ExpensesTrackDb._();
  static final ExpensesTrackDb db = ExpensesTrackDb._();
  static Database _database;
  Future<Database> get database async{
    if(_database == null){
      _database = await initDB();
    }
    return _database;
  }
  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,"ExpensesTrack.db");
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db){},
        onCreate: (Database db,int version) async{
          await db.execute('CREATE TABLE IF NOT EXISTS expenses(id INTEGER PRIMARY KEY,amount REAL,date TEXT,category TEXT,notes TEXT)');
          await db.execute('CREATE TABLE IF NOT EXISTS categories(id INTEGER PRIMARY KEY, category TEXT)');
          for(int i =0;i<categories.length;i++){
            await db.execute('INSERT INTO categories(id,category) VALUES(?,?)',[i+1,categories[i]]);
          }
          print("Database Created and categories Inserted");
        },
    );
  }
  



}