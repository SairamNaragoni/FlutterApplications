import 'package:expenses_track/model/category.dart';
import 'package:intl/intl.dart';

class Expense{

  final int id;
  final double amount;
  final DateTime date;
  final Category category;
  final String notes;
  static final columns = ['id', 'amount', 'date', 'category','notes'];

  Expense(this.id,this.amount,this.date,this.category,this.notes);

  String get formattedDate {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(this.date);
  }

  Map<String, dynamic> toMap() => {
      "id":id,
      "amount":amount,
      "date":date.toString(),
      "category":category,
      "notes":notes,
  };

  factory Expense.fromMap(Map<String, dynamic>data){
    return Expense(
      data['id'],
      data['amount'],
      DateTime.parse(data['date']),
      data['category'],
      data['notes'],
    );
  }
}