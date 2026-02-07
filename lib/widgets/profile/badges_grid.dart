import 'package:flutter/material.dart';

class BadgesGrid extends StatelessWidget {
  const BadgesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Badges Data
    final badges = [
      {'name': 'Python Pro', 'desc': 'Logic Master', 'color': Colors.blue},
      {'name': '50 Day Streak', 'desc': 'Consistency', 'color': Colors.orange},
      {'name': 'Algorithm Hero', 'desc': 'Efficiency Expert', 'color': Colors.green},
      {'name': 'SQL Wizard', 'desc': 'Data Specialist', 'color': Colors.purple},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: badge['color'] as Color, size: 32),
              const SizedBox(height: 8),
              Text(
                badge['name'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                badge['desc'] as String,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
