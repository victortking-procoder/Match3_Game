import 'package:flutter/material.dart';

class GameInfo extends StatelessWidget {
  final int level;
  final int score;
  final int targetScore;
  final int movesLeft;
  final int coins;

  const GameInfo({
    super.key,
    required this.level,
    required this.score,
    required this.targetScore,
    required this.movesLeft,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoItem(
                icon: Icons.star,
                label: 'Level',
                value: level.toString(),
                color: Colors.amber,
              ),
              _InfoItem(
                icon: Icons.monetization_on,
                label: 'Coins',
                value: coins.toString(),
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoItem(
                icon: Icons.sports_score,
                label: 'Score',
                value: '$score / $targetScore',
                color: Colors.green,
              ),
              _InfoItem(
                icon: Icons.touch_app,
                label: 'Moves',
                value: movesLeft.toString(),
                color: movesLeft <= 5 ? Colors.red : Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
