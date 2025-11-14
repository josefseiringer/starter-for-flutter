

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/controller/graph_controller.dart';

  final kBarTitleStyle = TextStyle(
    color: Colors.blue.shade900,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

class BarChartWidget extends StatelessWidget {
  final GraphController graphCtrl;
  const BarChartWidget({
    super.key,
    required this.graphCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          //alignment: BarChartAlignment.center,
          maxY: 50,
          baselineY: 0,
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          //tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
            );
          },
        ),
      );


  Widget getTitles(double value, TitleMeta meta) {
    List<String> dayMonListString = graphCtrl.getHeadDescription();
    for (var i = 0; i < dayMonListString.length; i++) {
      if (i == value.toInt()) {
        graphCtrl.szBarTitle.value = dayMonListString[i];
      }
    }
    return SideTitleWidget(
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      space: 4,
      meta: meta,
      child: Text(graphCtrl.szBarTitle.value, style: kBarTitleStyle),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      );

  FlBorderData get borderData => FlBorderData(show: false);

  LinearGradient get _barsGradient => LinearGradient(
        colors: [Colors.blue.shade400, Colors.red.shade300],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [BarChartRodData(toY: 8, gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(toY: 10, gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(toY: 14, gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 15, gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [BarChartRodData(toY: 13, gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [BarChartRodData(toY: 10, gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [BarChartRodData(toY: 16, gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
      ];
}
