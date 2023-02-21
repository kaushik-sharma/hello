import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/helpers/image_helpers.dart';
import 'package:hello/helpers/phone_number_helpers.dart';
import 'package:hello/pages/account/components/details_editor_dialog.dart';
import 'package:hello/pages/account/components/error_message.dart';
import 'package:hello/pages/account/components/profile_text_info.dart';
import 'package:hello/pages/account/components/shimmer_content.dart';
import 'package:hello/pages/common/profile_image_selector.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  static const routeName = 'account';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? _name;
  String? _phoneNumber;
  File? _imageFile;

  var _isLoading = false;

  Future<void> _showEditorDialog(DetailsEditorDialog dialog) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialog,
    );
    setState(() {});
  }

  Future<void> _getUserInfo() async {
    final snapshot = await FirebaseServices.getUserInfo(
      context: context,
      userUid: FirebaseAuth.instance.currentUser!.uid,
    );

    final data = snapshot?.data();

    if (data == null) {
      return;
    }

    _name = data['name'] as String;
    _phoneNumber = data['phone_number'] as String;

    final imageUrl = data['profile_image_url'] as String;
    if (imageUrl.isNotEmpty) {
      _imageFile = await ImageHelpers.convertUrlToFile(imageUrl);
    }
  }

  Future<void> _saveImage(File value) async {
    _imageFile = value;
    await _updateProfileImage();
  }

  Future<void> _deleteImage() async {
    _imageFile = null;
    await _updateProfileImage();
  }

  Future<void> _updateProfileImage() async {
    _isLoading = true;
    setState(() {});
    await FirebaseServices.updateProfileImage(
      context: context,
      image: _imageFile,
    );
    _isLoading = false;
    setState(() {});
  }

  Future<void> _signOut() async {
    await FirebaseServices.setUserOnlineStatus(false);
    await FirebaseServices.signOut(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(kPadding),
        child: _isLoading
            ? ShimmerContent()
            : FutureBuilder<void>(
                future: _getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerContent();
                  }

                  if (_name == null || _phoneNumber == null) {
                    return ErrorMessage();
                  }

                  return Column(
                    children: [
                      ProfileImageSelector(
                        imageFile: _imageFile,
                        saveImageCallback: _saveImage,
                        deleteImageCallback: _deleteImage,
                      ),
                      SizedBox(height: 2.0 * kPadding),
                      ProfileTextInfo(
                        title: 'Name',
                        content: _name!,
                        editHandler: () => _showEditorDialog(
                          DetailsEditorDialog(
                            mode: DetailsEditorDialogMode.name,
                          ),
                        ),
                      ),
                      SizedBox(height: kPadding),
                      ProfileTextInfo(
                        title: 'Phone number',
                        content:
                            PhoneNumberHelpers.formatPhoneNumber(_phoneNumber!),
                        editHandler: () => _showEditorDialog(
                          DetailsEditorDialog(
                            mode: DetailsEditorDialogMode.phoneNumber,
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _signOut,
                          style: TextButton.styleFrom(
                            foregroundColor: kNeutralColors[0],
                          ),
                          icon: Icon(
                            FontAwesomeIcons.arrowRightFromBracket,
                            size: 22.0,
                          ),
                          label: Text(
                            'Sign out',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
