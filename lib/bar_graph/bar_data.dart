import 'individual_bar.dart';

// TODO
class BarData {
  final List<double> amounts;
  List<IndividualBar> barData = [];

  BarData({required this.amounts});

  void initBarData() {
    barData = List.generate(
      amounts.length,
      (index) => IndividualBar(day: Day.values[index%7], amount: amounts[index]),
    );
  }
}