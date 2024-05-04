import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/language/domain/models/language_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/language/domain/services/language_service_interface.dart';

class LocalizationController extends GetxController implements GetxService {
  final LanguageServiceInterface languageServiceInterface;
  LocalizationController({required this.languageServiceInterface}){
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  Locale get locale => _locale;

  bool _isLtr = true;
  bool get isLtr => _isLtr;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = languageServiceInterface.setLTR(_locale);
    languageServiceInterface.updateHeader(_locale);
    saveLanguage(_locale);
    if(Get.find<AuthController>().isLoggedIn()){
      Get.find<StoreController>().getItemList('1', 'all');
    }
    update();
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void loadCurrentLanguage() async {
    _locale = languageServiceInterface.getLocaleFromSharedPref();
    _isLtr = _locale.languageCode != 'ar';
    _selectedIndex = languageServiceInterface.setSelectedLanguageIndex(AppConstants.languages, _locale);
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    languageServiceInterface.saveLanguage(locale);
  }

}