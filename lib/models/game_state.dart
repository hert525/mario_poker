import '../services/zhajinhua_logic.dart';
import 'game_player.dart';

enum PlayerAction { call, raise, fold, check, allIn }

enum GamePhase { waiting, betting, showdown, finished }

enum RoomLevel {
  grassland(name: '草原场', minBet: 1, maxBet: 2, minEntry: 50),
  castle(name: '城堡场', minBet: 5, maxBet: 10, minEntry: 200),
  volcano(name: '岩浆场', minBet: 50, maxBet: 100, minEntry: 2000),
  star(name: '星星场', minBet: 200, maxBet: 500, minEntry: 10000);

  final String name;
  final int minBet;
  final int maxBet;
  final int minEntry;
  const RoomLevel({required this.name, required this.minBet, required this.maxBet, required this.minEntry});
}

class GameState {
  GameState({required this.players, required this.room});

  final List<GamePlayer> players;
  final RoomLevel room;
  final ZhajinhuaLogic _logic = ZhajinhuaLogic();

  GamePhase phase = GamePhase.waiting;
  int pot = 0;
  int currentBet = 0;
  int currentPlayerIndex = 0;

  GamePlayer get currentPlayer => players[currentPlayerIndex];
  List<GamePlayer> get activePlayers => players.where((p) => !p.folded && p.coins >= 0).toList();

  void startNewRound() {
    final hands = _logic.dealHands(playerCount: players.length);
    for (var i = 0; i < players.length; i++) {
      players[i].resetForRound(hands[i]);
      players[i].coins -= room.minBet;
      players[i].currentBet = room.minBet;
    }
    pot = players.length * room.minBet;
    currentBet = room.minBet;
    currentPlayerIndex = 0;
    phase = GamePhase.betting;
  }

  String? doAction(PlayerAction action, {int raiseAmount = 0}) {
    final player = currentPlayer;
    switch (action) {
      case PlayerAction.check:
        player.looked = true;
      case PlayerAction.call:
        final need = (currentBet - player.currentBet).clamp(0, 999999);
        player.coins -= need;
        player.currentBet += need;
        pot += need;
      case PlayerAction.raise:
        final target = raiseAmount > currentBet ? raiseAmount : currentBet + room.minBet;
        final need = target - player.currentBet;
        player.coins -= need;
        player.currentBet = target;
        currentBet = target;
        pot += need;
      case PlayerAction.fold:
        player.folded = true;
      case PlayerAction.allIn:
        pot += player.coins;
        player.currentBet += player.coins;
        player.coins = 0;
    }
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    if (activePlayers.length <= 1) {
      phase = GamePhase.finished;
    }
    return null;
  }
}
