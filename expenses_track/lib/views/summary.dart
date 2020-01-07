import 'package:expenses_track/database/db_scripts.dart';
import 'package:expenses_track/model/expense.dart';
import 'package:expenses_track/model/graph.dart';
import 'package:expenses_track/utils/date_utils.dart';
import 'package:expenses_track/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Summary extends StatefulWidget {
  Summary({Key key}): super(key:key);
  SummaryState createState()=> SummaryState();
}

class SummaryState extends State<Summary>{
  Future<List<Graph>> _expensesList =  ExpensesTrackDb.db.getAllExpensesGroupedByDate();

  @override
  Widget build(BuildContext context) {
    return _getChart(context);
  }
  _getChart(BuildContext context){
    return FutureBuilder<List<Graph>>(
        future: _expensesList,
        builder: (BuildContext context,AsyncSnapshot<List<Graph>> snapshot){
          if(snapshot.hasError){
            return Text('Error : ${snapshot.error}');
          }
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return const Text('No Data Available');
            case ConnectionState.waiting:
              return Utils.getLoadingIcon();
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.data.isEmpty){
                return Utils.textPlaceHolder();
              }
              return new charts.BarChart(
                [
                  new charts.Series<Graph, String>(
                    id: 'amount spent',
                    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (Graph graph, _) => graph.x.day.toString(),
                    measureFn: (Graph graph, _) => graph.y,
                    data: snapshot.data,
//                    labelAccessorFn: (Graph graph,_) => '\$${graph.y.toString()}',
                  )
                ],
                animate: true,
//                barRendererDecorator: new charts.BarLabelDecorator(),
                domainAxis: new charts.OrdinalAxisSpec(),
              );
          }
          return Text("No Data Available");
        }
    );
  }
}