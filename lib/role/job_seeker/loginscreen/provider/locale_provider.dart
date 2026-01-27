import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/repo/common_repo.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/download_registraction_modal.dart';

class LocaleProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  LocaleProvider({required this.commonRepo});


  final String _currentLanguage = 'en';
  String  get currentLanguage  => _currentLanguage;
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  void toggleLocale() {
    _locale = _locale.languageCode == 'en' ?  const Locale('hi') :  const Locale('en');
    notifyListeners();
  }





}
