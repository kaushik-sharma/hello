import 'dart:math' as math;

import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 1.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CardLoading(
      width: width,
      height: height,
      borderRadius: BorderRadius.all(
        Radius.circular(
          borderRadius * 0.5 * math.min(width, height),
        ),
      ),
    );
  }
}
