import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/qr_scanner/provider/qr_scanner_screen_provider.dart';
import '../../../utils/global.dart';
import '../../../utils/location_service.dart';
import '../../../utils/progress_dialog.dart';
import '../../../utils/user_new.dart';
import '../../../utils/utility_class.dart';
import '../select_company/select_company_page.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> with WidgetsBindingObserver {

  final MobileScannerController _controller = MobileScannerController(
    autoStart: true,
  );

  bool _handled = false; // avoid duplicate pops
  late final user;
var provider;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    // user = UserData().model.value;
    //
    // // 🔐 Safety check
    // if (user.isLogin != true || user.userId == null) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pop(context);
    //   });
    // }


    controllerClear();
    // Scanner auto-starts by default; you can pass autoStart:false to controller if you plan to manage lifecycle manually.
  }

    controllerClear() async {
      await Future.delayed(const Duration(milliseconds: 300));
      await _controller.start();
      setState(() {
      });
    }
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<QrScannerScreenProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR code'),
        actions: [
          // IconButton(
          //   icon  :  Icon(Icons.photo),
          //   onPressed: ()async{
          //     await scanFromGallery( context, provider);
          //   },
          //   tooltip: 'Scan from gallery',
          // ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () async => await _controller.toggleTorch(),
            tooltip: 'Toggle torch',
          ),
          // IconButton(
          //   icon: const Icon(Icons.cameraswitch),
          //   onPressed: () async => await _controller.switchCamera(),
          //   tooltip: 'Switch camera',
          // ),
        ],
      ),
      body: Consumer<QrScannerScreenProvider>(
        builder: (context, provider, _) => Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
            ),

            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),



    );
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await _controller.stop();
    }
    else if (state == AppLifecycleState.resumed) {
      if (!_handled) {
        await _controller.start();
      }
    }
    setState(() {

    });
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _controller.stop();
    super.dispose();
  }

  _onDetect(BarcodeCapture capture) async {
    if (_handled) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? raw = barcodes.first.rawValue;
    print('barcode raw: $raw');
    //[{"EventRegistrationId":"31003200370039003200",
    // "Longitude":"370033002E00300032003000340030003900","Latitude":"320036002E00330030003200370039003300",
    // "UserId":"31003700360030003900","Roleid":"3400","EventId":"3300"}]
    if (raw == null) return;

    _handled = true;

    // 🔥 SHOW LOADER IMMEDIATELY
    ProgressDialog.showLoadingDialog(context);

    try {
      // Stop camera AFTER loader is shown
      await _controller.stop();

      final List decoded = jsonDecode(raw);


      if(decoded[0].containsKey('UserId') &&
          decoded[0]['UserId'] != null &&
          decoded[0]['UserId'].toString().isNotEmpty){ //when userid is coming from barcode

        print('UserIDDDDDDD exist');

        final String userId = decoded[0]['UserId'];
        print('UserIDDDDDDD ==> $userId');
        final String roleId = decoded[0]['Roleid'];
        final String eventId = decoded[0]['EventId'];

        final String encryptedLatitude = decoded[0]['Latitude'];
        final String encryptedLongitude = decoded[0]['Longitude'];

        print('actual Latitude: $encryptedLatitude');
        print('actual Longitude: $encryptedLongitude');

        final String eventLatitude = decryptHexUtf16(encryptedLatitude);
        final String eventLongitude = decryptHexUtf16(encryptedLongitude);

        print('Decrypted Latitude: $eventLatitude');
        print('Decrypted Longitude: $eventLongitude');

        String? deviceId = await UtilityClass.getDeviceId();
        final encryptedDeviceId = encrypt(deviceId ?? "");

        // 📍 Get location
        final position = await LocationService.getCurrentLocation();
        if (position == null) {
          throw "Unable to get location";
        }

        final double userLatitude = position.latitude; //26.915486;
        final double userLongitude = position.longitude; //75.819518;

        print('userLatitude1 lat: $userLatitude');
        print('userLongitude1 long: $userLongitude');

        // final distance = calculateDistanceInMeters(
        //   double.parse(eventLatitude),
        //   double.parse(eventLongitude),
        //   userLatitude,
        //   userLongitude,
        // );

        // if (distance > 100) {
        //   throw "You are too far from the location.\nDistance: ${distance.toStringAsFixed(0)} meters";
        // }

        final result = await provider.attendanceApi(
          context,
          userLatitude,
          userLongitude,
          roleId.toString(),
          userId.toString(),
          eventId,
          encryptedDeviceId,
        );

        if (result == null) throw "Unexpected error";

        ProgressDialog.closeLoadingDialog(context);

        await provider.showSuccessDialog(
          context,
          result['message'],
          result['state'], // ✅ PASS STATE
          true,
        );


      }else{ //when userid is not coming from barcode

        print('UserIDDDDDDD notttttt exist');

        // final String eventLatitude = decoded[0]['Latitude'];
        // final String eventLongitude = decoded[0]['Longitude'];
        final String eventId = decoded[0]['EventId'];


        final String encryptedLatitude = decoded[0]['Latitude'];
        final String encryptedLongitude = decoded[0]['Longitude'];

        print('actual2 Latitude: $encryptedLatitude');
        print('actual2 Longitude: $encryptedLongitude');

        final String eventLatitude = decryptHexUtf16(encryptedLatitude);
        final String eventLongitude = decryptHexUtf16(encryptedLongitude);

        print('Decrypted2 Latitude: $eventLatitude');
        print('Decrypted2 Longitude: $eventLongitude');

        String? deviceId = await UtilityClass.getDeviceId();
        final encryptedDeviceId = encrypt(deviceId ?? "");

        // 📍 Get location
        final position = await LocationService.getCurrentLocation();
        if (position == null) {
          throw "Unable to get location";
        }

        final double userLatitude = position.latitude; //26.915486;
        final double userLongitude = position.longitude; //75.819518;

        print('userLatitude2 lat: $userLatitude');
        print('userLongitude2 long: $userLongitude');

        final user = UserData().model.value;
        print('userdddata: ${user.toJson()}');

        // final distance = calculateDistanceInMeters(
        //   double.parse(eventLatitude),
        //   double.parse(eventLongitude),
        //   userLatitude,
        //   userLongitude,
        // );

        // if (distance > 100) {
        //   throw "You are too far from the location.\nDistance: ${distance.toStringAsFixed(0)} meters";
        // }

        final result = await provider.attendanceApi(
          context,
          userLatitude,
          userLongitude,
          user.roleId.toString(),
          user.userId.toString(),
          eventId,
          encryptedDeviceId,
        );

        if (result == null) throw "Unexpected error";

        ProgressDialog.closeLoadingDialog(context);

        await provider.showSuccessDialog(
          context,
          result['message'],
          result['state'], // ✅ PASS STATE
          false,
        );

      }

    } catch (e) {
      // ❌ ERROR HANDLING
      ProgressDialog.closeLoadingDialog(context);

      showAlertError(e.toString(), context);

      _handled = false;
      await _controller.start();

    } finally {
      // 🛡 SAFETY: Ensure loader is always closed
     // ProgressDialog.closeLoadingDialog(context);
    }
  }


  // Future<void> _onDetect(BarcodeCapture capture) async {
  //   if (_handled) return;
  //   final List<Barcode> barcodes = capture.barcodes;
  //   if (barcodes.isNotEmpty) {
  //     print('barcodeRES: $barcodes');
  //     final String? raw = barcodes.first.rawValue;
  //     if (raw != null && raw.isNotEmpty) {
  //       _handled = true;      // prevent re-entrance
  //       _controller.stop();   // stop camera preview
  //       // show success dialog on same screen; returns true if user tapped OK
  //       final bool? ok = await _showSuccessDialog();
  //
  //       if (ok == true) {
  //         // user pressed OK -> close scanner and return the scanned value
  //         if (mounted) _showSuccessDialog();
  //       } else {
  //         // user tapped close (X) -> resume scanning
  //         _handled = false;
  //         _controller.start();
  //       }
  //     }
  //   }
  // }

