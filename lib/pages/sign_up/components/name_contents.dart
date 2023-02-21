import 'package:flutter/material.dart';
import 'package:hello/pages/common/name_text_field.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class NameContents extends StatelessWidget {
  const NameContents({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Provide your name.',
          style: TextStyle(
            fontSize: 15.0,
            color: kNeutralColors[0],
          ),
        ),
        SizedBox(height: 0.5 * kPadding),
        NameTextField(controller: controller),
      ],
    );
  }
}
