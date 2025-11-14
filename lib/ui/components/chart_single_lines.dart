import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../../data/controller/graph_controller.dart';


// 08.08.23 Mod. Line Chart with tree Lines
class LineChartSingleLine extends GetView<GraphController> {
  final Color singleLineColor;

  const LineChartSingleLine({super.key, required this.singleLineColor});

  @override
  Widget build(BuildContext context) {
    final GraphController gCtrl = controller;
    return AspectRatio(
      aspectRatio: 3.55,
      child: Obx(
        () => LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                color: singleLineColor,
                spots: gCtrl.pointsPerLiter
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
