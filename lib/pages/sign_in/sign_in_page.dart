import 'package:flutter/material.dart';
import 'package:hello/data/data.dart';
import 'package:hello/helpers/validation_helpers.dart';
import 'package:hello/pages/common/loading_indicator.dart';
import 'package:hello/pages/common/phone_number_text_field.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/pages/sign_up/sign_up_page.dart';
import 'package:hello/pages/sms_code/sms_code_page.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = 'sign-in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _countryCode = defaultCountryCode;
  var _phoneNumber = '';
  var _isLoading = false;

  void _saveCountryCode(String? value) {
    _countryCode = value ?? defaultCountryCode;
    setState(() {});
  }

  void _savePhoneNumber(String value) {
    _phoneNumber = value.trim();
  }

  void _submitForm() async {
    if (!ValidationHelpers.validateCountryCode(context, _countryCode)) {
      return;
    }
    if (!ValidationHelpers.validatePhoneNumber(context, _phoneNumber)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    final phoneNumber = '$_countryCode$_phoneNumber';

    _isLoading = true;
    setState(() {});

    final isRegistered = await FirebaseServices.isPhoneNumberRegistered(
      context: context,
      phoneNumber: phoneNumber,
    );

    _isLoading = false;
    setState(() {});

    if (isRegistered == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    if (!isRegistered) {
      buildSnackBar(
        context: context,
        message: 'Please create an account to sign in.',
        backgroundColor: kErrorColor,
      );
      return;
    }

    Navigator.of(context).pushNamed(
      SmsCodePage.routeName,
      arguments: [
        SmsCodePageMode.signIn,
        phoneNumber,
      ],
    );
  }

  void _gotoSignUpPage() {
    Navigator.of(context).pushNamed(
      SignUpPage.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(kPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/images/app-logo.png',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                PhoneNumberTextField(
                  countryCode: _countryCode,
                  saveCountryCode: _saveCountryCode,
                  savePhoneNumber: _savePhoneNumber,
                ),
                _isLoading
                    ? LoadingIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text(
                              'Send OTP',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          SizedBox(height: 0.5 * kPadding),
                          TextButton(
                            onPressed: _gotoSignUpPage,
                            child: Text('Create an account'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
