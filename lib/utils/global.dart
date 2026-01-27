import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/textfeild.dart';
import 'package:rajemployment/utils/textstyles.dart';
import 'package:rajemployment/utils/user_new.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../role/job_seeker/qr_scanner/qr_scanner_screen.dart';
import 'button.dart';
import 'images.dart';


Widget vSpace(double space) {
  return SizedBox(
    width: space,
  );
}

Widget hSpace(double space) {
  return SizedBox(
    height: space,
  );
}

Future<void> showImagePicker(
    BuildContext context, Function(XFile?) onImagePicked) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              alignment: Alignment.center,
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  hSpace(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                               "",
                              style: Styles.semiBoldTextStyle(
                                size: 16,
                                color:  kWhite,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close,
                              color: kBlackColor,
                              size: 20),
                        ),
                      ],
                    ),
                  ),
                  hSpace(10),
                  customButton(() async {
                    Navigator.of(context).pop();
                    final ImagePicker _picker = ImagePicker();
                    XFile? pickedFile =
                        await _picker.pickImage(source: ImageSource.camera);
                    onImagePicked(pickedFile);
                  }, "Camera", '', context,
                      height: 50,
                      color: kBlackColor,
                      txtColor: kWhite),
                  hSpace(15),
                  customButton2(() async {
                    Navigator.of(context).pop();
                    final ImagePicker _picker = ImagePicker();
                    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    onImagePicked(pickedFile);
                  },"Gallery", '', context,
                      height: 50,
                      color: kWhite,
                      txtColor: kBlackColor),
                  hSpace(20),
                ],
              ),
            ),
          );
        },
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.linear,
        )),
        child: child,
      );
    },
  );
}





Future<void> showPdfFilePicker(
    BuildContext context, Function(File?) onPdfPicked) async {
     FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'], // restrict to PDF
  );

  if (result != null && result.files.single.path != null) {
    File file = File(result.files.single.path!);
    onPdfPicked(file);
  } else {
    onPdfPicked(null); // user canceled
  }
}


Future<void> showImageGalleryPicker(
    BuildContext appContext, Function(XFile?) onImagePicked) async {
  // Navigator.of(appContext).pop();
   final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    preferredCameraDevice: CameraDevice.front, // Use front camera
  );
  onImagePicked(pickedFile);
}


Future<void> showImageSelfiePicker(
    BuildContext appContext, Function(XFile?) onImagePicked) async {
  // Navigator.of(appContext).pop();
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.camera,
    preferredCameraDevice: CameraDevice.front, // Use front camera
  );
  onImagePicked(pickedFile);
}


bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}




void showAlertError(String message, BuildContext context) {
  print("correctMsg1->$message");
  showModalBottomSheet(
    context: context,
    backgroundColor: kWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      print("correctMsg2->$message");
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error, color: kRedColor),
                SizedBox(width: 8),
                Text(
                  "Error",
                  style: Styles.semiBoldTextStyle(
                    size: 16,
                    color: kRedColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              message,
              style: Styles.regularTextStyle(
                size: 14,
                color: kBlackColor,
              ),
            ),
            SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "OK",
                  style: Styles.regularTextStyle(
                    size: 16,
                    color: kBlackColor,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

showAlertSuccess(
  String message,
  BuildContext context,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,
        style:
            Styles.boldTextStyle(color: kWhite, size: 14)),
    backgroundColor: kGreenLightColor,
    duration: Duration(seconds: 1),
  ));
}



String currentDate() {
  DateTime now = DateTime.now();
  String currentDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  print('Current date: $currentDate');
  return "${currentDate}";
}

String currentDateRTS() {
  DateTime now = DateTime.now();
  // Format it to "yyyy-MM-dd"
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  print(formattedDate); // Example output: 2025-01-03
  print('Current date: $formattedDate');
  return "${formattedDate}";
}

String getFormattedDate(String date) {
  if (date.isNotEmpty) {
    String formattedDate = "";
    DateTime dateTime = DateTime.parse(date);
    formattedDate = DateFormat('MMM dd,yyyy').format(dateTime);
    return "${formattedDate}";
  }
  return "";
}

String getFormattedDay(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  String dayOfWeek = DateFormat('EEEE').format(dateTime);
  return "$dayOfWeek";
}

String getFormattedTime(String time) {
  DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
  String formattedTime = DateFormat("hh:mm a").format(dateTime);
  return formattedTime;
}

