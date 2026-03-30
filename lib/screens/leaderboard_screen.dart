import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ranks = [
      ('马里奥', '12880', 'assets/m3/trophy_gold.png'),
      ('桃花公主', '11720', 'assets/m3/trophy_silver.png'),
      ('路易吉', '11030', 'assets/m3/trophy_bronze.png'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('排行榜')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/m3/leaderboard_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFFFF3E0)),
          ),
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            itemCount: ranks.length,
            itemBuilder: (context, index) {
              final item = ranks[index];
              return Card(
                child: ListTile(
                  leading: Image.asset(item.$3, width: 40, height: 40, errorBuilder: (context, error, stackTrace) => Text('${index + 1}')),
                  title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text('蘑菇币 ${item.$2}'),
                  trailing: Text('#${index + 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
