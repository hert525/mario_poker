import 'dart:async';

import 'package:flutter/material.dart';

import '../models/ai_action.dart';
import '../models/game_player.dart';
import '../services/ai_opponent.dart';
import '../services/audio_service.dart';
import '../services/zhajinhua_logic.dart';
import '../widgets/game_action_button.dart';
import '../widgets/mario_card.dart';
import '../widgets/pixel_panel.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final ZhajinhuaLogic _logic = ZhajinhuaLogic();
  final AiOpponent _ai = AiOpponent();

  late final List<GamePlayer> _players;
  final int _baseBet = 1;
  int _pot = 0;
  int _highestBet = 0;
  int _round = 1;
  bool _dealing = false;
  bool _settled = false;
  String _status = '蘑菇王国牌局已开始';
  List<String>? _resultFrames;
  int _resultFrameIndex = 0;
  Timer? _resultTimer;

  @override
  void initState() {
    super.initState();
    AudioService.instance.playTableBgm();
    _players = [
      GamePlayer(name: '路易吉', avatarAsset: 'assets/avatar_luigi.png', isHuman: false, seat: 0),
      GamePlayer(name: '桃花公主', avatarAsset: 'assets/avatar_peach.png', isHuman: false, seat: 1),
      GamePlayer(name: '你', avatarAsset: 'assets/avatar_mario.png', isHuman: true, seat: 2),
    ];
    unawaited(_startRound());
  }

  @override
  void dispose() {
    _resultTimer?.cancel();
    super.dispose();
  }

  Future<void> _startRound() async {
    _resultTimer?.cancel();
    _resultFrames = null;
    _resultFrameIndex = 0;
    await AudioService.instance.playDeal();

    final dealt = _logic.dealHands(playerCount: _players.length);
    setState(() {
      _dealing = true;
      _settled = false;
      _pot = 0;
      _highestBet = 0;
      _status = '正在发牌...';
      for (var i = 0; i < _players.length; i++) {
        _players[i].resetForRound(dealt[i]);
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _dealing = false;
      _status = '第 $_round 局开始，先看牌还是先压一手？';
    });
  }

  Future<void> _humanAction(AiActionType type) async {
    if (_dealing || _settled) return;
    await AudioService.instance.playClick();
    final human = _players.last;
    switch (type) {
      case AiActionType.check:
        human.looked = true;
        _status = '你选择看牌，心里有底了。';
        await AudioService.instance.playCheck();
      case AiActionType.call:
        final amount = _requiredToCall(human);
        _applyBet(human, amount == 0 ? _baseBet : amount);
        _status = '你跟注 ${amount == 0 ? _baseBet : amount} 币。';
        await AudioService.instance.playCall();
      case AiActionType.raise:
        final amount = _requiredToCall(human) + 2;
        _applyBet(human, amount);
        _status = '你加注 $amount 币，气势拉满。';
        await AudioService.instance.playBet();
      case AiActionType.fold:
        human.folded = true;
        _status = '你弃牌观战，先稳一手。';
        await AudioService.instance.playFold();
    }
    setState(() {});
    await _afterHumanAction();
  }

  Future<void> _afterHumanAction() async {
    await _runAiTurns();
    _checkRoundEnd();
  }

  Future<void> _runAiTurns() async {
    for (final player in _players.where((p) => !p.isHuman && !p.folded)) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      final action = _ai.decide(
        cards: player.cards,
        coins: player.coins,
        currentBet: player.currentBet,
        highestBet: _highestBet,
      );
      if (!mounted) return;
      switch (action.type) {
        case AiActionType.check:
          player.looked = true;
          _status = '${player.name} 看牌观望。';
          await AudioService.instance.playCheck();
        case AiActionType.call:
          final amount = _requiredToCall(player);
          _applyBet(player, amount == 0 ? _baseBet : amount);
          _status = '${player.name} 跟注。';
          await AudioService.instance.playCall();
        case AiActionType.raise:
          _applyBet(player, action.raiseAmount);
          _status = '${player.name} 加注 ${action.raiseAmount} 币。';
          await AudioService.instance.playBet();
        case AiActionType.fold:
          player.folded = true;
          _status = '${player.name} 弃牌了。';
          await AudioService.instance.playFold();
      }
      if (!mounted) return;
      setState(() {});
    }
  }

  void _applyBet(GamePlayer player, int amount) {
    final realAmount = amount <= 0 ? _baseBet : amount;
    final safeAmount = realAmount > player.coins ? player.coins : realAmount;
    player.coins -= safeAmount;
    player.currentBet += safeAmount;
    _pot += safeAmount;
    if (player.currentBet > _highestBet) {
      _highestBet = player.currentBet;
    }
  }

  int _requiredToCall(GamePlayer player) => (_highestBet - player.currentBet).clamp(0, 999999);

  void _checkRoundEnd() {
    final alive = _players.where((p) => !p.folded).toList();
    if (alive.length <= 1) {
      _settle(alive.first);
      return;
    }

    final allMatched = alive.every((p) => p.currentBet == _highestBet || p.coins == 0);
    if (allMatched) {
      final winner = alive.reduce((a, b) => _logic.compareHands(a.cards, b.cards) >= 0 ? a : b);
      _settle(winner);
    }
  }

  void _settle(GamePlayer winner) {
    final humanWon = winner.isHuman;
    winner.coins += _pot;
    final frames = humanWon
        ? List.generate(4, (i) => 'assets/m3/anim/anim_win_${(i + 1).toString().padLeft(2, '0')}.png')
        : List.generate(4, (i) => 'assets/m3/anim/anim_lose_${(i + 1).toString().padLeft(2, '0')}.png');
    unawaited(humanWon ? AudioService.instance.playWin() : AudioService.instance.playLose());
    unawaited(AudioService.instance.playFlip());

    setState(() {
      _settled = true;
      _status = '${winner.name} 赢下本局，收走 $_pot 蘑菇币！';
      _pot = 0;
      _round += 1;
      _resultFrames = frames;
      _resultFrameIndex = 0;
    });

    _resultTimer?.cancel();
    _resultTimer = Timer.periodic(const Duration(milliseconds: 140), (timer) {
      if (!mounted || _resultFrames == null) {
        timer.cancel();
        return;
      }
      if (_resultFrameIndex >= _resultFrames!.length - 1) {
        timer.cancel();
        return;
      }
      setState(() => _resultFrameIndex++);
    });
  }

  Widget _avatar(String asset, {double size = 54}) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size,
            height: size,
            color: const Color(0xFFFFCC80),
            alignment: Alignment.center,
            child: const Text('🍄'),
          ),
        ),
      ),
    );
  }

  Widget _seat(GamePlayer player, {bool reveal = true}) {
    final hand = _logic.evaluate(player.cards);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: player.folded ? Colors.black26 : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: player.isHuman ? const Color(0xFFFBC02D) : const Color(0xFF8D6E63), width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _avatar(player.avatarAsset),
          const SizedBox(height: 8),
          Text(player.name, style: const TextStyle(fontWeight: FontWeight.w900)),
          Text('蘑菇币 ${player.coins}', style: const TextStyle(fontSize: 12)),
          if (player.looked || player.isHuman || _settled)
            Text(hand.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: player.cards
                .map((card) => reveal || _settled || player.isHuman ? MarioCard(card: card) : MarioCard(card: card, faceDown: true))
                .toList(),
          ),
          const SizedBox(height: 6),
          Text(player.folded ? '已弃牌' : '当前下注 ${player.currentBet}', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final human = _players.last;
    return Scaffold(
      appBar: AppBar(
        title: const Text('马里奥炸金花牌桌'),
        actions: [
          IconButton(onPressed: _startRound, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: PixelPanel(
                  color: const Color(0xFFFFF8E1),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(child: Text(_status, style: const TextStyle(fontWeight: FontWeight.w700))),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/m2/coin_gold.png',
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.monetization_on),
                        ),
                        const SizedBox(width: 4),
                        Text('奖池 $_pot', style: const TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(top: 12, left: 18, right: 18, child: Center(child: _seat(_players[1], reveal: false))),
                    Positioned(top: 190, left: 10, child: SizedBox(width: 180, child: _seat(_players[0], reveal: false))),
                    Positioned(bottom: 12, left: 12, right: 12, child: _seat(human)),
                    Center(
                      child: Container(
                        width: 180,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade700.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(color: const Color(0xFFFDD835), width: 4),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/m2/star_icon.png',
                              width: 28,
                              height: 28,
                              errorBuilder: (context, error, stackTrace) => const Text('⭐', style: TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(height: 4),
                            Text('筹码池 $_pot', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                            Text('最高下注 $_highestBet', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                    if (_dealing)
                      const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            child: Text('发牌中...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ),
                    if (_resultFrames != null)
                      Center(
                        child: Image.asset(
                          _resultFrames![_resultFrameIndex],
                          width: 260,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
              ),
              PixelPanel(
                color: const Color(0xFFFFF3E0),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('你的蘑菇币：${human.coins}', style: const TextStyle(fontWeight: FontWeight.w900)),
                          Text('房间：初级场 1-2 币', style: TextStyle(color: Colors.brown.shade700, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GameActionButton(label: '看牌', assetPath: 'assets/m2/btn_check.png', onTap: () => unawaited(_humanAction(AiActionType.check))),
                          GameActionButton(label: '跟注', assetPath: 'assets/m2/btn_call.png', onTap: () => unawaited(_humanAction(AiActionType.call))),
                          GameActionButton(label: '加注', assetPath: 'assets/m2/btn_raise.png', onTap: () => unawaited(_humanAction(AiActionType.raise))),
                          GameActionButton(label: '弃牌', assetPath: 'assets/m2/btn_fold.png', onTap: () => unawaited(_humanAction(AiActionType.fold))),
                        ],
                      ),
                      if (_settled)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: FilledButton.icon(
                            onPressed: _startRound,
                            icon: const Icon(Icons.replay_rounded),
                            label: const Text('下一局'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
