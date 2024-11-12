import 'dart:convert';

import 'package:cinema/common/constants/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(context) => 
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  Map<String, String> _localizedStrings ={};

  Future<bool> load() async {
  try {
    final jsonString = await rootBundle.loadString('assets/languages/${locale.languageCode}.json');
    print('JSON string loaded successfully for locale ${locale.languageCode}');
    
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    // Safely convert jsonMap to Map<String, String>
    _localizedStrings = jsonMap.map((key, value) {
      // Ensure the value is a String
      return MapEntry(key, value.toString());
    });
    
    print('Localization map successfully created for ${locale.languageCode}');
    return true;
  } catch (e) {
    print('Error loading or parsing localization file for ${locale.languageCode}: $e');
    return false;
  }
}


  String? translate(String key) {
    return _localizedStrings[key];
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
       _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return Languages.languages
    .map((e) => e.code)
    .toList()
    .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => 
      false;
}