//   _onDetect(BarcodeCapture capture) async {
//     // if (_handled) return;
//     print('barcodeRES barcodes: $capture');
//
//     final barcodes = capture.barcodes;
//     print('barcodeRES barcodes: $barcodes');
//     if (barcodes.isEmpty) return;
//
//     // final raw = barcodes;
//     // print('barcodeRES rawValue: $raw'); //https://www.facebook.com/qr/831509950292951
//     final String? raw = capture.barcodes.first.rawValue;
//     print('barcode raw: $raw');
//     //  const barValue =  [{"EventId":"63","EventRegNo":"RJ/JF/2025/155167","Longitude":"75.8189817","Latitude":"26.9154576"}];
// final EventId;
//
//     if (raw != null) {
//       final List decoded = jsonDecode(raw);
//       final String latitude = decoded[0]['Latitude'];
//       EventId = decoded[0]['EventId'];
//       print('📍 Latitude===============>: $latitude');
//
//
//       // final user = UserData().model.value;
//       // print("🔑 User ID: ${user.userId}");
//       // print("👤 JobSeeker ID: ${user.jobSeekerID}");
//       // print("📌 Role ID: ${user.roleId}");
//       // print("📷 QR Data: $raw");
//
//       String? deviceId = await UtilityClass.getDeviceId();
//       print("📷 deviceId: $deviceId");
//
//       // 📍 GET LOCATION HERE
//       final position = await LocationService.getCurrentLocation();
//
//       if (position == null) {
//         showAlertError("Unable to get location", context);
//         _handled = false;
//         _controller.start();
//         return;
//       }
//
//       final double latitude1 = position.latitude;
//       final double longitude = position.longitude;
//
//       print("📍 LAT: $latitude");
//       print("📍 LNG: $longitude");
//
//
//       final user = UserData().model.value;
//       print("🔑 User ID: ${user.userId}");
//       print("👤 JobSeeker ID: ${user.jobSeekerID}");
//       print("📌 Role ID: ${user.roleId}");
//       print("📷 QR Data: $raw");
//       // String? deviceId  = await UtilityClass.getDeviceId();
//       print("📷 deviceId: $deviceId");
//       var rolId = user.roleId;
//       var jobSID = user.jobSeekerID;
//       //var EventId = EventId;
//
//
//       final qrLat = 26.894276;
//       final qrLng = 75.746582;
//
//       //"Longitude":"75.8189817","Latitude":"26.9154576"
//
//       final currentLat = latitude1;
//       final currentLng = longitude;
//
//
//       final distance = calculateDistanceInMeters(
//         qrLat,
//         qrLng,
//         currentLat,
//         currentLng,
//       );
//
//       print("📏 Distance: ${distance.toStringAsFixed(2)} meters");
//
//       if (distance > 100) {
//         showAlertError(
//           "You are too far from the location.\nDistance: ${distance
//               .toStringAsFixed(0)} meters",
//           context,
//         );
//         _handled = false;
//         _controller.start();
//         return;
//       }
//
//       bool? ok = await provider.attendanceApi(
//         context,
//         currentLat,
//         currentLng,
//         rolId.toString(),
//         jobSID.toString(),
//         EventId,
//         deviceId,
//       );
//       if (ok!) {
//         Navigator.of(context).pop(raw);
//       } else {
//         _handled = false;
//         _controller.start();
//       }
//     }
//
//     // if (raw != null && raw.isNotEmpty) {
//     //   _handled = true;
//     //   _controller.stop();
//     //
//     //   final ok = await _showSuccessDialog();
//     //
//     //   if (ok == true) {
//     //     if (mounted) Navigator.pop(context, raw);
//     //   } else {
//     //     _handled = false;
//     //     _controller.start();
//     //   }
//     // }
//   }

  // flutter (23291): barcodeRES rawValue: Event Id:RJ/JF/2025/155167
  // I/flutter (23291): Event Name:Grand Mega JobFair2025
  // I/flutter (23291): Event Description:Mega Job fair for all types Employement
  // I/flutter (23291): Date:2025-12-15 to 2025-12-25
  // I/flutter (23291): Venue:Jaipur rajasthan
  // D/CameraExtImplXiaoMi(23291): releaseCameraDevice: 0

  Future<bool?> _showSuccessDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // force user to tap OK or X
      barrierColor: Colors.black.withOpacity(0.5), // dim background
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close icon (top-right)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(false),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, size: 16, color: Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Green checkmark
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 80),
                ),

                const SizedBox(height: 16),

                // Title (bold)
                const Text(
                  'Successful',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Subtitle paragraph
                const Text(
                  'Attendance marked successfullyaa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 20),

                // OK button
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kViewAllColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    // onPressed: () => Navigator.of(dialogContext).pop(true),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // close dialog
                      Navigator.of(context).pushReplacement( // ✅ replace scanner
                        MaterialPageRoute(builder: (_) => const SelectCompanyPage()),
                      );
                    }, // true = OK pressed
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//   Future<void> _scanFromGallery() async {
//     final picker = ImagePicker();
//     final XFile? file = await picker.pickImage(source: ImageSource.gallery);



//     final position = await LocationService.getCurrentLocation();

//     if (position == null) {
//       showAlertError("Unable to get location", context);
//       _handled = false;
//       _controller.start();
//       return;
//     }

//     final double latitude = position.latitude;
//     final double longitude = position.longitude;

//     print("📍 LAT: $latitude");
//     print("📍 LNG: $longitude");

// final qrLat = 75.8189817;
// final qrLng = 26.9154576;

// final currentLat = latitude;
// final currentLng = longitude;


// final distance = calculateDistanceInMeters(
//   qrLat,
//   qrLng,
//   currentLat,
//   currentLng,
// );

// print("📏 Distance: ${distance.toStringAsFixed(2)} meters");

// if (distance > 100) {
//   showAlertError(
//     "You are too far from the location.\nDistance: ${distance.toStringAsFixed(0)} meters",
//     context,
//   );
//   _handled = false;
//   _controller.start();
//   return;
// }
//     print('barcodeRES gallery file: $file');
//     if (file == null) return;

//     // Prevent camera from producing a detection while we analyze
//     _handled = true;
//     _controller.stop();

//     final result = await _controller.analyzeImage(file.path);

//     if (result?.barcodes.isNotEmpty ?? false) {
//       final String? raw = result!.barcodes.first.rawValue;
//       if (raw != null && raw.isNotEmpty) {




//         final bool? ok = await _showSuccessDialog();
//         if (ok == true) {
//           print('barcode from gallery: $raw');
//           if (mounted) Navigator.of(context).pop(raw);
//           return;
//         } else {
//           // closed dialog -> resume scanning
//           _handled = false;
//           _controller.start();
//           return;
//         }
//       }
//     }

//     // no code found in image -> show a SnackBar and resume scanning
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No QR code found in this image')),
//       );
//     }
//     _handled = false;
//     _controller.start();
//   }



Future <void> scanFromGallery(BuildContext context,  QrScannerScreenProvider provider) async {
  final picker = ImagePicker();
  final XFile? file = await picker.pickImage(source: ImageSource.gallery);

  if (file == null) {
    print("❌ No image selected");
    return;
  }

  // Stop camera while analyzing
  _handled = true;
  _controller.stop();

  // 🔍 Scan QR from image
  final result = await _controller.analyzeImage(file.path);

  if (result == null || result.barcodes.isEmpty) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No QR code found in this image')),
      );
    }
    _handled = false;
    _controller.start();
    return;
  }

  final String? raw = result.barcodes.first.rawValue;
  if (raw == null || raw.isEmpty) {
    _handled = false;
    _controller.start();
    return;
  }

  print("📷 QR Data: $raw");

  // ✅ Example QR Lat/Lng (replace with parsed QR values)
