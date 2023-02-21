import 'package:hello/data/data.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberTextField extends StatelessWidget {
  const PhoneNumberTextField({
    super.key,
    required this.countryCode,
    required this.saveCountryCode,
    required this.savePhoneNumber,
  });

  final String countryCode;
  final void Function(String?) saveCountryCode;
  final void Function(String) savePhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: 0.5 * kPadding,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(kBorderRadius),
              ),
              side: BorderSide(
                color: kPrimaryColor,
                width: kLineThickness,
              ),
            ),
          ),
          child: DropdownButton<String>(
            value: countryCode,
            onChanged: saveCountryCode,
            alignment: Alignment.center,
            underline: SizedBox(),
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadius),
            ),
            menuMaxHeight: 500.0,
            items: countryCodes
                .map(
                  (code) => DropdownMenuItem<String>(
                    value: code,
                    child: Text(code),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(width: 0.25 * kPadding),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Phone number',
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.phone,
            onChanged: savePhoneNumber,
          ),
        ),
      ],
    );
  }
}
