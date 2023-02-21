import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/services/camera_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageSelector extends StatelessWidget {
  const ProfileImageSelector({
    super.key,
    required this.imageFile,
    required this.saveImageCallback,
    required this.deleteImageCallback,
  });

  final File? imageFile;
  final void Function(File) saveImageCallback;
  final VoidCallback deleteImageCallback;

  Future<void> saveImage(BuildContext context, ImageSource source) async {
    final pickedImage = await CameraServices.pickImage(context, source);
    if (pickedImage == null) {
      return;
    }
    saveImageCallback(pickedImage);
    Navigator.of(context).pop();
  }

  Future<void> showOptions(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(0.5 * kPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OptionButton(
              onTap: () async => await saveImage(
                context,
                ImageSource.camera,
              ),
              icon: FontAwesomeIcons.cameraRetro,
              title: 'Camera',
              color: kPrimaryColor,
            ),
            _OptionButton(
              onTap: () async => await saveImage(
                context,
                ImageSource.gallery,
              ),
              icon: FontAwesomeIcons.fileImage,
              title: 'Gallery',
              color: kPrimaryColor,
            ),
            if (imageFile != null)
              _OptionButton(
                onTap: () {
                  deleteImageCallback();
                  Navigator.of(context).pop();
                },
                icon: FontAwesomeIcons.trashCan,
                title: 'Delete image',
                color: kErrorColor,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 100.0,
          backgroundColor: kNeutralColors[2],
          backgroundImage: imageFile != null
              ? FileImage(imageFile!)
              : AssetImage(
                  'assets/images/default-profile-image.png',
                ) as ImageProvider,
        ),
        Positioned(
          right: 10.0,
          bottom: 10.0,
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: kNeutralColors[1],
              shadows: [
                BoxShadow(
                  color: kNeutralColors[0].withOpacity(0.25),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: IconButton(
              onPressed: () async => await showOptions(context),
              icon: Icon(
                FontAwesomeIcons.penToSquare,
                size: 20.0,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.color,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(0.5 * kPadding),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 0.5 * kPadding),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