//  37.428788, -122.079303

// 37.4219983, --122.084 emulator current location
  final double qrLat = 37.428788;
  final double qrLng = -122.095;



  // 📍 Get current location
  final position = await LocationService.getCurrentLocation();
  if (position == null) {
    showAlertError("Unable to get location", context);
    _handled = false;
    _controller.start();
    return;
  }

  // final double currentLat = position.latitude;
  // final double currentLng = position.longitude;


final double currentLat = position.latitude;
  final double currentLng = position.longitude;



  print("📍 Current LAT: $currentLat");
  print("📍 Current LNG: $currentLng");

  // 📏 Calculate distance
  final distance = calculateDistanceInMeters(
    qrLat,
    qrLng,
    currentLat,
    currentLng,
  );

  print("📏 Distance: ${distance.toStringAsFixed(2)} meters");

  // 🚨 Distance validation
  if (distance > 2000) {
    showAlertError(
      "You are too far from the location.\nDistance: ${(distance).toStringAsFixed(0)} meters",
      context,
    );
    _handled = false;
    _controller.start();
    return;
  }


  // ✅ Success



// Navigator.of(context).pop(raw);
// final ok = await _showSuccessDialog();



}



double calculateDistanceInMeters(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const earthRadius = 6371000; // meters

  final dLat = _degToRad(lat2 - lat1);
  final dLon = _degToRad(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _degToRad(double deg) => deg * (pi / 180);
}

String decryptHexUtf16(String hex) {
  final bytes = <int>[];

  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }

  final codeUnits = <int>[];
  for (int i = 0; i < bytes.length; i += 2) {
    codeUnits.add(bytes[i] | (bytes[i + 1] << 8));
  }

  return String.fromCharCodes(codeUnits);
}

String encrypt(String text) {
  final bytes = text.codeUnits.expand((unit) {
    return [
      unit & 0xFF,
      (unit >> 8) & 0xFF
    ];
  }).toList();

  final buffer = StringBuffer();
  for (final b in bytes) {
    buffer.write(b.toRadixString(16).padLeft(2, '0').toUpperCase());
  }

  return buffer.toString();
}

