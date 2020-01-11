
import 'package:expenses_track/database/db_scripts.dart';
import 'package:expenses_track/model/graph.dart';
import 'package:expenses_track/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChart extends StatefulWidget{
  BarChart({Key key}):super(key:key);
  BarChartState createState ()=> BarChartState();
}
class BarChartState extends State<BarChart>{
  static String _total;
  static String _date;

  @override
  Widget build(BuildContext context) {
    return _getBarChart();
  }

  _getBarChart(){
    Future<List<Graph>> _expensesList =  ExpensesTrackDb.db.getAllExpensesGroupedByDate();
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
//              snapshot.data.insert(3, Graph(DateTime.now().subtract(Duration(days: 1)),0));
//              snapshot.data.sort((Graph a,Graph b)=> a.x.compareTo(b.x));
              return new charts.BarChart(
                [
                  new charts.Series<Graph, String>(
                    id: 'barChart',
                    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (Graph graph, _) =>  DateTime.parse(graph.x.toString()).day.toString(),
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