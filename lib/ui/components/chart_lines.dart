import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../../data/controller/graph_controller.dart';

// 08.08.23 Mod. Line Chart with tree Lines
class LineChartLines extends GetView<GraphController> {
  final Color firstLineColor;
  final Color secondLineColor;

  const LineChartLines({
    super.key,
    required this.firstLineColor,
    required this.secondLineColor,
  });

  @override
  Widget build(BuildContext context) {
    final GraphController gCtrl = controller;
    return AspectRatio(
      aspectRatio: 3,
      child: Obx(
        () => LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                color: firstLineColor,
                spots: gCtrl.pointsEuro
                    .map((point) => FlSpot(point.x, point.y))
                    .toList(),
                isCurved: false,
                dotData: const FlDotData(show: true),
              ),
              LineChartBarData(
                isStepLineChart: false,
                color: secondLineColor,
                spots: gCtrl.pointsGasoline
                    .map((point) => FlSpot(point.x, point.y))
                    .toList(),
                isCurved: false,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
