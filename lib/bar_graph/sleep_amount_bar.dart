import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'bar_data.dart';

class SleepAmountBar extends StatelessWidget {
  final List<double> weeklySummary;

  const SleepAmountBar({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    // initialize bar data
    BarData sleepAmountBarData = BarData(amounts: weeklySummary);
    sleepAmountBarData.initBarData();

    return BarChart(
      BarChartData(
        maxY: 20,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        // bar chart titles
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: sleepAmountBarData.barData.map((data) {
          return BarChartGroupData(
            x: data.day.index,
            barRods: [
              BarChartRodData(
                // bar chart rogs style
                toY: data.amount,
                color: Colors.indigo,
                width: 25,
                borderRadius: BorderRadius.circular(5),
                // bar chart rogs background
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 20,
                  color: Colors.indigo.withOpacity(0.2),
                ),
              ),
            ],
          );
        }).toList(),
        // bubble with amount of sleep hours in each day
        // appears when you touch the bar
        // read more here: https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/bar_chart.md#BarTouchTooltipData
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 15,
            getTooltipColor: (_) => Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  // bar chart titles style
  const style = TextStyle(
    color: Colors.indigo,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final text = value >= 0 && value < days.length
      ? Text(days[value.toInt()], style: style)
      : const Text('');
  
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}