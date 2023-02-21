import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello/pages/common/profile_image_selector.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class ImageContents extends StatelessWidget {
  const ImageContents({
    super.key,
    required this.image,
    required this.saveImageHandler,
    required this.deleteImageHandler,
  });

  final File? image;
  final void Function(File) saveImageHandler;
  final VoidCallback deleteImageHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Select a profile picture.',
          style: TextStyle(
            fontSize: 15.0,
            color: kNeutralColors[0],
          ),
        ),
        SizedBox(height: 0.5 * kPadding),
        ProfileImageSelector(
          imageFile: image,
          saveImageCallback: saveImageHandler,
          deleteImageCallback: deleteImageHandler,
        ),
      ],
    );
  }
}