String getFormattedDate2(String time) {
  DateTime dateTime = DateFormat("dd-MM-yyyy hh:mm a").parse(time);
  String formattedTime = DateFormat("dd MMM yyyy").format(dateTime);
  return formattedTime;
}

String getFormattedDate3(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('dd-MM/-yyyy').format(dateTime);
  return formattedDate;
}

String getFormattedDate5(String date) {
  DateTime dateTime = DateFormat("dd-MM-yyyy").parse(date);
  String formattedTime = DateFormat("yyyy-MM-dd").format(dateTime);
  return formattedTime;
}

String getFormattedDate6(String date) {
  String formattedDate = "";
  DateTime dateTime = DateTime.parse(date);
  formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
  return "${formattedDate}";
}

String getFormattedDate7(String date) {
  String formattedDate = "";
  DateTime dateTime = DateTime.parse(date);
  formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return "${formattedDate}";
}

String getFormattedDate8(String date) {
  String formattedDate = "";
  DateTime dateTime = DateTime.parse(date);
  formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return "${formattedDate}";
}



bool getFormattedDateCheckEqualeCurrentDate(String deploymentDateString) {
  // Parse the deployment date
  DateTime deploymentDate = DateTime.parse(deploymentDateString);
  // Get today's date without time
  DateTime today = DateTime.now();
  DateTime currentDateOnly = DateTime(today.year, today.month, today.day);
  // Get deployment date without time
  DateTime deploymentDateOnly =
      DateTime(deploymentDate.year, deploymentDate.month, deploymentDate.day);
  // Check if dates are equal
  bool isEqual = currentDateOnly == deploymentDateOnly;
  return isEqual;
}
String dobFormatDate(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  return DateFormat("dd MMM yyyy").format(dateTime);
}
String dobFormatApiDate(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  return DateFormat("yyyy-MM-dd").format(dateTime);
}

String formatDate(String dateStr, String pattern) {
  DateTime dateTime = DateTime.parse(dateStr);
  return DateFormat(pattern).format(dateTime);
}

/*
bool getFormattedDateCheckAfterCurrentDate(String deploymentDateString) {
  // Parse it to DateTime
  // Parse the deployment date
  DateTime deploymentDate = DateTime.parse(deploymentDateString);

  // Get today's date without time
  DateTime today = DateTime.now();
  DateTime currentDateOnly = DateTime(today.year, today.month, today.day);

  // Get deployment date without time
  DateTime deploymentDateOnly =
      DateTime(deploymentDate.year, deploymentDate.month, deploymentDate.day);

  // Check if current date is after deployment date
  bool isAfter = currentDateOnly.isAfter(deploymentDateOnly);

  print("Is current date after deployment date? $isAfter");
  return isAfter;
}
*/

bool isCurrentDateAfterDeployment(String deploymentDateString) {
  // Parse deployment date (removing time part)
  DateTime deploymentDate = DateTime.parse(deploymentDateString);
  DateTime deploymentDateOnly = DateTime(
    deploymentDate.year,
    deploymentDate.month,
    deploymentDate.day,
  );

  // Get current date without time
  DateTime now = DateTime.now();
  DateTime currentDateOnly = DateTime(now.year, now.month, now.day);

  // Return true if current date is after deployment date
  return currentDateOnly.isAfter(deploymentDateOnly);
}


bool isCurrentDateBeforeDeploymentDate(String date) {
  DateTime deploymentDate;

  try {
    // Try ISO first
    deploymentDate = DateTime.parse(date);
  } catch (_) {
    try {
      // Try format: "yyyy-MM-dd hh:mm a"
      deploymentDate = DateFormat("yyyy-MM-dd hh:mm a").parse(date);
    } catch (_) {
      try {
        // Try format: "hh:mm a" (Assume today as date)
        DateTime now = DateTime.now();
        DateTime timeOnly = DateFormat("hh:mm a").parse(date);
        deploymentDate = DateTime(
            now.year, now.month, now.day, timeOnly.hour, timeOnly.minute);
      } catch (e) {
        print("Error parsing date: $e");
        return false;
      }
    }
  }

  // Compare dates (only date part)
  DateTime today = DateTime.now();
  DateTime currentDateOnly = DateTime(today.year, today.month, today.day);
  DateTime deploymentDateOnly =
      DateTime(deploymentDate.year, deploymentDate.month, deploymentDate.day);

  bool isBefore = currentDateOnly.isBefore(deploymentDateOnly);
  print("Is current date before deployment date? $isBefore");
  return isBefore;
}

