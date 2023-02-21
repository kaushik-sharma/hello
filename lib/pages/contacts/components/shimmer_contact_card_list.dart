import 'package:flutter/material.dart';
import 'package:hello/pages/common/shimmer_card.dart';
import 'package:hello/utils/constants.dart';

class ShimmerContactCardList extends StatelessWidget {
  const ShimmerContactCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 20,
      itemBuilder: (context, index) => _ShimmerContactCard(),
    );
  }
}

class _ShimmerContactCard extends StatelessWidget {
  const _ShimmerContactCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.5 * kPadding,
        vertical:  0.25 * kPadding,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ShimmerCard(
          width: 50.0,
          height: 50.0,
        ),
        title: ShimmerCard(
          width: 50.0,
          height: 25.0,
        ),
      ),
    );
  }
}
