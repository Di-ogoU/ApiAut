import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ClassBarChart extends StatelessWidget {
  const ClassBarChart({super.key, required this.counts});

  final Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    const labels = ['unacc', 'acc', 'good', 'vgood'];
    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      index >= 0 && index < labels.length ? labels[index] : '',
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: labels.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: (counts[entry.value] ?? 0).toDouble(),
                  width: 28,
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF2F6FED),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
