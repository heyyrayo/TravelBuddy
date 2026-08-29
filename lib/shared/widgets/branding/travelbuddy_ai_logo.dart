import 'package:flutter/material.dart';

class TravelBuddyAiLogo extends StatelessWidget {
  const TravelBuddyAiLogo({
    super.key,
    required this.size,
    this.semanticLabel = 'TravelBuddy AI',
  });

  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: Image.asset(
        'assets/images/travelbuddy_ai_logo_transparent.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
