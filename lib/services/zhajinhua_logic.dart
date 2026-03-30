import 'dart:math';

import '../models/playing_card.dart';
import '../models/poker_hand.dart';

class ZhajinhuaLogic {
  final Random _random = Random();

  List<PlayingCard> createDeck() {
    final deck = <PlayingCard>[];
    for (final suit in Suit.values) {
      for (var rank = 2; rank <= 14; rank++) {
        deck.add(PlayingCard(rank: rank, suit: suit));
      }
    }
    return deck;
  }

  List<List<PlayingCard>> dealHands({int playerCount = 3}) {
    final deck = createDeck()..shuffle(_random);
    return List.generate(
      playerCount,
      (player) => List.generate(3, (index) => deck[player * 3 + index]),
    );
  }

  PokerHand evaluate(List<PlayingCard> cards) {
    assert(cards.length == 3, '炸金花必须是三张牌');

    final sortedRanks = cards.map((c) => c.rank).toList()..sort();
    final descRanks = sortedRanks.reversed.toList();
    final sameSuit = cards.every((c) => c.suit == cards.first.suit);
    final counts = <int, int>{};
    for (final rank in sortedRanks) {
      counts[rank] = (counts[rank] ?? 0) + 1;
    }

    final isThree = counts.length == 1;
    final isStraight = _isStraight(sortedRanks);

    if (isThree) {
      return PokerHand(
        cards: cards,
        rank: HandRank.threeOfKind,
        tieBreakers: [sortedRanks.first],
      );
    }

    if (sameSuit && isStraight) {
      return PokerHand(
        cards: cards,
        rank: HandRank.straightFlush,
        tieBreakers: [_straightHigh(sortedRanks)],
      );
    }

    if (sameSuit) {
      return PokerHand(
        cards: cards,
        rank: HandRank.flush,
        tieBreakers: descRanks,
      );
    }

    if (isStraight) {
      return PokerHand(
        cards: cards,
        rank: HandRank.straight,
        tieBreakers: [_straightHigh(sortedRanks)],
      );
    }

    if (counts.length == 2) {
      final pairRank = counts.entries.firstWhere((e) => e.value == 2).key;
      final kicker = counts.entries.firstWhere((e) => e.value == 1).key;
      return PokerHand(
        cards: cards,
        rank: HandRank.pair,
        tieBreakers: [pairRank, kicker],
      );
    }

    return PokerHand(
      cards: cards,
      rank: HandRank.highCard,
      tieBreakers: descRanks,
    );
  }

  int compareHands(List<PlayingCard> a, List<PlayingCard> b) {
    final handA = evaluate(a);
    final handB = evaluate(b);

    if (handA.rank.weight != handB.rank.weight) {
      return handA.rank.weight.compareTo(handB.rank.weight);
    }

    for (var i = 0; i < min(handA.tieBreakers.length, handB.tieBreakers.length); i++) {
      if (handA.tieBreakers[i] != handB.tieBreakers[i]) {
        return handA.tieBreakers[i].compareTo(handB.tieBreakers[i]);
      }
    }

    return 0;
  }

  int winnerIndex(List<List<PlayingCard>> hands) {
    var bestIndex = 0;
    for (var i = 1; i < hands.length; i++) {
      if (compareHands(hands[i], hands[bestIndex]) > 0) {
        bestIndex = i;
      }
    }
    return bestIndex;
  }

  bool _isStraight(List<int> sortedRanks) {
    if (sortedRanks[0] == 2 && sortedRanks[1] == 3 && sortedRanks[2] == 14) {
      return true;
    }
    return sortedRanks[1] == sortedRanks[0] + 1 && sortedRanks[2] == sortedRanks[1] + 1;
  }

  int _straightHigh(List<int> sortedRanks) {
    if (sortedRanks[0] == 2 && sortedRanks[1] == 3 && sortedRanks[2] == 14) {
      return 3;
    }
    return sortedRanks.last;
  }
}
