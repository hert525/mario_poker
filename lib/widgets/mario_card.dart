import 'package:flutter/material.dart';

import '../models/playing_card.dart';

class MarioCard extends StatelessWidget {
  const MarioCard({super.key, required this.card, this.faceDown = false});

  final PlayingCard card;
  final bool faceDown;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5D4037), width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: faceDown
          ? Image.asset(
              'assets/m2/card_back.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFE53935), Color(0xFF1E88E5)]),
                ),
                child: const Center(
                  child: Text('M', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                ),
              ),
            )
          : Image.asset(
              card.assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _FallbackCard(card: card),
            ),
    );
  }
}

class _FallbackCard extends StatelessWidget {
  const _FallbackCard({required this.card});

  final PlayingCard card;

  @override
  Widget build(BuildContext context) {
    final color = card.suit.isRed ? const Color(0xFFD32F2F) : const Color(0xFF263238);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.label, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(card.suit.symbol, style: TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
