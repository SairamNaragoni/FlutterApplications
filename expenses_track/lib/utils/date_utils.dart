import 'package:flutter/material.dart';

class DateUtils{
  static DateTime date = DateTime.now();
  static Future<Null> selectDate(BuildContext context) async{
    final DateTime _selected = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(_selected != null && _selected != date)
        date = _selected;
    }
}