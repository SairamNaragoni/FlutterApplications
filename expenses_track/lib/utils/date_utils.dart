import 'package:flutter/material.dart';
class DateUtils extends StatefulWidget{
  @override
  DateUtilsState createState() => DateUtilsState();

}
class DateUtilsState extends State<DateUtils>{
  static DateTime _date = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async{
    final DateTime _selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (_selected != null && _selected != _date)
      setState(() {
        _date = _selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}