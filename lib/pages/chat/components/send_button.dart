import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(0.35 * kPadding),
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: CircleBorder(),
          shadows: [
            BoxShadow(
              color: kNeutralColors[0].withOpacity(0.5),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_forward_ios,
          color: kNeutralColors[1],
          size: 25.0,
        ),
      ),
    );
  }
}