bool isCurrentDateWithinDeploymentRange(
    String fromDateString, String toDateString) {
  try {
    // Parse the from and to dates
    DateTime fromDate = DateTime.parse(fromDateString);
    DateTime toDate = DateTime.parse(toDateString);

    // Get today's date without time
    DateTime now = DateTime.now();
    DateTime currentDateOnly = DateTime(now.year, now.month, now.day);

    // Get from and to dates without time
    DateTime fromDateOnly =
        DateTime(fromDate.year, fromDate.month, fromDate.day);
    DateTime toDateOnly = DateTime(toDate.year, toDate.month, toDate.day);

    // Check if current date is between from and to (inclusive)
    bool isWithinRange = currentDateOnly.isAtSameMomentAs(fromDateOnly) ||
        currentDateOnly.isAtSameMomentAs(toDateOnly) ||
        (currentDateOnly.isAfter(fromDateOnly) &&
            currentDateOnly.isBefore(toDateOnly));

    print("Is current date within deployment range? $isWithinRange");
    return isWithinRange;
  } catch (e) {
    print("Error parsing dates: $e");
    return false;
  }
}

bool isCurrentDateWithinRangeOrAfter(
    String fromDateString, String toDateString) {
  try {
    // Parse the from and to dates
    DateTime fromDate = DateTime.parse(fromDateString);
    DateTime toDate = DateTime.parse(toDateString);

    // Get today's date without time
    DateTime now = DateTime.now();
    DateTime currentDateOnly = DateTime(now.year, now.month, now.day);

    // Remove time from fromDate and toDate
    DateTime fromDateOnly =
        DateTime(fromDate.year, fromDate.month, fromDate.day);
    DateTime toDateOnly = DateTime(toDate.year, toDate.month, toDate.day);

    // Check if current date is within range or after toDate
    bool isInRangeOrAfterToDate =
        currentDateOnly.isAtSameMomentAs(fromDateOnly) || currentDateOnly.isAtSameMomentAs(toDateOnly) ||
            (currentDateOnly.isAfter(fromDateOnly) &&
                currentDateOnly.isBefore(toDateOnly)) ||
            currentDateOnly.isAfter(toDateOnly);

    print(
        "Is current date within range or after toDate? $isInRangeOrAfterToDate");
    return isInRangeOrAfterToDate;
  } catch (e) {
    print("Error parsing dates: $e");
    return false;
  }
}

bool isCurrentDateWithinRange(String fromDateString, String toDateString) {
  try {
    // Parse input dates
    DateTime fromDate = DateTime.parse(fromDateString);
    DateTime toDate = DateTime.parse(toDateString);

    // Normalize all dates to remove time component
    DateTime currentDate = DateTime.now();
    DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime start = DateTime(fromDate.year, fromDate.month, fromDate.day);
    DateTime end = DateTime(toDate.year, toDate.month, toDate.day);

    // Check if today is within the range [start, end] inclusive
    return today.isAtSameMomentAs(start) ||
        today.isAtSameMomentAs(end) ||
        (today.isAfter(start) && today.isBefore(end));
  } catch (e) {
    print("Error parsing dates: $e");
    return false;
  }
}


bool isCurrentDateSameAsDeploymentDate(String date) {
  DateTime deploymentDate;

  try {
    deploymentDate = DateTime.parse(date);
  } catch (_) {
    try {
      deploymentDate = DateFormat("yyyy-MM-dd hh:mm a").parse(date);
    } catch (_) {
      try {
        DateTime now = DateTime.now();
        DateTime timeOnly = DateFormat("hh:mm a").parse(date);
        deploymentDate = DateTime(
            now.year, now.month, now.day, timeOnly.hour, timeOnly.minute);
      } catch (e) {
        print("Error parsing date: $e");
        return false;
      }
    }
  }

  DateTime today = DateTime.now();
  DateTime currentDateOnly = DateTime(today.year, today.month, today.day);
  DateTime deploymentDateOnly =
      DateTime(deploymentDate.year, deploymentDate.month, deploymentDate.day);

  bool isSameDate = currentDateOnly == deploymentDateOnly;
  print("Is current date same as deployment date? $isSameDate");
  return isSameDate;
}

String getFormattedDate9(String dateStr) {
  if (dateStr.isNotEmpty) {
    final DateTime parsedDate = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(parsedDate);
  } else {
    return "";
  }
}

