import 'package:flutter/material.dart';

class Utils{
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
}