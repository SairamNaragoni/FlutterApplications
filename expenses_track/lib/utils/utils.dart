import 'package:flutter/material.dart';

class Utils{
  static final boxSpace = SizedBox(height: 24,);
  static final box = SizedBox(
    width: 30,
    height: 30,
  );

  static textPlaceHolder({String text="No Data Available"}){
    return Center(child : Text(
      text,
      style: TextStyle(
        fontSize: 20,
      ),
    )
    );
  }

  static getIcon(String category){
    switch(category.toLowerCase()){
      case 'food' : return Icons.fastfood;
      case 'entertainment' : return Icons.movie_filter;
      case 'shopping' : return Icons.shopping_cart;
      case 'household' : return Icons.home;
      case 'travel' : return Icons.airplanemode_active;
      case 'investments' : return Icons.monetization_on;
      case 'transfers' : return Icons.send;
      case 'others' : return Icons.scatter_plot;
    }
  }

  static getLoadingIcon(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Loading Data...'),
            )
          ],
        ),
      ],
    );
  }
}