String getPerson(int? adult, int? children, int? infant) {
  String person = "";
  adult = adult ?? 0;
  children = children ?? 0;
  infant = infant ?? 0;
  if (adult! > 0 && children! > 0 && infant! > 0) {
    person =
        "${adult.toString()} Adult, ${children.toString()} Children,${infant.toString()} Infant";
  } else if (adult > 0 && children! > 0) {
    person = "${adult.toString()} Adult, ${children.toString()} Children";
  } else if (adult > 0 && infant! > 0) {
    person = "${adult.toString()} Adult, ${infant.toString()} Infant";
  } else {
    "${adult.toString()} Adult";
  }

  return person;
}

Future<bool> onWillPop(BuildContext context) async {
  DateTime? _lastPressedAt; // Track the last back press time
  final now = DateTime.now();
  if (_lastPressedAt == null ||
      now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
    // Show Snackbar or Toast on single back press
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Press back again to exit')),
    );
    _lastPressedAt = now;
    return Future.value(false); // Prevent app from exiting
  } else {
    // Exit app on double back press
    return Future.value(true);
  }
}

void exitApp(BuildContext context, String value) {
  if (value == "success") {
    SystemNavigator.pop(); // Close the app
  }
}


String checkNullValue(String value) {
  if (value == "null") {
    return "";
  }
  return value;
}
commonAppBar(title, mContext, currentLanguage, userId, isBack, type, {Function? onTapClick}) {
  print(currentLanguage.toString());
  // Set Status Bar icons based on background (dark or light mode)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // statusBarColor: ColorResources.FDF3E8Color,
    statusBarColor: kWhite,
    // Set your desired color
    statusBarIconBrightness: Brightness.dark,
    // For white icons on a dark background
    statusBarBrightness: Brightness.dark, // For iOS status bar
  ));
  return AppBar(
    centerTitle: true,
    // backgroundColor: Colors.transparent,
    backgroundColor: Colors.amber,
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kWhite, kWhite],
        ),
      ),
    ),
    leading: Builder(
      builder: (mContext) {
        return InkWell(
          onTap: () {
            Scaffold.of(mContext).openDrawer();
          },
          child: const Icon(Icons.menu),
        );
      },
    ),
    iconTheme: const IconThemeData(color: kBlackColor),
    title: Text(
      title,
      style: Styles.boldTextStyle(color: kBlackColor, size: 18),
    ),
    actions: [
      InkWell(
        onTap: () {
          onTapClick?.call();
        },
        child: Row(
          children: [
            InkWell(
              onTap: () async {
                final scanned = await Navigator.of(mContext).push<String>(
                  MaterialPageRoute(builder: (_) => const QRScannerScreen()),
                );
                // Handle scanned result if needed
              },
              child: Image.asset(
                "assets/logos/qrcode.png",
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Container(
            //   decoration: BoxDecoration(
            //     color: kLightGrayColor,
            //     border: Border.all(color: kJobEventBackColor, width: 2),
            //     borderRadius: BorderRadius.circular(50),
            //   ),
            //   child:  ClipOval(
            //     child: Image.network(
            //       UserData().model.value.latestPhotoPath.toString(),
            //       width: MediaQuery.of(mContext).size.width * 0.10,
            //       height: MediaQuery.of(mContext).size.width * 0.10,
            //       fit: BoxFit.cover,
            //       errorBuilder: (context, error, stackTrace) {
            //         return Image.asset(
            //           Images.placeholder,
            //           width: MediaQuery.of(context).size.width * 0.10,
            //           height: MediaQuery.of(context).size.width * 0.10,
            //           fit: BoxFit.cover,
            //         );
            //       },
            //     ),
            //   ),
            // ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    ],

    // 👇 Bottom section with search bar
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(90), // Adjust height
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kWhite, kHeaderBackground],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(mContext)!.searchhere,
                    hintStyle: const TextStyle(color: kDartGrayColor),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    border: InputBorder.none,
                    suffixIcon: Container(
                      width: 80,
                      margin: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: kViewAllColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

}
commonAppBar2(title, mContext, currentLanguage, userId, isBack, type, {Function? onTapClick}) {
  print(currentLanguage.toString());
  // Set Status Bar icons based on background (dark or light mode)
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // statusBarColor: ColorResources.FDF3E8Color,
    statusBarColor: kWhite,
    // Set your desired color
    statusBarIconBrightness: Brightness.dark,
    // For white icons on a dark background
    statusBarBrightness: Brightness.dark, // For iOS status bar
  ));
  return AppBar(
    centerTitle: true,
    // backgroundColor: Colors.transparent,
    backgroundColor: Colors.amber,
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kWhite, kWhite],
        ),
      ),
    ),
    leading: title.toString() != "OTR Form" ? Builder(
      builder: (mContext) {
        return InkWell(
          onTap: () {
            Navigator.pop(mContext);
          },
          child: const Icon(Icons.arrow_back_ios),
        );
      },
    ) : SizedBox(),
    iconTheme: const IconThemeData(color: kBlackColor),
    title: Text(
      title,
      style: Styles.boldTextStyle(color: kBlackColor, size: 18),
    ),



  );

}

