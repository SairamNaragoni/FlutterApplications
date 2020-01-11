import 'package:expenses_track/model/graph.dart';
import 'package:expenses_track/utils/constants.dart';
import 'package:expenses_track/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'charts/bar_chart.dart';
import 'charts/pie_chart.dart';

class Summary extends StatefulWidget {
  Summary({Key key}): super(key:key);
  SummaryState createState()=> SummaryState();
}

class SummaryState extends State<Summary> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Direction _direction;
  static final DateTime _date = DateTime.now();
  int _monthIndex = _date.month-1;
  int _year = _date.year;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this,length: 2);
  }

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            controller: _tabController,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.poll)),
              Tab(icon: Icon(Icons.pie_chart))
            ],
          ),
          Expanded(
            child:TabBarView(
            controller: _tabController,
            children: <Widget>[
              BarChart(),
              PieChart(),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2),
              ),
              GestureDetector(
                onPanUpdate: (position){
                  if(position.delta.dx>0) {
                    _direction = Direction.right;
                  }else if(position.delta.dx<0){
                    _direction = Direction.left;
                  }
                },
                onPanEnd: _updateVariables();
                },
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: (){},
                  child : Text(
                    Months.values.elementAt(_monthIndex).toString().split(".")[1],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          )
        ],
      )
    );
  }

  _updateVariables() {
    switch(_direction){
      case Direction.
    }
    if(_direction == Direction.left){
      setState(() {
        _monthIndex = (_monthIndex-1)%12;
      });
    }else if(_direction == Direction.right){
      setState(() {
        _monthIndex = (_monthIndex+1)%12;
    });
  }
}