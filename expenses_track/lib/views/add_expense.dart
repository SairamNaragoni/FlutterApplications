import 'dart:ui';
import 'package:expenses_track/database/db_scripts.dart';
import 'package:expenses_track/model/expense.dart';
import 'package:expenses_track/utils/date_utils.dart';
import 'package:expenses_track/utils/utils.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget{
  final Expense oldExpense;
  AddExpense({Key key,this.oldExpense}) : super(key: key);
  @override
  _AddExpenseState createState() => _AddExpenseState(oldExpense);

}
class _AddExpenseState extends State<AddExpense> {
  Expense expense;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final _categories =
  ['Food','Entertainment','Shopping','Household','Travel','Investments','Transfers','Others'];
  _AddExpenseState(Expense oldExpense):
        this.expense = oldExpense ?? Expense.cate("Food");

  _datePicker(BuildContext context){
    Future<DateTime> selectDate = DateUtils.selectDate(context,null);
    selectDate.then((DateTime dt){
      setState(() {
        if(dt!=null)
          expense.date = dt;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    _init();
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _getNumericField(),
            Utils.boxSpace,
            _getTextField(),
            Utils.boxSpace,
            _getDateButton(),
            Utils.boxSpace,
            _getDropDownCategories(),
            Utils.boxSpace,
            _getSubmitButton(),
          ],
        ),
      ),
    );
  }

  _getNumericField() => TextFormField(
    initialValue: (expense.amount ?? "").toString(),
    decoration: InputDecoration(
        icon: Icon(Icons.monetization_on),
        labelText: "Enter Amount",
        fillColor: Colors.white
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    validator: (String value){
      final numeric = new RegExp(r'[0-9]+');
      if(value.isEmpty || !numeric.hasMatch(value)){
        return "Enter A Decimal Number !";
      }else{
        return null;
      }
    },
    onSaved: (String value){
      expense.amount = double.parse(value);
    },
  );

  _getTextField() => TextFormField(
    initialValue: expense.notes ?? "",
    decoration: InputDecoration(
      icon: Icon(Icons.event_note),
      labelText: "Enter Notes",
      fillColor: Colors.white,
    ),
    keyboardType: TextInputType.text,
    onSaved: (String value){
      expense.notes = value;
    },
  );

  _getDateButton() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      FlatButton.icon(
        padding: EdgeInsets.all(0),
        label: Text(
          "Change Date : " + expense.formattedDate,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        icon: Icon(Icons.date_range),
        onPressed: () => _datePicker(context),
      ),
    ],
  );

  _getDropDownCategories() {
    return Container(
      decoration: new BoxDecoration(
        border: Border.all(
            color: Color.fromRGBO(112, 112, 112, 1.0), width: 1.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: DropdownButton(
        autofocus: true,
        isExpanded: true,
        itemHeight: 60.0,
        value: expense.category,
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 24,
        style: TextStyle(
          color: Colors.indigoAccent,
          fontSize: 20,
        ),
        onChanged: (String newValue) {
          setState(() {
            expense.category = newValue;
          });
        },
        items: _categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Utils.getIcon(value)),
                Text(value,)
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  _getSubmitButton() {
    String _operation = widget.oldExpense==null ? "Add" : "Update";
    return RaisedButton(
      color: Colors.indigoAccent,
      elevation: 16,
      textColor: Colors.white,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if(Utils.equalsIgnoreCase(_operation, "add")){
            ExpensesTrackDb.db.insertExpense(expense);
            Scaffold.of(context).showSnackBar(Utils.snackBar("Expense Added"));
            _formKey.currentState.reset();
          }else{
            ExpensesTrackDb.db.update(expense);
            _formKey.currentState.reset();
            Navigator.pop(context);
          }
        }
      },
      child: Text(
        _operation+ " Expense",
        style: TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}