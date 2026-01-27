import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../job_fair_event/modal/running_event_modal.dart';
import '../modal/fetch_samba_applicatoin_modal.dart';

class MysyPendingListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  MysyPendingListProvider({required this.commonRepo});

  List<FetchSambalApplicationTable1> pendingList = [];

  int page = 1;
  String pageValue = "10";




  Future<FetchSambalApplicationModal?> fetchSambalApplicatoinListApi(BuildContext context,String page,String pageCount) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {

        ProgressDialog.showLoadingDialog(context);
        String url = "MobileProfile/FetchPendingApplicationsListNew/FetchSambalApplicatoinList/${UserData().model.value.userId.toString()}/$page/$pageCount";
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = FetchSambalApplicationModal.fromJson(responseData);
          pendingList.clear();

          if (sm.state == 200) {
            pendingList.addAll(sm.data!.table1!);
            notifyListeners();
            return sm;
          } else {
            final smmm = FetchSambalApplicationModal(state: 0, message: sm.message.toString());
            notifyListeners();
           // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return FetchSambalApplicationModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = FetchSambalApplicationModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  clearData(){
    pendingList.clear();
     notifyListeners();

  }


  @override
  void dispose() {
    super.dispose();
  }


}
