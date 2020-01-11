import 'package:expenses_track/database/db_scripts.dart';
import 'package:expenses_track/model/graph.dart';
import 'package:expenses_track/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatefulWidget{
  PieChart({Key key}) : super(key:key);
  PieChartState createState() => PieChartState();
}

class PieChartState extends State<PieChart>{
  static String _category;
  static String _total;

  @override
  Widget build(BuildContext context) {
    return _getPieChart();
  }

  _getPieChart(){
    Future<List<Graph>> _expensesList =  ExpensesTrackDb.db.getAllExpensesGroupedByCategory();
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
              return new charts.PieChart(
                [
                  new charts.Series<Graph, String>(
                    id: 'pieChart',
                    domainFn: (Graph graph, _) =>  graph.x,
                    measureFn: (Graph graph, _) => graph.y,
                    data: snapshot.data,
                  )
                ],
                animate: true,
                behaviors: [new charts.DatumLegend(
                  position: charts.BehaviorPosition.bottom,
                  showMeasures: true,
                  horizontalFirst: false,
                  legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                  measureFormatter: (num value) {
                    return value == null ? '-' : '${value}';
                  },
                )],
                selectionModels: [
                  new charts.SelectionModelConfig(
                    type: charts.SelectionModelType.info,
                    changedListener: _updateListenerPieChart,
                  )
                ],
              );
          }
          return Text("No Data Available");
        }
    );
  }
  _updateListenerPieChart(charts.SelectionModel model) {
//    _pieChartState.selectionModels[charts.SelectionModelType.action] = new charts.UserManagedSelectionModel();
    model.selectedDatum.forEach((f){
      print(f.datum.toString());
    });
  }


}