import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraServices {
  static Future<CroppedFile?> _cropImage(
    BuildContext context,
    String imagePath,
  ) async {
    try {
      return await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: kScaffoldBackgroundColor,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
        ],
      );
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to crop image. Please retry.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
  }

  static Future<File?> pickImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        return null;
      }

      final pickedImage = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );
      if (pickedImage == null) {
        return null;
      }

      final croppedFile = await _cropImage(context, pickedImage.path);
      if (croppedFile == null) {
        return null;
      }

      if (source == ImageSource.gallery) {
        final fileSize = (await File(croppedFile.path).stat()).size;
        if (fileSize / 1024 / 1024 > kMaxUserImageFileSize) {
          buildSnackBar(
            context: context,
            message: 'Max image file size allowed is $kMaxUserImageFileSize MB.',
            backgroundColor: kErrorColor,
          );
          return null;
        }
      }

      return File(croppedFile.path);
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to pick image. Please retry.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
  }
}
