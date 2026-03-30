import 'package:flutter_test/flutter_test.dart';
import 'package:mario_poker/models/playing_card.dart';
import 'package:mario_poker/services/zhajinhua_logic.dart';

void main() {
  final logic = ZhajinhuaLogic();

  test('豹子大于同花顺', () {
    final three = [
      const PlayingCard(rank: 9, suit: Suit.spade),
      const PlayingCard(rank: 9, suit: Suit.heart),
      const PlayingCard(rank: 9, suit: Suit.club),
    ];
    final straightFlush = [
      const PlayingCard(rank: 10, suit: Suit.heart),
      const PlayingCard(rank: 11, suit: Suit.heart),
      const PlayingCard(rank: 12, suit: Suit.heart),
    ];

    expect(logic.compareHands(three, straightFlush), greaterThan(0));
  });

  test('A23 识别为顺子', () {
    final hand = [
      const PlayingCard(rank: 14, suit: Suit.spade),
      const PlayingCard(rank: 2, suit: Suit.heart),
      const PlayingCard(rank: 3, suit: Suit.club),
    ];

    expect(logic.evaluate(hand).title, '顺子');
  });

  test('对子按对子点数比较', () {
    final pairA = [
      const PlayingCard(rank: 8, suit: Suit.spade),
      const PlayingCard(rank: 8, suit: Suit.heart),
      const PlayingCard(rank: 13, suit: Suit.club),
    ];
    final pairB = [
      const PlayingCard(rank: 7, suit: Suit.spade),
      const PlayingCard(rank: 7, suit: Suit.diamond),
      const PlayingCard(rank: 14, suit: Suit.club),
    ];

    expect(logic.compareHands(pairA, pairB), greaterThan(0));
  });
}
