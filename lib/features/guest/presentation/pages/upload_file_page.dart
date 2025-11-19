import 'dart:developer';
import 'dart:io';

import 'package:aayojan/core/errors/exceptions.dart';
import 'package:aayojan/core/theme/custom_colors.dart';
import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:aayojan/core/utility/constants.dart';
import 'package:aayojan/core/widgets/custom_button2.dart';
import 'package:aayojan/core/widgets/error_text.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_cubit.dart';
import 'package:aayojan/features/guest/presentation/bloc/guest_state.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utility/file_picker.dart';

class UploadFilePage extends StatefulWidget {
  static const routeName = '/upload_file_page';
  const UploadFilePage({super.key});

  @override
  State<UploadFilePage> createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  // download function.
//
  Future<String> saveCsvToDevice(BuildContext context) async {
    try {
      String csvData =
          await rootBundle.loadString('assets/file/person_data.csv');
      String? filePath;

      if (Platform.isAndroid) {
        // Check Android version
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.version.sdkInt >= 30) {
          // For Android 11 and above
          try {
            filePath = '/storage/emulated/0/Download/sample.csv';
            final File file = File(filePath);
            await file.writeAsString(csvData);
            log('CSV file saved to: $filePath');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('CSV file saved to Downloads folder')),
            );
            return filePath;
          } catch (e) {
            // If direct write fails, try with manage external storage permission
            var status = await Permission.manageExternalStorage.request();
            if (status.isGranted) {
              filePath = '/storage/emulated/0/Download/sample.csv';
              final File file = File(filePath);
              await file.writeAsString(csvData);
              log('CSV file saved to: $filePath');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('CSV file saved to Downloads folder')),
              );
              return filePath;
            }
          }
        } else {
          // For Android 10 and below
          var status = await Permission.storage.request();
          if (status.isGranted) {
            String downloadPath =
                await ExternalPath.getExternalStoragePublicDirectory(
                    ExternalPath.DIRECTORY_DOWNLOAD);
            filePath = '$downloadPath/sample.csv';
            final File file = File(filePath);
            await file.writeAsString(csvData);
            log('CSV file saved to: $filePath');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('CSV file saved to Downloads folder')),
            );
            return filePath;
          }
        }

        // Handle permission denied cases
        if (await Permission.storage.isPermanentlyDenied ||
            await Permission.manageExternalStorage.isPermanentlyDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Storage permission permanently denied. Please enable it in app settings.',
              ),
              action: SnackBarAction(
                label: 'Open Settings',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
          throw Exception('Storage permission permanently denied');
        }

        throw Exception('Storage permission denied');
      } else if (Platform.isIOS) {
        // iOS implementation remains the same
        Directory appDocDir = await getApplicationDocumentsDirectory();
        filePath = '${appDocDir.path}/sample.csv';
        final File file = File(filePath);
        await file.writeAsString(csvData);
        log('CSV file saved to: $filePath');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV file saved')),
        );
        return filePath;
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } catch (e) {
      log('Error saving CSV file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save CSV file: $e')),
      );
      throw Exception('Error saving CSV file: $e');
    }
  }

  String filePath = "";
  String fileName = "";
  bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GuestCubit>(),
      child: BlocConsumer<GuestCubit, GuestState>(
        listener: (context, state) {
          if (state is GuestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'File Uploaded Successfully',
                  style: CustomTypography.bodyLarge.copyWith(
                    color: CustomColors.bgLight,
                  ),
                ),
                backgroundColor: CustomColors.primary,
              ),
            );
          }

          if (state is GuestFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: CustomTypography.bodyLarge.copyWith(
                    color: CustomColors.bgLight,
                  ),
                ),
                backgroundColor: CustomColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Guests',
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * .9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Your file',
                        style: CustomTypography.headLineLarge
                            .copyWith(color: CustomColors.bgLight),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Upload your files by clicking the button below support a variety of formats, including CSV, and XLS. ",
                        style: CustomTypography.bodyLarge.copyWith(
                          color: CustomColors.bgLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButtonOut(
                        onPressed: () {
                          // pop up that shows the instructions for csv
                          // make the background color to be primary
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: CustomColors.primary,
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: CustomColors.bgLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/rounded_logo.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: Text(
                                          "Please select the particular ID for the CSV",
                                          textAlign: TextAlign.center,
                                          style: CustomTypography.bodyLarge
                                              .copyWith(
                                            color: CustomColors.bgLight,
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                        ),
                                      ),
                                      // custom table
                                      const SizedBox(height: 16),
                                      const SizedBox(
                                        height: 150,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              CustomTable(
                                                col1: "ID",
                                                col2: "Name",
                                              ),
                                              CustomTable(
                                                col1: "1",
                                                col2: "Paternal",
                                              ),
                                              CustomTable(
                                                col1: "2",
                                                col2: "Maternal",
                                              ),
                                              CustomTable(
                                                col1: "3",
                                                col2: "Friends",
                                              ),
                                              CustomTable(
                                                col1: "4",
                                                col2: "Family",
                                              ),
                                              CustomTable(
                                                col1: "5",
                                                col2: "Office",
                                              ),
                                              CustomTable(
                                                col1: "6",
                                                col2: "In-Laws Family",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).then((value) {});
                        },
                        backgroundColor:
                            CustomColors.contentPrimary.withOpacity(.3),
                        borderColor: CustomColors.bgLight,
                        content: Text(
                          "Instructions For CSV",
                          style: CustomTypography.bodyLarge.copyWith(
                            color: CustomColors.bgLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isLoading: false,
                        loadingColor: CustomColors.bgLight,
                        height: 44,
                        width: MediaQuery.sizeOf(context).width * .4,
                      ),

                      const SizedBox(height: 40),
                      IconButton(
                        onPressed: () async {
                          try {
                            File? file = await getCsvFileName();
                            if (file != null) {
                              log(file.path.toString());
                              setState(
                                () {
                                  filePath = file.path;
                                  fileName = 'File Uploaded';
                                },
                              );
                            }
                          } catch (e) {
                            if (e is ClientException) {
                              Scaffold.of(context).showBottomSheet((context) {
                                return SnackBar(
                                  content: Text(
                                    e.message,
                                    style: CustomTypography.bodyMedium.copyWith(
                                      color: CustomColors.bgLight,
                                    ),
                                  ),
                                  backgroundColor: CustomColors.error,
                                );
                              });
                            }
                          }
                        },
                        icon: Container(
                          height: MediaQuery.sizeOf(context).height * .3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CustomColors.bgTeritary,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              filePath.isEmpty
                                  ? SvgPicture.asset(
                                      'assets/icons/upload.svg',
                                    )
                                  : SizedBox(
                                      child: CustomText(fileName),
                                    ),
                              const SizedBox(height: 8),
                              filePath.isEmpty
                                  ? Text(
                                      'Select File',
                                      style: CustomTypography.bodyLarge,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      if (isEmpty)
                        const ErrorText(errorText: "Please select a file"),
                      const SizedBox(height: 16),
                      // give every space here
                      CustomButtonOut(
                        onPressed: () async {
                          final path = await saveCsvToDevice(context);
                          log(path);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'CSV file downloaded successfully, saved to: $path',
                                style: CustomTypography.bodyLarge.copyWith(
                                  color: CustomColors.bgLight,
                                ),
                              ),
                              backgroundColor: CustomColors.primary,
                            ),
                          );

                          // show a snackbar if success
                        },
                        backgroundColor:
                            CustomColors.contentPrimary.withOpacity(.3),
                        // borderColor: CustomColors.bgLight,
                        content: Text(
                          "Download Sample CSV",
                          style: CustomTypography.bodyLarge.copyWith(
                            color: CustomColors.bgLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        isLoading: false,
                        loadingColor: CustomColors.bgLight,
                        height: 44,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 8),
                      CustomButtonOut(
                        onPressed: () {
                          // upload
                          if (filePath.isEmpty) {
                            setState(() {
                              isEmpty = true;
                            });
                            return;
                          } else {
                            setState(() {
                              isEmpty = false;
                            });
                          }
                          context.read<GuestCubit>().addGuestCsv({
                            "file": filePath,
                          });
                        },
                        backgroundColor: CustomColors.primary,
                        borderColor: CustomColors.bgLight,
                        content: Text(
                          "Done",
                          style: CustomTypography.bodyLarge
                              .copyWith(color: CustomColors.bgLight),
                        ),
                        isLoading: state is GuestAddLoading,
                        loadingColor: CustomColors.bgLight,
                        height: 44,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTable extends StatelessWidget {
  final String col1;
  final String col2;
  const CustomTable({super.key, required this.col1, required this.col2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CustomColors.contentPrimary.withOpacity(.7),
        border: const Border(
          bottom: BorderSide(
            color: CustomColors.ligthPrimary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              col1,
              style: CustomTypography.bodyLarge.copyWith(
                color: CustomColors.bgLight,
              ),
            ),
          ),
          Container(
            height: 20,
            width: 1,
            color: CustomColors.ligthPrimary,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          Text(
            col2,
            style: CustomTypography.bodyLarge.copyWith(
              color: CustomColors.bgLight,
            ),
          ),
        ],
      ),
    );
  }
}
