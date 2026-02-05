import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';

class ExchangeNameProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  ExchangeNameProvider({required this.commonRepo});


  final TextEditingController exchangeNameCtrl = TextEditingController();

  void setExchangeNameData() {
    print("Echangeeeeeeeeee");
    final data = userModel;
    if (data == null) return;
    final adcbf = data.exchangeName;
    print("dataaaaaa $adcbf");
    exchangeNameCtrl.text = data.exchangeName ?? "";
    notifyListeners();
  }

}
