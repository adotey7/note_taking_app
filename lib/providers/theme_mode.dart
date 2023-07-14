import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToggleTheme with ChangeNotifier {
  ToggleTheme() {
    getThemeAtInit();
  }
  ThemeMode? currentTheme;
  bool _currentThemeMode = true;

  bool get themeMode => _currentThemeMode;
  getThemeAtInit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? chosenTheme = sharedPreferences.getBool('current_theme');
    _currentThemeMode = chosenTheme!;
    if (chosenTheme) {
      currentTheme = ThemeMode.dark;
      _currentThemeMode = currentTheme == ThemeMode.dark;
    } else {
      currentTheme = ThemeMode.light;
      _currentThemeMode = currentTheme == ThemeMode.dark;
    }
    notifyListeners();
  }

  void toggleDarkTheme(bool isDark) async {
    currentTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    _currentThemeMode = isDark ? true : false;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('current_theme', _currentThemeMode);
  }

  // void toggleLightTheme() async {
  //   currentTheme = ThemeMode.light;
  //   notifyListeners();
  //   // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   // sharedPreferences.setBool('current_theme', currentTheme == ThemeMode.light);
  // }
}
