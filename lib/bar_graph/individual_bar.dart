enum Day { sun, mon, tue, wed, thu, fri, sat }

class IndividualBar {
  final Day day;
  final double amount;

  IndividualBar({
    required this.day,
    required this.amount
  });
}