import 'package:expenses_track/database/db_scripts.dart';
import 'package:expenses_track/model/expense.dart';
import 'package:expenses_track/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenses_track/utils/utils.dart';

class Expenses extends StatefulWidget{
  Expenses({Key key}):super(key : key);
  ExpensesState createState ()=> ExpensesState();
}

class ExpensesState extends State<Expenses>{
  static DateTime date = DateTime.now();
  Future<List<Expense>> _expensesList =  ExpensesTrackDb.db.getAllExpensesByDate(DateUtils.formattedDate(date));
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.arrow_back_ios),
            RaisedButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text(
                DateUtils.formattedDate(date),
                style: TextStyle(
                    fontSize: 20,
                    color:Colors.indigoAccent
                ),
              ),
              onPressed: () => _datePicker(context),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
        Expanded(
          child: _getExpensesList(),
        ),
      ],
    );
  }

  _datePicker(BuildContext context){
    Future<DateTime> selectDate = DateUtils.selectDate(context,date);
    selectDate.then((DateTime dt){
      setState(() {
        if(dt!=null)
          date = dt;
        _expensesList = ExpensesTrackDb.db.getAllExpensesByDate(DateUtils.formattedDate(date));
      });
    });
  }

  _getExpensesList(){
    return StreamBuilder<List<Expense>>(
      stream: _expensesList.asStream(),
      builder: (BuildContext context,AsyncSnapshot<List<Expense>> snapshot){
        if(snapshot.hasError){
          return Text('Error : ${snapshot.error}');
        }
        switch(snapshot.connectionState){
          case ConnectionState.none:
            return const Text('No Data Available');
          case ConnectionState.waiting:
           return Utils.getLoadingIcon();
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.data.isEmpty){
              return Utils.textPlaceHolder();
            }
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (_, int index){
                final Expense e = snapshot.data[index];
                return Card(
                  child: Center(
                    child: _tile(e),
                  ),
                );
              }
            );
        }
        return Text("No Data Available");
      }
    );
  }

  _tile(Expense e) => ListTile(
    title: Text("Rs. "+e.amount.toString()+"/-",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(e.notes),
    leading: Icon(
      Utils.getIcon(e.category),
      color: Colors.blue[500],
    ),
  );

}
