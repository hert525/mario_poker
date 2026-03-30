import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  String? _currentBgm;
  bool _bgmEnabled = true;
  bool _sfxEnabled = true;
  double _bgmVolume = 0.7;
  double _sfxVolume = 0.9;

  bool get bgmEnabled => _bgmEnabled;
  bool get sfxEnabled => _sfxEnabled;
  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;

  Future<void> setBgmEnabled(bool value) async {
    _bgmEnabled = value;
    if (!value) {
      await _bgmPlayer.stop();
    } else if (_currentBgm != null) {
      await _playBgm(_currentBgm!);
    }
  }

  Future<void> setSfxEnabled(bool value) async {
    _sfxEnabled = value;
  }

  Future<void> setBgmVolume(double value) async {
    _bgmVolume = value;
    await _bgmPlayer.setVolume(value);
  }

  Future<void> setSfxVolume(double value) async {
    _sfxVolume = value;
    await _sfxPlayer.setVolume(value);
  }

  Future<void> playLobbyBgm() => _playBgm('assets/m3/audio/bgm_lobby.wav');
  Future<void> playTableBgm() => _playBgm('assets/m3/audio/bgm_table.wav');
  Future<void> stopBgm() => _bgmPlayer.stop();

  Future<void> playDeal() => _playSfx('assets/m3/audio/sfx_deal.wav');
  Future<void> playFlip() => _playSfx('assets/m3/audio/sfx_flip.wav');
  Future<void> playBet() => _playSfx('assets/m3/audio/sfx_bet.wav');
  Future<void> playCall() => _playSfx('assets/m3/audio/sfx_call.wav');
  Future<void> playFold() => _playSfx('assets/m3/audio/sfx_fold.wav');
  Future<void> playCheck() => _playSfx('assets/m3/audio/sfx_check.wav');
  Future<void> playClick() => _playSfx('assets/m3/audio/sfx_click.wav');
  Future<void> playWin() => _playSfx('assets/m3/audio/sfx_win.wav');
  Future<void> playLose() => _playSfx('assets/m3/audio/sfx_lose.wav');

  Future<void> _playBgm(String asset) async {
    _currentBgm = asset;
    if (!_bgmEnabled) return;
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(_bgmVolume);
    await _bgmPlayer.play(AssetSource(asset.replaceFirst('assets/', '')));
  }

  Future<void> _playSfx(String asset) async {
    if (!_sfxEnabled) return;
    await _sfxPlayer.stop();
    await _sfxPlayer.setVolume(_sfxVolume);
    await _sfxPlayer.play(AssetSource(asset.replaceFirst('assets/', '')));
  }
}
