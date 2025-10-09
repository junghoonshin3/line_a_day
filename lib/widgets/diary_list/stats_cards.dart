import 'package:flutter/material.dart';

class StatsCards extends StatelessWidget {
  final int totalEntries;
  final int currentStreak;
  final String recentMood;

  const StatsCards({
    super.key,
    required this.totalEntries,
    required this.currentStreak,
    required this.recentMood,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('$totalEntries', '총 일기')),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard('$currentStreak', '연속 작성')),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard(recentMood, '최근 기분')),
      ],
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
