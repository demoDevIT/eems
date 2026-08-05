import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../repo/common_repo.dart';
import '../modal/mysy_list_model.dart';

class MysyListProvider extends ChangeNotifier {

  final CommonRepo commonRepo;
  MysyListProvider({required this.commonRepo});

  List<MysyData> mysyList = [];
  bool isLoading = false;

  Future<void> getMysyListApi(BuildContext context) async {
    isLoading = true;
    mysyList.clear();
    notifyListeners();
    final userId = UserData().model.value.userId; //"6995"; // UserData().model.value.userId;

    // final apiResponse = await commonRepo.get(
    //     "Common/FetchPendingApplicationsListNew/FetchSambalApplicatoinListByJobSeelerId/$userId/0/0");

    Map<String, dynamic> body = {
      "ActionKey": "FetchSambalApplicatoinListByJobSeelerId",
      "UserId": userId,
      "Page": 0,
      "PageSize": 0,
      "RoleId": 0,
      "FYID": 0
    };

    ApiResponse apiResponse = await commonRepo.post("Common/FetchPendingApplicationsListNew",body);

    if (apiResponse.response?.statusCode == 200) {
      dynamic data = apiResponse.response!.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      MysyListModel model = MysyListModel.fromJson(data);

      if (model.data != null) {
        mysyList = model.data!;
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
