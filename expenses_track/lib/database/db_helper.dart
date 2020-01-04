import 'package:expenses_track/model/expense.dart';

import 'db_scripts.dart';
class DbHelper{
  final _items = [];

  void load(){
    var allExpensesByDate = ExpensesTrackDb.db.getAllExpensesByDate("2019-12-29");

  }
}