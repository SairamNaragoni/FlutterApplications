import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils{
  static Future<DateTime> selectDate(BuildContext context,DateTime initialDate) async{
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }
  static String formattedDate(DateTime date){
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }
}