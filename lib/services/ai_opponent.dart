import 'dart:math';

import '../models/ai_action.dart';
import '../models/playing_card.dart';
import 'zhajinhua_logic.dart';

class AiOpponent {
  AiOpponent({Random? random}) : _random = random ?? Random();

  final Random _random;
  final ZhajinhuaLogic _logic = ZhajinhuaLogic();

  AiAction decide({
    required List<PlayingCard> cards,
    required int coins,
    required int currentBet,
    required int highestBet,
  }) {
    final hand = _logic.evaluate(cards);
    final strength = hand.rank.weight;
    final gap = highestBet - currentBet;
    final aggressionRoll = _random.nextDouble();

    if (gap > coins) {
      return const AiAction(AiActionType.fold);
    }

    if (strength >= 5 && coins > highestBet + 2 && aggressionRoll > 0.35) {
      return AiAction(AiActionType.raise, raiseAmount: gap + 2);
    }

    if (strength >= 3 && aggressionRoll > 0.15) {
      return gap > 0 ? const AiAction(AiActionType.call) : const AiAction(AiActionType.check);
    }

    if (strength == 2) {
      if (gap <= 2 || aggressionRoll > 0.55) {
        return gap > 0 ? const AiAction(AiActionType.call) : const AiAction(AiActionType.check);
      }
      return const AiAction(AiActionType.fold);
    }

    if (gap == 0 && aggressionRoll > 0.45) {
      return const AiAction(AiActionType.check);
    }

    if (gap <= 1 && aggressionRoll > 0.75) {
      return const AiAction(AiActionType.call);
    }

    return const AiAction(AiActionType.fold);
  }
}
