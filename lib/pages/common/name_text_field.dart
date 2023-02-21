import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameTextField extends StatefulWidget {
  const NameTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  @override
  Widget build(BuildContext context) {
    final name = widget.controller.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: 'Name'),
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          inputFormatters: [
            LengthLimitingTextInputFormatter(kMaxUserNameLength),
          ],
          controller: widget.controller,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: 0.25 * kPadding),
        Text(
          '${name.length} / $kMaxUserNameLength',
          style: TextStyle(color: kNeutralColors[2]),
        ),
      ],
    );
  }
}
