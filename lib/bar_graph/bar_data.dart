import 'package:shleappy/data/session.dart';
import 'individual_bar.dart';

class BarData {
  final List<double> amounts;
  List<IndividualBar> barData = [];

  BarData({required this.amounts});

  void initBarData() {
    barData = List.generate(
      amounts.length,
      (index) => IndividualBar(day: index, amount: amounts[index]),
    );
  }
}