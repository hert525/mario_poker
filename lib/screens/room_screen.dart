import 'package:flutter/material.dart';

import '../widgets/pixel_panel.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  int _selected = 0;

  final _rooms = const [
    ('初级场', '1-2 币', '适合新手热身，节奏平稳', Color(0xFF66BB6A)),
    ('中级场', '5-10 币', '有点火药味，适合练胆', Color(0xFFFFCA28)),
    ('高级场', '50-100 币', '高风险高收益，慎入', Color(0xFFEF5350)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('房间选择')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('选择你的场次', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...List.generate(_rooms.length, (index) {
              final room = _rooms[index];
              final selected = index == _selected;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selected = index),
                  child: PixelPanel(
                    color: room.$4.withValues(alpha: selected ? 0.24 : 0.12),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: room.$4, child: Text('${index + 1}')),
                      title: Text(room.$1, style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text('${room.$2} · ${room.$3}'),
                      trailing: selected ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.videogame_asset_rounded),
              label: Text('进入${_rooms[_selected].$1}'),
            ),
          ],
        ),
      ),
    );
  }
}
