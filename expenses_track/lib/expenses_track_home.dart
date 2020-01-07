import 'package:expenses_track/views/expenses.dart';
import 'package:expenses_track/views/summary.dart';
import 'package:flutter/material.dart';
import 'views/add_expense.dart';

class ExpensesTrackHome extends StatefulWidget {
  ExpensesTrackHome({Key key}) : super(key: key);
  @override
  ExpensesTrackHomeState createState() => ExpensesTrackHomeState();
}

class ExpensesTrackHomeState extends State<ExpensesTrackHome> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget _getView(BuildContext context){
    switch(_selectedIndex){
      case 0: return Expenses();
      case 1: return AddExpense();
      case 2: return Summary();
    }
  }
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expenses Track",
          style: optionStyle
        ),
        titleSpacing: 25,
        elevation: 0.7,
      ),
      body: _getView(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text('Expenses'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            title: Text('Add Expense'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text('Summary'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: onItemTapped,
      ),
    );
  }

}