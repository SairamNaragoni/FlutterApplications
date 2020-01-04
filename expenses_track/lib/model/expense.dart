import 'package:intl/intl.dart';

class Expense{
  int id;
  double amount;
  DateTime date;
  String category;
  String notes;
  static final columns = ['id', 'amount', 'date', 'category','notes'];

  Expense(this.id,this.amount,this.date,this.category,this.notes);
  Expense.empty();
  Expense.cate(this.category);

  String get formattedDate {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(this.date);
  }

  Map<String, dynamic> toMap() => {
      "id":id,
      "amount":amount,
      "date":formattedDate.toString(),
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

  @override
  String toString() {
    return 'Expense{id: $id, amount: $amount, date: $formattedDate, category: $category, notes: $notes}';
  }
}