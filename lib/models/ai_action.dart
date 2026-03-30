enum AiActionType { check, call, raise, fold }

class AiAction {
  const AiAction(this.type, {this.raiseAmount = 0});

  final AiActionType type;
  final int raiseAmount;
}
