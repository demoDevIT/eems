import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:easy_video_editor/easy_video_editor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/main.dart';
import 'package:rajemployment/utils/location_service.dart';
import 'package:rajemployment/utils/utility_class.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../constants/constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/user_new.dart';
import '../../add_language_skills/modal/upload_document_modal.dart';


class CameraProvider with ChangeNotifier {

  final CommonRepo commonRepo;

  CameraProvider({required this.commonRepo});

  int currentStep = 1;
  final int totalSteps = 3;
  var mergedPath;
  Map<int, String> recordedVideos = {};
  Map<int, Duration> videoDurations = {}; // store duration per step
  final locationService = LocationService();

  File? videoFile;
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  bool isMerging = false;

  /// Record and compress video
  Future<void> recordVideo(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 15),
    );

    if (picked != null) {
      videoFile = File(picked.path);
      UtilityClass.showProgressDialogVideo(context,"Loading video...");

      // Compress video using video_compress
      final info = await VideoCompress.compressVideo(
        videoFile!.path,
        quality: VideoQuality.LowQuality,
        deleteOrigin: false,
        includeAudio: true,
      );

      UtilityClass.dismissProgressDialog();

      if (info == null || info.file == null) return;

      File compressedFile = info.file!;
      debugPrint("✅ Compressed Video Path: ${compressedFile.path}");
      debugPrint("📏 Size: ${compressedFile.lengthSync() / 1024} KB");

      // Get video duration
      final videoController = VideoPlayerController.file(compressedFile);
      await videoController.initialize();
      final duration = videoController.value.duration;

      // Save path and duration
      recordedVideos[currentStep] = compressedFile.path;
      videoDurations[currentStep] = duration;

      currentStep++;
      videoFile = null;
      debugPrint("Recorded videos: ${recordedVideos.values.toList()}");

      mergeAndLoad(recordedVideos.values.toList(),context);


     // mergeAndLoad(recordedVideos.values.toList(), context);
      notifyListeners();
    }
  }

  /// Merge videos

  Future<void> mergeAndLoad(List<String> paths, BuildContext context) async {
    if (paths.isEmpty) return;

    isMerging = true;
    notifyListeners();
     UtilityClass.showProgressDialogVideo(context,"Loading video...");
    try {
      final editor = VideoEditorBuilder(videoPath: paths[0]).merge(otherVideoPaths: paths.sublist(1));
      final String outputPath = '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_merged.mp4';
      debugPrint('Merge output path: $outputPath');
      mergedPath = await editor.export(
        outputPath: outputPath,
        onProgress: (progress) {
          debugPrint('Merge progress: ${(progress * 100).toStringAsFixed(1)}%');
        },
      );
      UtilityClass.dismissProgressDialog();
      if (mergedPath != null) {
        videoPlayerController = VideoPlayerController.file(File(mergedPath))
          ..initialize().then((_) {
            chewieController = ChewieController(
              videoPlayerController: videoPlayerController!,
              autoPlay: true,
              looping: false,
            );
            isMerging = false;
            notifyListeners();
          });
      } else {
        isMerging = false;
        notifyListeners();
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();

      isMerging = false;
      debugPrint("❌ Error merging via easy_video_editor: $e");
    }
  }



  /// Step card widget
  Widget buildStepCard(int step, String title, BuildContext context) {
    bool isActive = step == currentStep;
    bool isDone = recordedVideos.containsKey(step);
    Duration? duration = videoDurations[step];

    return GestureDetector(
      onTap: isActive ? () => recordVideo(context) : null, // ✅ FIXED
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.blue.shade50
              : isDone ? kWhite
              : kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.blue : kPrimaryColor,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              "Step $step",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDone ?  Colors.red: isActive ? Colors.blue : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 15),
            SizedBox(
               height:30,
               width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: kWhite
                ),
                  onPressed: isActive ? () => recordVideo(context) : null, child:duration != null? Text("${duration?.inSeconds}s",style: UtilityClass.poppins(fontSize: 15, fontWeight: FontWeight.normal, color: kWhite),): Text("Record",style: UtilityClass.poppins(fontSize: 15, fontWeight: FontWeight.normal, color: kWhite),),
              ),

            ),
          ],
        ),
      ),
    );
  }

  Widget buildUpload(BuildContext context) {
    bool isActive = 4 == currentStep;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:kPrimaryColor,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        SizedBox(
        width: 150 ,
        height:30,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: kWhite,
          ),
          onPressed: isActive ? () async {

            if(mergedPath != null){
              await uploadVideo(context, mergedPath);
            }
            else{
              print("fjdfdlkfdlkfl");
            }

          }: null,
          child: Text(
            "Upload Video",
            style: UtilityClass.poppins(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: kWhite,
            ),
          )
      ),),

      ],
      ),
    );
  }


  /// Show progress dialog
   showProgressDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  /// Hide progress dialog
  void hideProgressDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.canPop(navigatorKey.currentState!.context,)) {
        Navigator.of(navigatorKey.currentState!.context, rootNavigator: true).pop();
      }
    });
  }
  @override
  void dispose() {
    chewieController?.dispose();
    videoPlayerController?.dispose();
    currentStep=0;
    recordedVideos={};
    videoDurations ={};
    super.dispose();
  }


  Future<UploadDocumentModal?> uploadVideo(BuildContext context, var mergedPath) async {
    print("fldfldlfdl");
    bool isInternet = await UtilityClass.checkInternetConnectivity();

    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return UploadDocumentModal(state: 0, message: "No Internet");
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      String? ipAddress = await UtilityClass.getIpAddress();
      String? deviceId  = await UtilityClass.getDeviceId();
      String? appVersion = await UtilityClass.getApkVersion();

      // 📍 Get location
      final position = await LocationService.getCurrentLocation();
      if (position == null) {
        throw "Unable to get location";
      }

      final double userLatitude = position.latitude; //26.915486;
      final double userLongitude = position.longitude; //75.819518;

      print('userLatitude2 lat: $userLatitude');
      print('userLongitude2 long: $userLongitude');

      FormData formData = FormData.fromMap({
        'FolderName': 'VideoProfile',
        'FileExtension': "mp4",
        'MinFileSize': '1kb',
        'MaxFileSize': '10MB',
        'UserId': UserData().model.value.userId.toString(), //'1781',
        'Mobile_IP': ipAddress,
        'Mobile_Mac': deviceId,  // update this
        'DeviceId': deviceId,
        'AppVersion': appVersion,
        'Lat': userLatitude, //"37.4219983",
        'Long': userLongitude, //"-122.084",
        "File": await MultipartFile.fromFile(
          mergedPath,
          filename: "Video.mp4",
        ),
      });
      // Map<String, dynamic> fields = {
      //   'FolderName': 'VideoProfile',
      //   'FileExtension': "mp4",
      //   'MinFileSize': '1kb',
      //   'MaxFileSize': '10MB',
      //   'UserId': '1781',
      //   'Mobile_IP': ipAddress,
      //   'Mobile_Mac': deviceId,  // update this
      //   'DeviceId': deviceId,
      //   'AppVersion': appVersion,
      //   'Lat': "37.4219983",
      //   'Long': "-122.084",
      //   "File": await MultipartFile.fromFile( mergedPath, filename: "Video.mp4",
      //   ),
      // };
      print("fldfldlf--dl");
     // FormData param = FormData.fromMap(fields);

      Response response = await commonRepo.postRequestMultipart(
          Constants.UploadVideo, formData);

      ProgressDialog.closeLoadingDialog(context);
      print("videoProfileResss=>$response");

      if (response.data["Success"] == true) {
        // ✅ Success → go back
        Navigator.pop(context, true); // pass true if you want
      } else {
        showAlertError(
          response.data["Message"] ?? "Upload failed",
          context,
        );
      }

      // if (apiResponse.response?.statusCode == 200) {
      //   var responseData = apiResponse.response?.data;
      //
      //   if (responseData is String) {
      //     responseData = jsonDecode(responseData);
      //   }
      //
      //   return UploadDocumentModal.fromJson(responseData);
      // } else {
      //   showAlertError("Something went wrong", context);
      //   return UploadDocumentModal(state: 0, message: "Something went wrong");
      // }

    } catch (err) {
      ProgressDialog.closeLoadingDialog(context);
      print(err);
      showAlertError(err.toString(), context);
      return UploadDocumentModal(state: 0, message: err.toString());
    }
  }



