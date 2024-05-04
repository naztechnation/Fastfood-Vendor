import 'package:flutter/material.dart';
import 'package:sixam_mart_store/features/language/domain/models/language_model.dart';
import 'package:sixam_mart_store/features/language/domain/repositories/language_repository_interface.dart';
import 'package:sixam_mart_store/features/language/domain/services/language_service_interface.dart';

class LanguageService implements LanguageServiceInterface {
  final LanguageRepositoryInterface languageRepositoryInterface;
  LanguageService({required this.languageRepositoryInterface});

  @override
  bool setLTR(Locale locale) {
    bool isLtr = true;
    if(locale.languageCode == 'ar') {
      isLtr = false;
    }else {
      isLtr = true;
    }
    return isLtr;
  }

  @override
  void updateHeader(Locale locale) {
    languageRepositoryInterface.updateHeader(locale);
  }

  @override
  Locale getLocaleFromSharedPref() {
    return languageRepositoryInterface.getLocaleFromSharedPref();
  }

  @override
  int setSelectedLanguageIndex(List<LanguageModel> languages, Locale locale) {
    int selectedLanguageIndex = 0;
    for(int index = 0; index<languages.length; index++) {
      if(languages[index].languageCode == locale.languageCode) {
        selectedLanguageIndex = index;
        break;
      }
    }
    return selectedLanguageIndex;
  }

  @override
  void saveLanguage(Locale locale) async {
    languageRepositoryInterface.saveLanguage(locale);
  }

}