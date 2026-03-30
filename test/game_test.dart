import 'package:flutter_test/flutter_test.dart';
import 'package:mario_poker/models/game_player.dart';
import 'package:mario_poker/models/game_state.dart';
import 'package:mario_poker/services/ai_opponent.dart';

void main() {
  late GameState game;

  setUp(() {
    final players = [
      GamePlayer(name: '玩家', avatarAsset: 'assets/avatar_mario.png', isHuman: true, seat: 0, coins: 1000),
      GamePlayer(name: 'AI-路易吉', avatarAsset: 'assets/avatar_luigi.png', isHuman: false, seat: 1, coins: 1000),
      GamePlayer(name: 'AI-桃花', avatarAsset: 'assets/avatar_peach.png', isHuman: false, seat: 2, coins: 1000),
    ];
    game = GameState(players: players, room: RoomLevel.grassland);
  });

  test('开局后所有人有手牌', () {
    game.startNewRound();
    for (final p in game.players) {
      expect(p.cards.length, 3);
    }
  });

  test('开局后底池 = 人数 x 底注', () {
    game.startNewRound();
    expect(game.pot, game.players.length * game.room.minBet);
  });

  test('AI决策不报错', () {
    game.startNewRound();
    final ai = AiOpponent();
    final decision = ai.decide(
      cards: game.players[1].cards,
      coins: game.players[1].coins,
      currentBet: game.players[1].currentBet,
      highestBet: game.currentBet,
    );
    expect(decision, isNotNull);
  });
}
