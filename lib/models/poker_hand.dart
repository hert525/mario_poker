import 'playing_card.dart';

enum HandRank {
  highCard('散牌', 1),
  pair('对子', 2),
  straight('顺子', 3),
  flush('同花', 4),
  straightFlush('同花顺', 5),
  threeOfKind('豹子', 6);

  const HandRank(this.label, this.weight);
  final String label;
  final int weight;
}

class PokerHand {
  const PokerHand({
    required this.cards,
    required this.rank,
    required this.tieBreakers,
  });

  final List<PlayingCard> cards;
  final HandRank rank;
  final List<int> tieBreakers;

  String get title => rank.label;
}
