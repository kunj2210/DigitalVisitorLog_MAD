import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VisitorStatsChart extends StatelessWidget {
  final Map<String, int> stats;

  const VisitorStatsChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const Text(
          'No data available for chart',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visit Purpose Distribution',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: _showingSections(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: stats.keys.map((purpose) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getColorForPurpose(purpose),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                purpose,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    final total = stats.values.fold(0, (sum, count) => sum + count);
    
    return stats.entries.map((entry) {
      final isSelected = false; // Can be expanded for touch interactions
      final radius = isSelected ? 50.0 : 40.0;
      final fontSize = isSelected ? 16.0 : 12.0;

      return PieChartSectionData(
        color: _getColorForPurpose(entry.key),
        value: entry.value.toDouble(),
        title: '${((entry.value / total) * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColorForPurpose(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'delivery':
        return const Color(0xFF3B82F6); // Blue
      case 'personal':
        return const Color(0xFF10B981); // Green
      case 'service':
        return const Color(0xFFF59E0B); // Amber
      case 'other':
        return const Color(0xFF6366F1); // Indigo
      default:
        return Colors.grey;
    }
  }
}
