import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../constants/constants.dart';
import '../../../../repo/common_repo.dart';
import '../../../../services/HttpService.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../model/common_response_model.dart';
import '../model/quick_service_model.dart';

class ChatProvider with ChangeNotifier{

  List<ActionData> originalStatusList = [];

  final CommonRepo commonRepo;


  ChatProvider({required this.commonRepo});



  Future<void> getStatus(BuildContext context, QuickServiceModel? item) async {
    originalStatusList.clear();
    try {
      HttpService http = HttpService(context, Constants.baseurl);
      String? deviceId = await UtilityClass.getDeviceId();

      Map<String, dynamic> body = {
          "UserId": UserData().model.value.userId,
          "JobSeekerId": UserData().model.value.jobSeekerID,
          "RegistrationNo":  UserData().model.value.registrationNumber,
          "DeviceId": deviceId,
          "FAQAssistanceId": item?.fAQAssistanceId,
          "ParentId": item?.parentID,
          "EnumName": item?.enumName,
          "RoleId": UserData().model.value.roleId,

      };
      Response response = await http.postRequest(Constants.getFAQAssistanceDetail, body);
      CommonResponseModel<ActionData> responseData = CommonResponseModel.fromJson(response.data, (json) => ActionData.fromJson(json));
     // FaqsAssistanceModel responseData = FaqsAssistanceModel.fromJson(response.data);
      if (responseData.status == true && responseData.data != null && responseData.state == 200) {
        originalStatusList = responseData.data ?? [];
        notifyListeners();
      }
      else {
        await UtilityClass.askForInput("Alert", responseData.message ?? 'Unable to load data', "Okay", "Okay", true,);
      }
    }
    catch (e) {
     await  UtilityClass.askForInput("Alert", 'Unable to load data. Check your connection and try again.', "Okay", "Okay", true,);
    }
  }
void clearData(){
  originalStatusList.clear();
  notifyListeners();
}

}