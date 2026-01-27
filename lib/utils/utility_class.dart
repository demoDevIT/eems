import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'right_to_left_route.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

class UtilityClass {
  static BuildContext? dialogContext;
  static final Connectivity _connectivity = Connectivity();
  static bool _isOffline = false;
  static ScaffoldMessengerState? _scaffoldMessenger;
  static const MethodChannel _platform = MethodChannel('device_info');

  static showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          side: BorderSide(
            width: 2.0,
            style: BorderStyle.solid,
            color: Colors.blueGrey,
          ),
        ),
        duration: const Duration(milliseconds: 2000),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
      ),
    );
  }

  static showSnackBar2(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          side: BorderSide(
            width: 2.0,
            style: BorderStyle.solid,
            color: Colors.blueGrey,
          ),
        ),
        duration: const Duration(milliseconds: 7000),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15),
      ),
    );
  }

  Future<File> compressExistingPDF(File originalPdfFile) async {
    final document = pw.Document();
    final pages =
        await Printing.raster(originalPdfFile.readAsBytesSync(), dpi: 150)
            .toList();
    final List<pw.MemoryImage> images = [];
    for (final page in pages) {
      final imageBytes = await page.toPng();
      final decodedImage = img.decodeImage(imageBytes);
      final resizedImage = img.copyResize(decodedImage!, width: 300);
      final pdfImage = pw.MemoryImage(img.encodeJpg(resizedImage, quality: 80));
      images.add(pdfImage);
    }

    for (int i = 0; i < images.length; i += 2) {
      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Image(images[i]),
                if (i + 1 < images.length) ...[
                  pw.SizedBox(height: 20),
                  pw.Image(images[i + 1]),
                ],
              ],
            );
          },
        ),
      );
    }
    final outputDir = await getTemporaryDirectory();
    final compressedFile = File('${outputDir.path}/compressed_output.pdf');
    await compressedFile.writeAsBytes(await document.save());
    print("✅ Compressed PDF path: ${compressedFile.path}");
    print("📦 Size: ${compressedFile.lengthSync() / 1024} KB");
    return compressedFile;
  }

  static showProgressDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 80,
                child: Lottie.asset(
                  'assets/loader/progress-lod.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static dismissProgressDialog() {
    if (dialogContext != null) {
      Navigator.pop(dialogContext!);
    } else {
      debugPrint("Unable to dismiss progress dialog");
    }
  }

  static Future<bool> askForInput(
    String title,
    String message,
    String positiveButton,
    String negativeButton,
    bool showOnlyOneButton,
  ) async {
    return await showDialog(
      context: navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 280,
              padding: const EdgeInsets.only(
                  top: 40, bottom: 24, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: !showOnlyOneButton
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    children: [
                      // Negative button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(false),
                        child: Container(
                          width: 90,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.red[400]!, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            negativeButton,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (!showOnlyOneButton)
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(true),
                          child: Container(
                            width: 90,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.green[400]!, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              positiveButton,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Overlapping Circle Avatar
            Positioned(
              top: -25,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Image.asset(
                  "assets/icons/Alert.gif",
                  width: 35,
                  height: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> showAlert(BuildContext context, String title,
      String message, String buttonText) async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 3.0, color: Colors.red[200]!),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green[400]!, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  static Future<bool> showSuccessDialog(
    String title,
    String message,
    String positiveButton,
    String negativeButton,
    bool showOnlyOneButton,
  ) async {
    return await showCupertinoDialog(
      context: navigatorKey.currentState!.context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Main AlertDialog container
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 3.0, color: Colors.green[200]!),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  Row(
                    mainAxisAlignment: !showOnlyOneButton
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryDark),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text(
                            negativeButton,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (!showOnlyOneButton)
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(true),
                          child: Container(
                            alignment: Alignment.center,
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.red[300]!, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              positiveButton,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Positioned alert gif CircleAvatar
            Positioned(
              top: -25,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    "assets/icons/Success.gif",
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> showfaildDialog(
      String title,
      String message,
      String positiveButton,
      String negativeButton,
      bool showOnlyOneButton) async {
    return await showCupertinoDialog(
      context: navigatorKey.currentState!.context,
      // Use the global navigator key
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 3.0, color: Colors.red[200]!),
        ),
        title: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
            const Center(
                child: Icon(
              Icons.close_rounded,
              color: Colors.red,
              size: 35,
            )),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: !showOnlyOneButton
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 180,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryDark),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    negativeButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!showOnlyOneButton)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[300]!, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      positiveButton,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = connectivityResult != ConnectivityResult.none;
    if (!isConnected) {
      return false;
    }
    return true;
  }

  static Future<String?> getDeviceId() async {
    try {
      final String? deviceId = await _platform.invokeMethod('getAndroidId');
      return deviceId;
      // return "59184a29b0248085";
    } on PlatformException catch (e) {
      return "Failed to get device ID: '${e.message}'.";
    }
  }

  static Future<String?> getApkVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
       String? version = packageInfo.version;
      print("version${packageInfo.version}");
       return version;
    } catch (e, s) {
      print(s);

    }

  }

  static Future<String?> getIpAddress() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();
      return data['ip'].toString();
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      print(exception.message);
    }
  }

  static void initNetworkListener(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldMessenger = ScaffoldMessenger.of(context);
      _connectivity.onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        bool isConnected =
            results.any((result) => result != ConnectivityResult.none);
        if (!isConnected && !_isOffline) {
          _showNoInternetSnackbar();
        } else if (isConnected && _isOffline) {
          _hideSnackbar();
          UtilityClass.showSnackBar(navigatorKey.currentState!.context,
              "Internet online", kGreenLightColor);
        }
        _isOffline = !isConnected;
      });
    });
  }

  static void _showNoInternetSnackbar() {
    _scaffoldMessenger?.showSnackBar(
      const SnackBar(
        content: Text("No Internet Connection!"),
        backgroundColor: Colors.red,
        duration: Duration(days: 1),
        behavior: SnackBarBehavior.floating, // Makes it float
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      ),
    );
  }

  static void _hideSnackbar() {
    _scaffoldMessenger?.hideCurrentSnackBar();
  }

  String formatDateToIST(DateTime dateTime) {
    DateTime istDateTime =
        dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    String formattedDate =
        DateFormat('EEE MMM dd yyyy HH:mm:ss').format(istDateTime);
    String timeZoneOffset = "GMT+0530";
    String timeZoneName = "(India Standard Time)";
    return "$formattedDate $timeZoneOffset $timeZoneName";
  }

  static navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(RightToLeftRoute(
      page: page,
      duration: const Duration(milliseconds: 500),
      startOffset: const Offset(1.0, 0.0),
    ));
  }


  static Widget orDivider(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child:  Text(
            AppLocalizations.of(context)!.or,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }
  static TextStyle poppins({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
  static void safeBack(BuildContext context, {Widget? fallback}) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (fallback != null) {
      // If no back stack, go to fallback screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => fallback),
      );
    }
  }

  static showProgressDialogVideo(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(height: 100,
                  child: Lottie.asset(
                    'assets/loader/videoloading.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Text(message,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }



}