/*
  Future<void> uploadVideo(BuildContext buildContext, mergedPath) async {
    try {
    HttpService http = HttpService(buildContext, Constants.baseurl);
    String ? IpAddress =  await UtilityClass.getIpAddress();
    String ? DeviceId =  await UtilityClass.getDeviceId();
    String ? ApkVersion =  await UtilityClass.getApkVersion();
    Position ? CurrentLocation =  await LocationService.getCurrentLocation();
    FormData formData = FormData.fromMap({
      'FolderName': 'VideoProfile',
      'FileExtention': "mp4",
      'MinFileSize': '1kb',
      'MaxFileSize': '10MB',
      'UserId': '1781',
      'Mobile_IP':IpAddress,
      'Mobile_Mac': '1781',
      'DeviceId': DeviceId,
      'AppVersion': ApkVersion,
      'Lat':CurrentLocation!.latitude.toString(),
      'Long': CurrentLocation!.longitude.toString(),
      "File": await MultipartFile.fromFile(mergedPath, filename:  "Video.mp4"),

    });
    // Debug print fields
    formData.fields.forEach((field) {
      print("${field.key}: ${field.value}");
    });

       Response response = await http.postRequestMultipart(Constants.UploadVideo, formData);
       print("response$response");
       UploadResponse responseData = UploadResponse.fromJson(response.data);
       print("dfasfdsadfsadf${responseData.success}");

    if (responseData.success) {
        print("dfasfdsadfsadf");
      bool status =  await UtilityClass.showSuccessDialog(
            "Alert",
            responseData.message.toString(),
            "Okay",
            "Okay",
            true);
        if(!status){
          clearData();
        Navigator.pop(buildContext,"true");}

      } else {

        UtilityClass.askForInput(
            "Alert",
            responseData.message.toString(),
            "Okay",
            "Okay",
            true);
      }
      notifyListeners();
    } catch (e, s) {
      UtilityClass.askForInput(
          "Alert",
          'Unable to load data.Check your connection and try again. ',
          "Okay",
          "Okay",
          true);
    }
  }
*/
  clearData(){
    currentStep = 1;
    recordedVideos.clear();
    videoDurations.clear();
    mergedPath="";
    notifyListeners();
  }
}
