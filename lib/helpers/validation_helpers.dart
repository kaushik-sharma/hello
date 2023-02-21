import 'package:flutter/cupertino.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class ValidationHelpers {
  static bool validateCountryCode(BuildContext context, String countryCode) {
    if (countryCode.isEmpty) {
      buildSnackBar(
        context: context,
        message: 'Please select a country code.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }

  static bool validatePhoneNumber(BuildContext context, String phoneNumber) {
    if (phoneNumber.isEmpty) {
      buildSnackBar(
        context: context,
        message: 'Please enter a phone number.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    if (phoneNumber.length != 10) {
      buildSnackBar(
        context: context,
        message: 'Phone number must be of 10 digits.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }

  static bool validateName(BuildContext context, String name) {
    if (name.isEmpty) {
      buildSnackBar(
        context: context,
        message: 'Please provide a name.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    if (name.length > kMaxUserNameLength) {
      buildSnackBar(
        context: context,
        message: 'Max length allowed is $kMaxUserNameLength characters.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }
}
