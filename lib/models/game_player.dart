import 'playing_card.dart';

class GamePlayer {
  GamePlayer({
    required this.name,
    required this.avatarAsset,
    required this.isHuman,
    required this.seat,
    this.coins = 100,
  });

  final String name;
  final String avatarAsset;
  final bool isHuman;
  final int seat;
  int coins;
  bool folded = false;
  bool looked = false;
  int currentBet = 0;
  List<PlayingCard> cards = const [];

  void resetForRound(List<PlayingCard> newCards) {
    cards = newCards;
    folded = false;
    looked = false;
    currentBet = 0;
  }
}
