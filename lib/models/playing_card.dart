enum Suit { spade, heart, club, diamond }

extension SuitLabel on Suit {
  String get symbol => switch (this) {
        Suit.spade => '♠',
        Suit.heart => '♥',
        Suit.club => '♣',
        Suit.diamond => '♦',
      };

  bool get isRed => this == Suit.heart || this == Suit.diamond;
}

class PlayingCard {
  const PlayingCard({required this.rank, required this.suit});

  final int rank; // 2-14 where 14 = A
  final Suit suit;

  String get rankCode {
    const rankMap = {
      11: 'J',
      12: 'Q',
      13: 'K',
      14: 'A',
    };
    return '${rankMap[rank] ?? rank}';
  }

  String get suitCode => switch (suit) {
        Suit.club => 'C',
        Suit.diamond => 'D',
        Suit.heart => 'H',
        Suit.spade => 'S',
      };

  String get assetPath => 'assets/m3/cards/deck/$rankCode$suitCode.png';

  String get label => '$rankCode${suit.symbol}';

  @override
  String toString() => label;
}
