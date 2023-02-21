import 'package:hello/pages/common/shimmer_card.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';

class ShimmerChatCard extends StatelessWidget {
  const ShimmerChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0.5 * kPadding,
        vertical: 0.3 * kPadding,
      ),
      child: Row(
        children: [
          ShimmerCard(
            width: 50.0,
            height: 50.0,
          ),
          SizedBox(width: 0.5 * kPadding),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerCard(
                      width: 200.0,
                      height: 20.0,
                    ),
                    ShimmerCard(
                      width: 50.0,
                      height: 15.0,
                    ),
                  ],
                ),
                SizedBox(height: 0.1 * kPadding),
                ShimmerCard(
                  width: 200.0,
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
