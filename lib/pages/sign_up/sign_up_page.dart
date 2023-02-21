import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello/data/data.dart';
import 'package:hello/helpers/validation_helpers.dart';
import 'package:hello/pages/sign_up/components/form_controller.dart';
import 'package:hello/pages/sign_up/components/image_contents.dart';
import 'package:hello/pages/sign_up/components/name_contents.dart';
import 'package:hello/pages/sign_up/components/phone_number_contents.dart';
import 'package:hello/pages/sms_code/sms_code_page.dart';
import 'package:hello/utils/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = 'sign-up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _countryCode = defaultCountryCode;
  var _phoneNumber = '';
  final _nameController = TextEditingController();
  File? _image;

  var _formPosition = 0;

  void _saveCountryCode(String? value) {
    _countryCode = value ?? defaultCountryCode;
    setState(() {});
  }

  void _savePhoneNumber(String value) {
    _phoneNumber = value.trim();
  }

  void _saveImage(File value) {
    _image = value;
    setState(() {});
  }

  void _deleteImage() {
    _image = null;
    setState(() {});
  }

  void _formBackward() {
    if (_formPosition > 0) {
      _formPosition--;
    }
    setState(() {});
  }

  void _formForward() {
    if (_formPosition == 0 &&
            !ValidationHelpers.validateCountryCode(context, _countryCode) ||
        !ValidationHelpers.validatePhoneNumber(context, _phoneNumber)) {
      return;
    }
    if (_formPosition == 1 &&
        !ValidationHelpers.validateName(context, _nameController.text.trim())) {
      return;
    }
    if (_formPosition < 2) {
      _formPosition++;
    }
    setState(() {});
  }

  void _submitForm() {
    Navigator.of(context).pushNamed(
      SmsCodePage.routeName,
      arguments: [
        SmsCodePageMode.signUp,
        '$_countryCode$_phoneNumber',
        _nameController.text.trim(),
        _image,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign up'),
        ),
        body: Padding(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            children: [
              _formPosition == 0
                  ? PhoneNumberContents(
                      countryCode: _countryCode,
                      saveCountryCodeHandler: _saveCountryCode,
                      savePhoneNumberHandler: _savePhoneNumber,
                    )
                  : _formPosition == 1
                      ? NameContents(
                          controller: _nameController,
                        )
                      : ImageContents(
                          image: _image,
                          saveImageHandler: _saveImage,
                          deleteImageHandler: _deleteImage,
                        ),
              Spacer(),
              if (_formPosition == 2)
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Send OTP',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              SizedBox(height: kPadding),
              FormController(
                formPosition: _formPosition,
                backwardHandler: _formBackward,
                forwardHandler: _formForward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
