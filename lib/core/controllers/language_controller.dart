import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final Rx<Locale> locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language') ?? 'en';
    locale.value = Locale(savedLang);
    Get.updateLocale(locale.value);
  }

  Future<void> changeLanguage(String langCode) async {
    locale.value = Locale(langCode);
    Get.updateLocale(locale.value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
  }

  String get currentLanguageCode => locale.value.languageCode;
}