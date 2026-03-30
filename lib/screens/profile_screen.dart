import 'package:flutter/material.dart';

import '../widgets/pixel_panel.dart';
import 'daily_quest_screen.dart';
import 'leaderboard_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人中心')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PixelPanel(
            color: const Color(0xFFFFF3E0),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(radius: 32, child: Text('🍄', style: TextStyle(fontSize: 28))),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MarioHero_2048', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        SizedBox(height: 4),
                        Text('段位：蘑菇城精英 · 金币：12580'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _MenuTile(icon: Icons.emoji_events_rounded, title: '战绩统计', subtitle: '胜率、连胜、最高收益'),
          _MenuTile(
            icon: Icons.task_alt_rounded,
            title: '每日任务',
            subtitle: '签到、比牌、任务砖块奖励',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DailyQuestScreen())),
          ),
          _MenuTile(
            icon: Icons.leaderboard_rounded,
            title: '排行榜',
            subtitle: '蘑菇王国赛道排行',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
          ),
          _MenuTile(
            icon: Icons.settings_rounded,
            title: '设置中心',
            subtitle: '音效、震动、账号与隐私',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title, required this.subtitle, this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PixelPanel(
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ),
    );
  }
}