Future<void> successDialog(BuildContext context,String message, Function fun) {
  return showGeneralDialog(
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return WillPopScope(
        onWillPop: () async {
          return false; // Prevent back navigation
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 20), // 👈 Removes default side padding
              backgroundColor: kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 👈 optional (0 for full edge)
              ),
              child: Container(
                width: double.infinity, // 👈 Full width
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(
                          Images.close,
                          width: 20,
                          height: 20,
                          semanticsLabel: 'close',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    hSpace(20),
                    Image(image: AssetImage( Images.correct,),width: 80,height: 80,fit: BoxFit.fill,),

                    hSpace(20),
                    Text(
                      "Successful",
                      style: Styles.semiBoldTextStyle(size: 18, color: kBlackColor),
                    ),
                    hSpace(10),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Styles.regularTextStyle(size: 14, color: fontGrayColor),
                    ),
                    hSpace(20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4, // 50% button width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purpal455CDCColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          fun("success");
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                          ),
                        ),
                      ),
                    ),
                    hSpace(20),
                  ],
                ),
              ),
            );

          },
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.linear,
        )),
        child: child,
      );
    },
  );
}


Future<void> showLogoutDialog(
    BuildContext context,
    String title,
    String message,
    String subtitle,
    Function fun,
    ) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter, // 👈 position bottom
        child: StatefulBuilder(
          builder: (context, setState) {
            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(0),
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: kWhite,
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Styles.semiBoldTextStyle(size: 18, color: kRedColor),
                    ),
                    hSpace(10),
                    Divider(height: 2, color: dividerColor),
                    hSpace(10),
                    Text(
                      message,
                      style: Styles.semiBoldTextStyle(size: 16, color: kBlackColor),
                      textAlign: TextAlign.center,
                    ),
                    hSpace(8),
                    Text(
                      subtitle,
                      style: Styles.regularTextStyle(size: 12, color: kDartGrayColor),
                      textAlign: TextAlign.center,
                    ),
                    hSpace(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        customButton(
                              () {
                            Navigator.of(context).pop();
                          },
                          "Cancel",
                          '',
                          height: 40,
                          radius: 50,
                          width: MediaQuery.of(context).size.width * 0.85 / 2,
                          context,
                          txtColor: purpal455CDCColor,
                          fontSize: 14,
                          color: purpal455CDCColor.withOpacity(0.12),
                        ),
                        vSpace(10),
                        customButton(
                              () {
                            Navigator.of(context).pop();
                            fun("success");
                          },
                          "Yes Logout",
                          '',
                          fontSize: 14,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.85 / 2,
                          context,
                          radius: 50,
                          color: purpal455CDCColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // 👈 slide from bottom
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}


Future<void> showExitDialog(
    BuildContext context, String message, Function fun) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter, // 👈 position bottom
        child: StatefulBuilder(
          builder: (context, setState) {
            return Align(
              alignment: Alignment.bottomCenter, // 👈 position bottom
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.all(0),
                     // height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kWhite,
                      ),
                      //padding: const EdgeInsets.all(15),
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 55),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Exit",
                            style: Styles.semiBoldTextStyle(size: 18, color: kRedColor),
                          ),
                          hSpace(10),
                          Divider(height: 2, color: dividerColor),
                          hSpace(10),
                          Text(
                            message,
                            style: Styles.semiBoldTextStyle(size: 16, color: kBlackColor),
                            textAlign: TextAlign.center,
                          ),

                          hSpace(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customButton(
                                    () {
                                  Navigator.of(context).pop();
                                },
                                "No",
                                '',
                                height: 40,
                                radius: 50,
                                width: MediaQuery.of(context).size.width * 0.85 / 2,
                                context,
                                txtColor: purpal455CDCColor,
                                fontSize: 14,
                                color: purpal455CDCColor.withOpacity(0.12),
                              ),
                              vSpace(10),
                              customButton(
                                    () {
                                  Navigator.of(context).pop();
                                  fun("success");
                                },
                                "Yes Exit",
                                '',
                                fontSize: 14,
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.85 / 2,
                                context,
                                radius: 50,
                                color: purpal455CDCColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // 👈 slide from bottom
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}


Future<void> confirmAlertDialog(
    BuildContext context,
    String title,
    String message,
    Function fun,
    ) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter, // 👈 position bottom
        child: StatefulBuilder(
          builder: (context, setState) {
            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(0),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: kWhite,
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Styles.semiBoldTextStyle(size: 18, color: kGreenColor),
                    ),
                    hSpace(10),
                    Divider(height: 2, color: dividerColor),
                    hSpace(10),
                    Text(
                      message,
                      style: Styles.semiBoldTextStyle(size: 16, color: kBlackColor),
                      textAlign: TextAlign.center,
                    ),
                    hSpace(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        customButton(
                              () {
                            Navigator.of(context).pop();
                          },
                          "No",
                          '',
                          height: 40,
                          radius: 50,
                          width: MediaQuery.of(context).size.width * 0.90 / 2,
                          context,
                          txtColor: purpal455CDCColor,
                          fontSize: 14,
                          color: purpal455CDCColor.withOpacity(0.12),
                        ),
                        vSpace(10),
                        customButton(
                              () {
                            Navigator.of(context).pop();
                            fun("success");
                          },
                          "Yes",
                          '',
                          fontSize: 14,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.90 / 2,
                          context,
                          radius: 50,
                          color: purpal455CDCColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // 👈 slide from bottom
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}


showDateSheet2(context, dateCtrl) async {
  var currentDate = DateTime.now();
  // editProfile.showDatePicker(context);
  DateTime? pickedDate = await showDatePicker(
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    context: context,
    initialDate: DateTime(currentDate.year - 1),
    // Default to today
    firstDate:  currentDate,
    // Allow selection up to 100 years ago
    lastDate:currentDate,
    // Prevent future dates
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kbuttonColor,
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) {
    print(pickedDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    dateCtrl.text = formattedDate.toString();
  } else {
    print("Date is not selected");
  }
}

showDatePickerDialog(context, dateCtrl,initialdate,firstdate,lastdate) async {

  DateTime? pickedDate = await showDatePicker(
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    context: context,
    initialDate: initialdate,
    // Default to today
    firstDate:  firstdate,
    // Allow selection up to 100 years ago
    lastDate:lastdate,
    // Prevent future dates
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kbuttonColor,
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) {
    print(pickedDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    dateCtrl.text = formattedDate.toString();
  } else {
    print("Date is not selected");
  }
}

showDatePickerYearMonthDialog(context, dateCtrl,initialdate,firstdate,lastdate) async {

  DateTime? pickedDate = await showDatePicker(
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    context: context,
    initialDate: initialdate,
    // Default to today
    firstDate:  firstdate,
    // Allow selection up to 100 years ago
    lastDate:lastdate,
    // Prevent future dates
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kbuttonColor,
          ),
        ),
        child: child!,
      );
    },
  );
  if (pickedDate != null) {
    print(pickedDate);
    String formattedDate = DateFormat('yyyy-MM').format(pickedDate);
    dateCtrl.text = formattedDate.toString();
  } else {
    print("Date is not selected");
  }
}


String formatCase(String value) {
  if (value.isEmpty) return "";
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}



Future<void> otpDialog(BuildContext context, TextEditingController otpController,Function fun) {
  return showGeneralDialog(
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return WillPopScope(
        onWillPop: () async {
          return false; // Prevent back navigation
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 20), // 👈 Removes default side padding
              backgroundColor: kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 👈 optional (0 for full edge)
              ),
              child: Container(
                width: double.infinity, // 👈 Full width
                padding: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "Enter OTP",
                          style: UtilityClass.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.030),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: buildTextWithBorderField(
                            otpController,
                            "Enter OTP",
                            MediaQuery.of(context).size.width,
                            50,
                            TextInputType.number,
                            boxColor: Colors.transparent,
                            bodercolor: kDartGrayColor,
                            textLenght: 6
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight! * 0.030),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (otpController.text.isNotEmpty) {
                              Navigator.of(context).pop();
                              fun("success");
                            }
                            else {
                            }
                          },
                          child: Text(
                            "Verify OTP",
                            style: UtilityClass.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

          },
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: anim1,
          curve: Curves.linear,
        )),
        child: child,
      );
    },
  );
}
