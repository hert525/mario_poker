import 'package:flutter/material.dart';

class DailyQuestScreen extends StatelessWidget {
  const DailyQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quests = ['签到领取 100 蘑菇币', '完成 3 次跟注', '赢下 1 场比牌'];
    return Scaffold(
      appBar: AppBar(title: const Text('每日任务')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Image.asset(
              'assets/m3/daily_quest_block.png',
              width: 180,
              height: 180,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.help, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          ...quests.map((q) => Card(child: ListTile(title: Text(q), trailing: const Icon(Icons.check_circle_outline)))),
        ],
      ),
    );
  }
}
