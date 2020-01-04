import 'package:expenses_track/database/db_scripts.dart';
import 'package:expenses_track/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:expenses_track/utils/utils.dart';

class Expenses{

  static const _date = '2019-12-29';
  final Future<List<Expense>> _expensesList =  ExpensesTrackDb.db.getAllExpensesByDate("2019-12-29");

  getSummaryView(){
    return Column(
      children: <Widget>[
        const RaisedButton(
          child: Text(
              _date,
              style: TextStyle(
                  fontSize: 20,
                  color:Colors.white
              ),
          ),
          onPressed: null
        ),
        Expanded(
          child: _getExpensesList(),
        )
      ],
    );
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
              return Text('No Data Available');
            case ConnectionState.waiting:
              return const Text('Loading Data...');
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.data.isEmpty){
                return Text("No Data Available");
              }
              return ListView.builder(
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
          return Text("No Aata Available");
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