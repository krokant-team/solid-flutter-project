import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'line_data.dart';

class RatingLine extends StatelessWidget {
  final List<int> weeklyRatings;

  const RatingLine({
    super.key,
    required this.weeklyRatings
  });

  @override
  Widget build(BuildContext context) {
    // initialize line data
    LineData ratingLineData = LineData(ratings: weeklyRatings);
    ratingLineData.initLineData();

    return LineChart(
      LineChartData(
        maxY: 5,
        minY: -5,
        gridData: const FlGridData(
          show: false,
          drawHorizontalLine: false,
        ),
        borderData: FlBorderData(show: false),
        // line titles
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          // TODO: smart bottom titles
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: ratingLineData.lineData.map(
              (rating) => FlSpot(rating.date, rating.rating.toDouble()),
            ).toList(),
            // line style
            // read more here: https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md#LineChartBarData
            isCurved: true,
            gradient: const LinearGradient(
              colors: [
                Colors.indigoAccent,
                Colors.indigo,
              ],
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), // hide points on line
          ),
        ],
        // bubble with rating of each session in the week
        // appears when you touch the line
        // read more here: https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/line_chart.md#LineTouchTooltipData
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 15,
            getTooltipColor: (_) => Colors.white,
          ),
        ),
      ),
    );
  }
}