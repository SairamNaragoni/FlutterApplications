class Graph{
  final x;
  final y;
  Graph(this.x,this.y);

  factory Graph.fromMap(Map<dynamic,dynamic> m){
    return Graph(
      DateTime.parse(m['date']),
      m['total']
    );
  }
}