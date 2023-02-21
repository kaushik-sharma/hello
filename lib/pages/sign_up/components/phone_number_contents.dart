import 'package:flutter/material.dart';
import 'package:hello/pages/common/phone_number_text_field.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class PhoneNumberContents extends StatelessWidget {
  const PhoneNumberContents({super.key,
    required this.countryCode,
    required this.saveCountryCodeHandler,
    required this.savePhoneNumberHandler,
  });
  
  final String countryCode;
  final void Function(String?) saveCountryCodeHandler;
  final void Function(String ) savePhoneNumberHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, let\'s create your account.',
          style: TextStyle(
            fontSize: 36.0,
            color: kNeutralColors[2],
          ),
        ),
        SizedBox(height: 80.0),
        Text(
          'Start by typing your phone number.',
          style: TextStyle(
            fontSize: 15.0,
            color: kNeutralColors[0],
          ),
        ),
        SizedBox(height: 0.5 * kPadding),
        PhoneNumberTextField(
          countryCode: countryCode,
          saveCountryCode: saveCountryCodeHandler,
          savePhoneNumber: savePhoneNumberHandler ,
        ),
      ],
    );
  }
}
