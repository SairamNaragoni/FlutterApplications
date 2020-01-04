import 'package:flutter/material.dart';
import 'menu.dart';
import 'expenses_track_home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Track',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: ExpensesTrackHome(),
    );
  }
}