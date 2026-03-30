import 'package:flutter/material.dart';

import '../services/audio_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _bgmOn;
  late bool _sfxOn;
  late double _bgmVolume;
  late double _sfxVolume;

  @override
  void initState() {
    super.initState();
    final audio = AudioService.instance;
    _bgmOn = audio.bgmEnabled;
    _sfxOn = audio.sfxEnabled;
    _bgmVolume = audio.bgmVolume;
    _sfxVolume = audio.sfxVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置中心')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('大厅 / 牌桌 BGM'),
            subtitle: const Text('控制背景音乐开关'),
            value: _bgmOn,
            onChanged: (value) async {
              setState(() => _bgmOn = value);
              await AudioService.instance.setBgmEnabled(value);
            },
          ),
          ListTile(
            title: const Text('BGM 音量'),
            subtitle: Slider(
              value: _bgmVolume,
              onChanged: _bgmOn
                  ? (value) async {
                      setState(() => _bgmVolume = value);
                      await AudioService.instance.setBgmVolume(value);
                    }
                  : null,
            ),
            trailing: Text('${(_bgmVolume * 100).round()}%'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('操作音效'),
            subtitle: const Text('跟注 / 加注 / 弃牌 / 胜负音效'),
            value: _sfxOn,
            onChanged: (value) async {
              setState(() => _sfxOn = value);
              await AudioService.instance.setSfxEnabled(value);
            },
          ),
          ListTile(
            title: const Text('音效音量'),
            subtitle: Slider(
              value: _sfxVolume,
              onChanged: _sfxOn
                  ? (value) async {
                      setState(() => _sfxVolume = value);
                      await AudioService.instance.setSfxVolume(value);
                    }
                  : null,
            ),
            trailing: Text('${(_sfxVolume * 100).round()}%'),
          ),
        ],
      ),
    );
  }
}
