import 'package:expenses_track/database/db_scripts.dart';
import 'package:expenses_track/model/expense.dart';
import 'package:expenses_track/utils/date_utils.dart';
import 'package:expenses_track/views/add_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenses_track/utils/utils.dart';

class Expenses extends StatefulWidget{
  Expenses({Key key}):super(key : key);
  ExpensesState createState ()=> ExpensesState();
}

class ExpensesState extends State<Expenses>{
  static DateTime _date = DateTime.now();
  Future<List<Expense>> _expensesList =  ExpensesTrackDb.db.getAllExpensesByDate(DateUtils.formattedDate(_date));
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlatButton.icon(
              onPressed: (){
                _date = _date.subtract(Duration(days: 1));
                _refreshExpenses();
              },
              icon: Icon(Icons.arrow_back_ios),
              label: Text(""),
              splashColor: Colors.indigo,
            ),
            RaisedButton.icon(
              icon: Icon(Icons.date_range),
              label: Text(
                DateUtils.formattedDate(_date),
                style: TextStyle(
                    fontSize: 20,
                ),
              ),
              onPressed: () => _datePicker(context),
            ),
            FlatButton.icon(
              onPressed: (){
                _date = _date.add(Duration(days: 1));
                _refreshExpenses();
              },
              icon: Icon(Icons.arrow_forward_ios),
              label: Text(""),
              splashColor: Colors.indigo,
            ),
          ],
        ),
        Expanded(
          child: _getExpensesList(),
        ),
      ],
    );
  }

  _refreshExpenses(){
    setState(() {
      _expensesList = ExpensesTrackDb.db.getAllExpensesByDate(DateUtils.formattedDate(_date));
    });
  }

  _datePicker(BuildContext context){
    Future<DateTime> selectDate = DateUtils.selectDate(context,_date);
    selectDate.then((DateTime dt){
      if(dt!=null)
        _date = dt;
      _refreshExpenses();
    });
  }

  _getExpensesList() => StreamBuilder<List<Expense>>(
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

  _tile(Expense expense) => ListTile(
    contentPadding: EdgeInsets.only(left: 20,right: 0),
    title: Text("Rs. "+expense.amount.toString()+"/-",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(expense.notes),
    dense: true,
    leading: Icon(
      Utils.getIcon(expense.category),
      color: Colors.blue[500],
    ),
    trailing: PopupMenuButton(
      onSelected: (selectedDropDownItem) => _handleSelection(selectedDropDownItem,expense),
      itemBuilder: (BuildContext context) =>  [
        new PopupMenuItem(
          value: 0,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.delete,
              ),
              Text(
                " Delete",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          )
        ),
        new PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.edit,
              ),
              Text(
                " Edit",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          )
        ),
      ],
    ),
    onTap: (){

    },
  );

  _handleSelection(int value,Expense expense) {
    switch(value){
      case 0: ExpensesTrackDb.db.delete(expense.id);
        _refreshExpenses();
        Scaffold.of(context).showSnackBar(Utils.snackBar("Expense Deleted"));
        break;
      case 1:Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Edit Expense",
                    ),
                  ),
                  body: AddExpense(oldExpense: expense,),
                ),
              )
             );
            Scaffold.of(context).showSnackBar(Utils.snackBar("Expense Updated"));
      break;
    }
  }
}
