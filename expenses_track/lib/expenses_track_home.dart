import 'package:expenses_track/views/expenses.dart';
import 'package:flutter/material.dart';
import 'views/add_expense.dart';

class ExpensesTrackHome extends StatefulWidget {
  ExpensesTrackHome({Key key}) : super(key: key);
  @override
  _ExpensesTrackHomeState createState() => _ExpensesTrackHomeState();
}

class _ExpensesTrackHomeState extends State<ExpensesTrackHome> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget _getView(){
    switch(_selectedIndex){
      case 0: return Expenses().getSummaryView();
      case 1: return AddExpense();
      case 2: return Text('Under Progress !!');
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Track' , style: optionStyle),
        titleSpacing: 25,
        elevation: 0.7,
      ),
      body: _getView(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              title: Text('Summary'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              title: Text('Add'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('Calender'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.indigo,
          onTap: _onItemTapped,
        ),
      );
  }
}