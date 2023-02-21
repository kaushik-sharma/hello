import 'package:flutter/material.dart';
import 'package:hello/data/data.dart';
import 'package:hello/pages/common/loading_indicator.dart';
import 'package:hello/pages/common/material_banner.dart';
import 'package:hello/pages/common/name_text_field.dart';
import 'package:hello/pages/common/phone_number_text_field.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/pages/sms_code/sms_code_page.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

enum DetailsEditorDialogMode {
  name,
  phoneNumber,
}

class DetailsEditorDialog extends StatefulWidget {
  const DetailsEditorDialog({
    super.key,
    required this.mode,
  });

  final DetailsEditorDialogMode mode;

  @override
  State<DetailsEditorDialog> createState() => _DetailsEditorDialogState();
}

class _DetailsEditorDialogState extends State<DetailsEditorDialog> {
  var _isLoading = false;

  final _nameController = TextEditingController();
  var _countryCode = defaultCountryCode;
  var _phoneNumber = '';

  bool _verifyName(String name) {
    if (name.isEmpty) {
      buildMaterialBanner(
        context: context,
        message: 'Please provide a name.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    if (name.length > kMaxUserNameLength) {
      buildMaterialBanner(
        context: context,
        message: 'Max length allowed is $kMaxUserNameLength characters.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }

  bool _verifyCountryCode() {
    if (_countryCode.isEmpty) {
      buildMaterialBanner(
        context: context,
        message: 'Please provide a country code.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }

  bool _verifyPhoneNumber() {
    if (_phoneNumber.isEmpty) {
      buildMaterialBanner(
        context: context,
        message: 'Please provide a phone number.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    if (_phoneNumber.length != 10) {
      buildMaterialBanner(
        context: context,
        message: 'Phone number must be of 10 digits.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }

  void _saveCountryCode(String? value) {
    _countryCode = value ?? defaultCountryCode;
    setState(() {});
  }

  void _savePhoneNumber(String value) {
    _phoneNumber = value.trim();
  }

  Future<void> _updateName() async {
    final name = _nameController.text.trim();
    if (!_verifyName(name)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    final isSuccess = await FirebaseServices.updateName(
      context: context,
      name: name,
    );
    if (!isSuccess) {
      return;
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _updatePhoneNumber() async {
    if (!_verifyCountryCode()) {
      return;
    }
    if (!_verifyPhoneNumber()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    final phoneNumber = '$_countryCode$_phoneNumber';

    final isRegistered = await FirebaseServices.isPhoneNumberRegistered(
      context: context,
      phoneNumber: phoneNumber,
    );

    if (isRegistered == null) {
      return;
    }

    if (isRegistered) {
      buildSnackBar(
        context: context,
        message:
            'This phone number is already registered with a different user.',
        backgroundColor: kErrorColor,
      );
      return;
    }

    if (!mounted) {
      return;
    }
    Navigator.of(context).pushNamed(
      SmsCodePage.routeName,
      arguments: [
        SmsCodePageMode.updatePhoneNumber,
        phoneNumber,
      ],
    );
  }

  void _confirmHandler() async {
    _isLoading = true;
    setState(() {});

    switch (widget.mode) {
      case DetailsEditorDialogMode.name:
        await _updateName();
        break;
      case DetailsEditorDialogMode.phoneNumber:
        await _updatePhoneNumber();
        break;
    }

    _isLoading = false;
    setState(() {});
  }

  String _getTitle() {
    switch (widget.mode) {
      case DetailsEditorDialogMode.name:
        return 'Type a new name';
      case DetailsEditorDialogMode.phoneNumber:
        return 'Type a new phone number';
    }
  }

  Widget _getEditorWidget() {
    switch (widget.mode) {
      case DetailsEditorDialogMode.name:
        return NameTextField(controller: _nameController);
      case DetailsEditorDialogMode.phoneNumber:
        return PhoneNumberTextField(
          countryCode: _countryCode,
          saveCountryCode: _saveCountryCode,
          savePhoneNumber: _savePhoneNumber,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(0.5 * kPadding),
        child: _isLoading
            ? LoadingIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getTitle(),
                    style: TextStyle(
                      color: kNeutralColors[0],
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 0.5 * kPadding),
                  _getEditorWidget(),
                  SizedBox(height: kPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _CancelButton(),
                      _ConfirmButton(onTap: _confirmHandler),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        foregroundColor: kNeutralColors[1],
        padding: EdgeInsets.symmetric(
          horizontal: 0.5 * kPadding,
          vertical: 0.25 * kPadding,
        ),
      ),
      onPressed: onTap,
      child: Text(
        'Confirm',
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 0.0,
        backgroundColor: kNeutralColors[1],
        foregroundColor: kErrorColor,
        padding: EdgeInsets.symmetric(
          horizontal: 0.5 * kPadding,
          vertical: 0.25 * kPadding,
        ),
      ),
      onPressed: Navigator.of(context).pop,
      child: Text(
        'Cancel',
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }
}
