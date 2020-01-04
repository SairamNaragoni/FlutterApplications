import 'dart:async';
import 'dart:io';
import 'package:expenses_track/model/expense.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ExpensesTrackDb{
  static final categories = ['food','entertainment','shopping','household','travel','investments','transfers','others'];
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
              [1000, '2019-12-29', "Food","KFC"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [100, '2019-12-29', "Food","MCD"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [ 800, '2019-12-29', "Entertainment","Movie"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [ 2000, '2019-12-29', "Investments","Mutual Funds"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [1000, '2019-12-29', "Shopping","Levis"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [10000, '2019-12-29', "Travel","GOA"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [8000, '2019-12-29', "Travel","Gokarna"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [50000, '2019-12-29', "Transfers","Dad"]
          );
          await db.execute('INSERT INTO expenses (amount,date,category,notes) values (?, ?, ?, ?)',
              [100, '2019-12-29', "Others","Bday"]
          );
          for(int i =0;i<categories.length;i++){
            await db.execute('INSERT INTO categories(id,category) VALUES(?,?)',[i+1,categories[i]]);
          }
          print('Database Created and Categories Inserted');
        },
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    List<Map> results = await db.query("expenses");
    List<Expense> expenses = new List();
    results.forEach((result){
      expenses.add(Expense.fromMap(result));
    });
    return expenses;
  }

  Future<List<Expense>> getAllExpensesByDate(String date) async{
    print('Getting all expenses on : '+date);
    final db = await database;
    List <Map> results = await db.query("expenses",where:"date = ?",whereArgs: [date]);
    List<Expense> expenses = new List();
    results.forEach((result){
      Expense expense = Expense.fromMap(result);
      expenses.add(expense);
    });
    return expenses;
  }

  Future<Expense> insertExpense(Expense expense) async{
    final db = await database;
    var maxIdResult = await db.rawQuery(
        'SELECT MAX(id)+1 as last_inserted_id FROM expenses'
    );
    var id = maxIdResult.first['last_inserted_id'];
    var result = await db.rawInsert('INSERT Into expenses (id, amount, date, category,notes) VALUES (?, ?, ?, ?, ?)',
        [ id, expense.amount, expense.date.toString(), expense.category,expense.notes]
    );
    print('Iserting Expenses'+ result.toString());
    return Expense(id,expense.amount,expense.date,expense.category,expense.notes);
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

}