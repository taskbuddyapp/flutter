import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model class for managing UI preference settings
class PreferencesModel extends ChangeNotifier {
  bool _uiBlurEnabled = true; // Default value for UI blur preference
  ThemeMode _themeMode = ThemeMode.system; // Default value for theme mode preference

  bool get uiBlurEnabled => _uiBlurEnabled; // Getter method for accessing the UI blur preference
  ThemeMode get themeMode => _themeMode; // Getter for theme mode (light, dark, system)

  // Method to set the UI blur preference value
  Future<void> setUiBlurEnabled(bool value) async {
    _uiBlurEnabled = value; // Update the internal value
    notifyListeners(); // Notify listeners of the change

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('uiBlurEnabled', value); // Save the preference value
  }

  // Method to set the theme mode preference value
  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value; // Update the internal value
    notifyListeners(); // Notify listeners of the change

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', value.index); // Save the preference value
  }

  // Method to initialize the model with stored preference values
  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _uiBlurEnabled = prefs.getBool('uiBlurEnabled') ?? true; // Get stored value or use default
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0]; // Get stored value or use default
    notifyListeners(); // Notify listeners of the initial value
  }
}