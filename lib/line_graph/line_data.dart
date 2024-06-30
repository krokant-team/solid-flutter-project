import 'line_point.dart';

//TODO
class LineData {
  final List<int> ratings;
  List<LinePoint> lineData = [];

  LineData({required this.ratings});

  void initLineData() {
    lineData = List.generate(
      ratings.length,
      (index) => LinePoint(date: index.toDouble(), rating: ratings[index]),
    );
  }
}