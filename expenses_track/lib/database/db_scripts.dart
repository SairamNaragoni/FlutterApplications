import 'dart:async';
import 'dart:io';
import 'package:expenses_track/model/expense.dart';
import 'package:expenses_track/model/graph.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ExpensesTrackDb{
  static final _categories =
  ['Food','Entertainment','Shopping','Household','Travel','Investments','Transfers','Others'];
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
    await deleteDatabase(path);
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db){},
        onCreate: (Database db,int version) async{
          await db.execute('CREATE TABLE expenses(id INTEGER PRIMARY KEY,amount REAL,date TEXT,category TEXT,notes TEXT)');
          await db.execute('CREATE TABLE categories(id INTEGER PRIMARY KEY,category TEXT)');
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [1000, '2020-01-04', "Food","KFC"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [100, '2020-01-04', "Food","MCD"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [ 800, '2020-01-04', "Entertainment","Movie"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [ 200, '2020-01-05', "Investments","Mutual Funds"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [1000, '2020-01-05', "Shopping","Levis"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [1000, '2020-01-06', "Travel","GOA"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [800, '2020-01-07', "Travel","Gokarna"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [1200, '2020-01-07', "Transfers","Dad"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [100, '2020-01-08', "Others","Bday"]
          );
          for(int i =0;i<_categories.length;i++){
            await db.execute('INSERT INTO categories(id,category) VALUES(?,?)',[i+1,_categories[i]]);
          }
        },
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    List<Map> results = await db.query("expenses",orderBy: "date");
    List<Expense> expenses = new List();
    results.forEach((result){
      expenses.add(Expense.fromMap(result));
    });
    return expenses;
  }

  Future<List<Graph>> getAllExpensesGroupedByDate() async {
    final db = await database;
    List<Map> results = await db.rawQuery("SELECT date,SUM(amount) as total FROM expenses GROUP BY date");
    List<Graph> points = new List();
    results.forEach((result){
      points.add(Graph.fromMap(result));
    });
    return points;
  }

  Future<List<Expense>> getAllExpensesByDate(String date) async{
    final db = await database;
    List <Map> results = await db.query("expenses",where:"date = ?",whereArgs: [date],orderBy: "id DESC");
    List<Expense> expenses = new List();
    results.forEach((result){
      Expense expense = Expense.fromMap(result);
      expenses.add(expense);
    });
    return expenses;
  }

  insertExpense(Expense expense) async{
    final db = await database;
//    var maxIdResult = await db.rawQuery(
//        'SELECT MAX(id)+1 as last_inserted_id FROM expenses'
//    );
//    var id = maxIdResult.first['last_inserted_id'];
    await db.rawInsert('INSERT INTO expenses (amount, date, category,notes) VALUES (?, ?, ?, ?)',
        [expense.amount, expense.formattedDate, expense.category,expense.notes]
    );
  }

  update(Expense expense) async {
    final db = await database;
    var result = await db.update(
        "expenses", expense.toMap(), where: "id = ?", whereArgs: [expense.id]
    );
    return result;
  }

  delete(int id) async {
    final db = await database;
    db.delete("expenses", where: "id = ?", whereArgs: [id]);
  }

  Future<List<String>> getAllCategories() async {
    final db = await database;
    List<Map> results = await db.query("categories");
    List<String> categories = new List();
    results.forEach((result){
      categories.add(result['category']);
    });
    return categories;
  }

  insertCategory(String newCategory) async{
    final db = await database;
    await db.rawInsert('INSERT INTO categories (category) VALUES(?)',[newCategory]);
  }

}