import 'package:flutter/material.dart';

import '../widgets/pixel_panel.dart';

class HallScreen extends StatelessWidget {
  const HallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('蘑菇王国大厅')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF90CAF9), Color(0xFFE8F5E9)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PixelPanel(
              color: const Color(0xFFFFF3E0),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('🍄 Mario Poker', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    SizedBox(height: 8),
                    Text('欢迎来到蘑菇王国，选个场次就开炸金花。金币、砖块、水管，味儿先整起来。'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(child: _StatBox(title: '蘑菇币', value: '12,580')),
                SizedBox(width: 12),
                Expanded(child: _StatBox(title: '今日连胜', value: '5')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('快速入场', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            const _RoomTile(title: '新手水管场', subtitle: '底注 100 · 3分钟一局', color: Color(0xFF66BB6A), icon: '🟢'),
            const _RoomTile(title: '金币城堡场', subtitle: '底注 1000 · 胜者赢星星', color: Color(0xFFFFCA28), icon: '🪙'),
            const _RoomTile(title: '库巴火山场', subtitle: '底注 5000 · 高风险高回报', color: Color(0xFFEF5350), icon: '🔥'),
            const SizedBox(height: 16),
            PixelPanel(
              color: const Color(0xFFE8F5E9),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('今日任务', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    SizedBox(height: 8),
                    Text('• 赢下 2 场比牌\n• 登录领取 100 蘑菇币\n• 观看一次高手对局'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({required this.title, required this.subtitle, required this.color, required this.icon});

  final String title;
  final String subtitle;
  final Color color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PixelPanel(
        color: color.withValues(alpha: 0.18),
        child: ListTile(
          leading: Text(icon, style: const TextStyle(fontSize: 28)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(subtitle),
          trailing: FilledButton(onPressed: () {}, child: const Text('进入')),
        ),
      ),
    );
  }
}
