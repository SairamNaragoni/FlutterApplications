import 'package:flutter/material.dart';

Widget menu(){
  return AppBar(
    title: Text("Expenses Track") ,
    leading: IconButton(
      icon: Icon(Icons.menu),
      color: Colors.black,
      iconSize: 40,
      onPressed: null,
    ),
  );
}
