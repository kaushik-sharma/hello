import 'package:flutter/material.dart';
import 'package:hello/pages/common/shimmer_card.dart';
import 'package:hello/utils/constants.dart';

class ShimmerContent extends StatelessWidget {
  const ShimmerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerCard(
          width: 200.0,
          height: 200.0,
        ),
        SizedBox(height: 2.0 * kPadding),
        ShimmerCard(
          width: double.infinity,
          height: 50.0,
        ),
        SizedBox(height: kPadding),
        ShimmerCard(
          width: double.infinity,
          height: 50.0,
        ),
        Spacer(),
        Align(
          alignment: Alignment.centerLeft,
          child: ShimmerCard(
            width: 200.0,
            height: 30.0,
          ),
        ),
      ],
    );
  }
}
