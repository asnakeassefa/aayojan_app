import 'dart:developer';

// import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:aayojan/core/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

Future<String> imagePicker() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);

  // check for image size
  if (image != null) {
    final file = await image.readAsBytes();
    final sizeInBytes = file.length;
    final sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb > 2) {
      throw Exception('Image size exceeds 2MB');
    }
  }

  if (image != null) {
    final filePath = image.path;
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
      return croppedFile.path;
    } else {
      log('it is not image');
      throw Exception('Selected file is not an image');
    }
  } else {
    log('NO image');
    throw Exception("No image selected");
  }
}

// Future<String> imagePicker() async {
//   // final permission = await Permission.photos.request();
//   final permission = await Permission.storage.request();

//   if (permission.isGranted) {
//     final picker = HLImagePicker();
//     List images = await picker.openPicker(
//         cropping: true,
//         localized: LocalizedImagePicker(
//           doneText: 'Done',
//         ),
//         pickerOptions: HLPickerOptions(
//           maxSelectedAssets: 1,
//         ));
//     if (images.isNotEmpty) {
//       final image = images[0];
//       if (image != null) {
//         final filePath = image;
//         if (await isImageFile(filePath)) {
//           log('it is image');
//           return image;
//         } else {
//           log('it is not image');
//           throw Exception('Selected file is not an image');
//         }
//       } else {
//         log('NO image');
//         throw Exception("No image selected");
//       }
//     } else {
//       log('NO image');
//       throw Exception("No image selected");
//     }
//   } else {
//     throw Exception("Permission not granted");
//   }
// }

Future<String> imagePickerFromCamera() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    final filePath = image.path;
    if (await isImageFile(filePath)) {
      log('it is image');
      return image.path;
    } else {
      log('it is not image');
      throw Exception('Selected file is not an image');
    }
  } else {
    log('NO image');
    throw Exception("No image selected");
  }
}

Future<XFile?> pickVideo() async {
  final picker = ImagePicker();
  final image = await picker.pickVideo(source: ImageSource.gallery);
  if (image != null) {
    final filePath = image.path;
    if (await isVideoFile(filePath)) {
      return image;
    } else {
      // Handle non-image file selection
      throw Exception('Selected file is not an Video');
    }
  }
  throw Exception('Selected file is not an Video');
}

// Same isImageFile function from previous example
Future<bool> isImageFile(String filePath) async {
  final extension = filePath.split('.').last.toLowerCase();
  final validExtensions = ['jpg', 'png', 'jpeg', 'bmp', 'gif'];
  return validExtensions.contains(extension);
}

Future<bool> isVideoFile(String filePath) async {
  final extension = filePath.split('.').last.toLowerCase();
  final validExtensions = ['mp4', 'avi', 'mkv', 'mov', 'flv'];
  return validExtensions.contains(extension);
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
