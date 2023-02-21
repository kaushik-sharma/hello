import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ':(',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kNeutralColors[2],
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.5 * kPadding),
          Text(
            'Sorry, failed to load your profile. Please retry.',
            style: TextStyle(
              color: kNeutralColors[2],
              fontSize: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
