class Graph{
  final x;
  final y;
  Graph(this.x,this.y);

  factory Graph.fromMap(Map<dynamic,dynamic> m){
    return Graph(
      m['x'],
      m['y']
    );
  }

  @override
  String toString() {
    return 'Graph{x: $x, y: $y}';
  }
}