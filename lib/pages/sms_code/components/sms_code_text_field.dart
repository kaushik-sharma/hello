import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello/utils/constants.dart';

class SmsCodeTextField extends StatelessWidget {
  const SmsCodeTextField({
    super.key,
    required this.validator,
    required this.onSaved,
  });

  final String? Function(String?) validator;
  final void Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 1.5 * kPadding,
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Verification code',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(kMaxSmsCodeLength),
        ],
        keyboardType: TextInputType.number,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
