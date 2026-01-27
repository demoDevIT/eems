import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rajemployment/constants/constants.dart';
import 'package:rajemployment/main.dart';
import 'package:rajemployment/services/HttpService.dart';
import 'package:rajemployment/utils/location_service.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../../../repo/common_repo.dart';
import '../../camera/model/video_profile_response.dart';

class VideoprofileProvider with ChangeNotifier{

    final CommonRepo commonRepo;

    VideoprofileProvider({required this.commonRepo});



    List<VideoData> VideoPath = [];


Future<void> getVideo(BuildContext context) async {
    try{
    HttpService http = HttpService(context, Constants.baseurl);
    String ? IpAddress =  await UtilityClass.getIpAddress();
    String ? DeviceId =  await UtilityClass.getDeviceId();
    String ? ApkVersion =  await UtilityClass.getApkVersion();
    Position ? CurrentLocation =  await LocationService.getCurrentLocation();
    Map<String, dynamic> body = {
        'Action': 'GetVideoProfile',
        'UserID': '1781'
    };
    Response response = await http.postRequest(Constants.GetBasicDetails, body);
    print("response$response");
    VideoProfileResponse responseData = VideoProfileResponse.fromJson(response.data);
    if (responseData.status) {
        VideoPath=responseData.data;
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
}