import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: ShapeDecoration(
          color: kNeutralColors[1],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1.5 * kBorderRadius),
            ),
          ),
          shadows: [
            BoxShadow(
              color: kNeutralColors[0].withOpacity(0.25),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: TextFormField(
          decoration: InputDecoration(
            enabledBorder: buildOutlineInputBorder(),
            focusedBorder: buildOutlineInputBorder(),
            errorBorder: buildOutlineInputBorder(),
            focusedErrorBorder: buildOutlineInputBorder(),
            hintStyle: TextStyle(color: kNeutralColors[2]),
            errorStyle: TextStyle(color: kErrorColor),
            contentPadding: EdgeInsets.all(0.5 * kPadding),
            hintText: 'Type a message...',
          ),
          textCapitalization: TextCapitalization.sentences,
          minLines: 1,
          maxLines: 5,
          controller: controller,
        ),
      ),
    );
  }
}
