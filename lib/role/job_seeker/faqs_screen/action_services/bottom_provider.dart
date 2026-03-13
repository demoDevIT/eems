import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../constants/constants.dart';
import '../../../../repo/common_repo.dart' show CommonRepo;
import '../../../../services/HttpService.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../model/common_response_model.dart';
import '../model/faqs_assistance_model.dart';
import '../model/quick_service_model.dart';

class BottomProvider with ChangeNotifier{
  List<FaqsAssistanceData> faqListTitle=[];
  List<FaqsAssistanceData> faqListCompany=[];
  List<FaqsAssistanceData> faqListSector=[];
  List<ActionData> originalStatusList = [];

  String selectedChip="";
  String? selectedId;
  final CommonRepo commonRepo;


  BottomProvider({required this.commonRepo});


  void faqListTitleUpdate(BuildContext context, FaqsAssistanceData item) {

    selectedId = item.fAQAssistanceId;
    Locale locale = Localizations.localeOf(context);
    selectedChip = locale.languageCode == "en" ? item.faqAssistanceEng ?? "" : item.faqAssistanceHi ?? "";
    getFaqs(context, item.fAQAssistanceId, "", "2",item);
    notifyListeners();
  }

  Future<void> getFaqs(BuildContext context ,String? parentId,String faqAssistanceId,String status,dynamic item) async {
    try {
      HttpService http = HttpService(context, Constants.baseurl);
      String? deviceId = await UtilityClass.getDeviceId();

      Map<String, dynamic>? body;
      String url= status == "1"? Constants.getFAQAssistanceQuestions: Constants.getFAQAssistanceDetail;
       body = status == "1" ? {'ParentId': parentId, 'FAQAssistanceId':faqAssistanceId,}:{
          "UserId": UserData().model.value.userId,
          "JobSeekerId": UserData().model.value.jobSeekerID,
          "RegistrationNo":  UserData().model.value.registrationNumber,
          "DeviceId": deviceId,
          "FAQAssistanceId": item?.fAQAssistanceId,
          "ParentId": item?.parentID,
          "EnumName": item?.enumName,
          "RoleId": UserData().model.value.roleId,
        };
      Response response = await http.postRequest(url, body);
       if(status == "1"){
      FaqsAssistanceModel responseData = FaqsAssistanceModel.fromJson(response.data);
      if (responseData.status == true && responseData.dataFaqs != null && responseData.state == 200) {
          faqListTitle = responseData.dataFaqs ?? [];
          faqListCompany.clear();
          faqListSector.clear();

        notifyListeners();
      }
      else {
        faqListCompany.clear();
        faqListSector.clear();
        await UtilityClass.askForInput("Alert", responseData.message ?? 'Unable to load data', "Okay", "Okay", true,);
      }
      notifyListeners();
    }else if(status == "2"){
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
    }
    catch (e) {
      await  UtilityClass.askForInput("Alert", 'Unable to load data. Check your connection and try again.', "Okay", "Okay", true,);
    }
  }

  clearData() {
    faqListTitle.clear();
    faqListCompany.clear();
    faqListSector.clear();
    originalStatusList.clear();
    selectedChip = "";
      selectedId = null;
    notifyListeners();
  }

}