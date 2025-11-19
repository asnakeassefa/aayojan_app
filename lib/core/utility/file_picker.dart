import 'dart:developer';
import 'dart:io';

import 'package:aayojan/core/errors/exceptions.dart';
import 'package:aayojan/core/utility/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../theme/custom_colors.dart';

Future<File?> getFileName() async {
  log('called');
  FilePickerResult? image = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  );

  // if file type is 'jpg', 'jpeg', 'png' then use
  if (image != null &&
      (image.files.single.path!.split('.').last == 'jpg' ||
          image.files.single.path!.split('.').last == 'jpeg' ||
          image.files.single.path!.split('.').last == 'png')) {
    final filePath = image.files.single.path!;
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: filePath, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: CustomColors.primary,
        toolbarWidgetColor: CustomColors.bgLight,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ],
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
        ],
      ),
    ]);
    if (await isImageFile(croppedFile!.path)) {
      log('it is image');

      File file = File(croppedFile.path);
      if (await file.length() > 2 * 1024 * 1024) {
        throw ClientException(message: 'File size exceeds 2MB');
      }
      return file;
    } else {
      log('it is not image');
      throw Exception('Selected file is not an image');
    }
  } else {
    return null;
  }
}

Future<File?> getCsvFileName() async {
  log('called');
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
    // allowedExtensions: ['csv'],
    allowMultiple: false,
  );
  // check for the size not exceeding 5MB

  if (result != null) {
    if (result.files.single.size > 2 * 1024 * 1024) {
      throw ClientException(message: 'File size exceeds 5MB');
    }
    File file = File(result.files.single.path!);
    // check for the type and if it is not csv throw exception.
    if (file.path.split('.').last != 'csv' &&
        file.path.split('.').last != 'xlsx' &&
        file.path.split('.').last != 'xls') {
      throw ClientException(message: 'Selected file is not supported');
    }
    return file;
  } else {
    return null;
  }
}
