import 'package:expenses_track/model/expense.dart';
import 'package:expenses_track/utils/date_utils.dart';
import 'package:expenses_track/utils/utils.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget{
  AddExpense({Key key}) : super(key: key);
  @override
  _AddExpenseState createState() => _AddExpenseState();

}
class _AddExpenseState extends State<AddExpense> {
  Expense expense = Expense.cate("food");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final boxSpace = SizedBox(height: 24,);
  static final categories = ['food','entertainment','shopping','household','travel','investments','transfers','others'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child : Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          children: <Widget>[
            TextFormField(
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
                print(value);
                expense.amount = double.parse(value);
              },
            ),
            boxSpace,
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.event_note),
                labelText: "Enter Notes",
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
              onSaved: (String value){
                expense.notes = value;
              },
            ),
            boxSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton.icon(
                  padding: EdgeInsets.all(0),
                  label: Text(
                    "Change Date : " + expense.formattedDate.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  icon: Icon(Icons.date_range),
                  onPressed: () => DateUtils.selectDate(context),
                ),
              ],
            ),
            boxSpace,
            Container(
              decoration: new BoxDecoration(
                border: Border.all(color: Color.fromRGBO(112, 112, 112, 1.0), width: 1.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child : DropdownButton(
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
//                underline: Container(
//                  height: 1,
//                  color: Colors.deepPurpleAccent,
//                ),
                onChanged: (String newValue){
                  setState(() {
                    expense.category = newValue;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value){
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
            ),
            boxSpace,
            RaisedButton(
              color: Colors.indigoAccent,
              elevation: 16,
              textColor: Colors.white,
              onPressed: (){
                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  print(expense.toString());
                }
              },
              child: Text(
                "Add New Expense",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

}