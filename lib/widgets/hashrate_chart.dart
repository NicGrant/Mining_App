import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/graph_point.dart';

class HashrateChart extends StatelessWidget {
  final List<GraphPoint> data;

  const HashrateChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) {
      return const Center(
        child: Text(
          'Collecting data...',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(
                e.key.toDouble(),
                e.value.value,
              );
            }).toList(),
            isCurved: true,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
