import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello/models/auth_model.dart';
import 'package:hello/pages/common/loading_indicator.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/pages/sms_code/components/resend_sms_code_button.dart';
import 'package:hello/pages/sms_code/components/sms_code_text_field.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

enum SmsCodePageMode {
  signIn,
  signUp,
  updatePhoneNumber,
}

class SmsCodePage extends StatefulWidget {
  const SmsCodePage({super.key});

  static const routeName = 'sms-code';

  @override
  State<SmsCodePage> createState() => _SmsCodePageState();
}

class _SmsCodePageState extends State<SmsCodePage> {
  late final SmsCodePageMode _mode;
  late final String _phoneNumber;
  late final String _name;
  late final File? _image;

  final _formKey = GlobalKey<FormState>();
  var _smsCodeError = false;

  var _isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await FirebaseServices.sendVerificationCode(
        context: context,
        phoneNumber: _phoneNumber,
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    _mode = arguments[0] as SmsCodePageMode;
    _phoneNumber = arguments[1] as String;
    if (_mode == SmsCodePageMode.signUp) {
      _name = arguments[2] as String;
      _image = arguments[3] as File?;
    }
    super.didChangeDependencies();
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      _smsCodeError = true;
      buildSnackBar(
        context: context,
        message: 'Please enter the verification code.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
    if (value.length != kMaxSmsCodeLength) {
      _smsCodeError = true;
      buildSnackBar(
        context: context,
        message: 'Verification code must be of $kMaxSmsCodeLength digits.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
    _smsCodeError = false;
    return null;
  }

  void _onSaved(String? value) {
    AuthModel.smsCode = value ?? '';
  }

  void _submitForm() async {
    _formKey.currentState?.validate();
    if (_smsCodeError) {
      return;
    }
    _formKey.currentState?.save();
    FocusManager.instance.primaryFocus?.unfocus();

    _isLoading = true;
    setState(() {});

    final isSuccess = await _performOperation();

    if (!isSuccess || !mounted) {
      _isLoading = false;
      setState(() {});
      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<bool> _performOperation() async {
    switch (_mode) {
      case SmsCodePageMode.signIn:
        return await FirebaseServices.signIn(context: context);
      case SmsCodePageMode.signUp:
        return await FirebaseServices.createUser(
          context: context,
          name: _name,
          image: _image,
        );
      case SmsCodePageMode.updatePhoneNumber:
        return await FirebaseServices.updatePhoneNumber(context: context);
    }
  }

  String _getText() {
    switch (_mode) {
      case SmsCodePageMode.signIn:
        return 'Sign in';
      case SmsCodePageMode.signUp:
        return 'Sign up';
      case SmsCodePageMode.updatePhoneNumber:
        return 'Confirm';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMS Code'),
        ),
        body: Padding(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            children: [
              Spacer(),
              Text(
                'Enter the verification code sent to your phone number.',
                style: TextStyle(color: kNeutralColors[0]),
              ),
              SizedBox(height: 0.5 * kPadding),
              Form(
                key: _formKey,
                child: SmsCodeTextField(
                  validator: _validator,
                  onSaved: _onSaved,
                ),
              ),
              SizedBox(height: 0.5 * kPadding),
              Align(
                alignment: Alignment.centerRight,
                child: ResendSmsCodeButton(
                  phoneNumber: _phoneNumber,
                ),
              ),
              Spacer(),
              _isLoading
                  ? LoadingIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        _getText(),
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
